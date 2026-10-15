import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/utils/error_text.dart';
import '../../../l10n/app_localizations.dart';
import '../data/admin_api.dart';
import '../framework/helpers.dart';
import '../framework/resource_config.dart';

Future<void> _call(BuildContext context, Future<dynamic> Function() f, String okText) async {
  final t = AppLocalizations.of(context)!;
  final m = ScaffoldMessenger.of(context);
  try { await f(); m.showSnackBar(SnackBar(content: Text(okText))); } catch (e) { m.showSnackBar(SnackBar(content: Text(errorText(t, e)))); }
}

Future<void> _review(BuildContext context, WidgetRef ref, Json row, String action) async {
  final t = AppLocalizations.of(context)!;
  String reason = '', comment = '';
  if (action != 'start_review') {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final formKey = GlobalKey<FormState>();
        return AlertDialog(
          title: Text(action == 'approve' ? t.mdApprove : t.mdReject),
          content: SizedBox(
            width: 460,
            child: Form(key: formKey, child: Column(mainAxisSize: MainAxisSize.min, children: [
              if (action == 'reject')
                TextFormField(decoration: InputDecoration(labelText: t.mdReason), maxLines: 2, onChanged: (v) => reason = v, validator: (v) => (v ?? '').trim().length < 3 ? t.requiredField : null),
              const SizedBox(height: 12),
              TextFormField(decoration: InputDecoration(labelText: t.mdComment), maxLines: 3, onChanged: (v) => comment = v),
            ])),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(t.cancelAction)),
            FilledButton(style: FilledButton.styleFrom(minimumSize: const Size(100, 44)), onPressed: () { if (formKey.currentState!.validate()) Navigator.pop(ctx, true); }, child: Text(t.save)),
          ],
        );
      },
    );
    if (ok != true || !context.mounted) return;
  }
  await _call(context, () => ref.read(adminApiProvider).patch('/medical-documents/${row['id']}/review', body: {
        'action': action,
        if (comment.trim().isNotEmpty) 'comment': comment.trim(),
        if (action == 'reject') 'rejectionReason': reason.trim(),
      }), t.mdDone);
}

String _statusLabel(AppLocalizations t, Json r) => r['overdue'] == true ? t.docOverdue : switch (r['status']) { 'APPROVED' => t.docApproved, 'REJECTED' => t.docRejected, 'UNDER_REVIEW' => t.docUnderReview, _ => t.docPending };

final medicalConfig = ResourceConfig(
  title: (t) => t.mMedicalReview,
  endpoint: '/medical-documents',
  hasSearch: false, canCreate: false, canEdit: false, canDelete: false,
  banner: (t) => t.mdSensitive,
  defaultSort: null,
  filters: [
    FilterSpec('status', (t) => t.fStatus, FilterType.select, options: [
      Opt('PENDING', (t) => t.docPending), Opt('UNDER_REVIEW', (t) => t.docUnderReview), Opt('APPROVED', (t) => t.docApproved), Opt('REJECTED', (t) => t.docRejected)]),
    FilterSpec('overdue', (t) => t.mdOverdueOnly, FilterType.select, options: [Opt('true', (t) => t.yes)]),
  ],
  columns: [
    ColumnSpec((t) => t.fStudent, (r, t) => '${cell(dig(r, 'student.fullName'))} · ${cell(dig(r, 'student.registrationNumber'))}'),
    ColumnSpec((t) => t.fType, (r, t) => r['documentType'] == 'sick_leave' ? t.docSickLeave : t.docMedicalCertificate),
    ColumnSpec((t) => t.fStatus, (r, t) => _statusLabel(t, r)),
    ColumnSpec((t) => t.fCreated, (r, t) => stamp(r['uploadedAt'], null)),
    ColumnSpec((t) => t.mdDeadline, (r, t) => r['hoursLeft'] != null ? t.hoursLeft(r['hoursLeft'] as int) : stamp(r['reviewedAt'], null)),
    ColumnSpec((t) => t.mdEscalated, (r, t) => r['escalated'] == true ? t.yes : '—'),
  ],
  rowActions: [
    RowAction(Icons.open_in_new, (t) => t.mdOpenFile, (context, ref, row) async {
      final t = AppLocalizations.of(context)!;
      final m = ScaffoldMessenger.of(context);
      try {
        final d = await ref.read(adminApiProvider).get('/medical-documents/${row['id']}/file');
        await launchUrl(Uri.parse(d['url'] as String), mode: LaunchMode.externalApplication);   // signed link, 60 s; the access is audited
      } catch (e) { m.showSnackBar(SnackBar(content: Text(errorText(t, e)))); }
    }),
    RowAction(Icons.play_arrow, (t) => t.mdStartReview, (c, r, row) => _review(c, r, row, 'start_review'), visible: (r) => r['status'] == 'PENDING'),
    RowAction(Icons.check_circle_outline, (t) => t.mdApprove, (c, r, row) => _review(c, r, row, 'approve'), visible: (r) => r['status'] == 'PENDING' || r['status'] == 'UNDER_REVIEW'),
    RowAction(Icons.cancel_outlined, (t) => t.mdReject, (c, r, row) => _review(c, r, row, 'reject'), visible: (r) => r['status'] == 'PENDING' || r['status'] == 'UNDER_REVIEW'),
    RowAction(Icons.priority_high, (t) => t.mdEscalate, (context, ref, row) async {
      final t = AppLocalizations.of(context)!;
      await _call(context, () => ref.read(adminApiProvider).post('/medical-documents/${row['id']}/escalate'), t.mdDone);
    }, visible: (r) => r['overdue'] == true && r['escalated'] != true),
  ],
);
