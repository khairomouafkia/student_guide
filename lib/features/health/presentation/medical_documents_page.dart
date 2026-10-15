import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/error_text.dart';
import '../../../core/widgets/state_views.dart';
import '../../../l10n/app_localizations.dart';
import '../data/health_repository.dart';
import 'health_providers.dart';

class MedicalDocumentsPage extends ConsumerWidget {
  const MedicalDocumentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final async = ref.watch(myDocumentsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(t.medicalDocuments)),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.upload_file),
        label: Text(t.uploadDocument),
        onPressed: () => showModalBottomSheet(context: context, isScrollControlled: true, showDragHandle: true, builder: (_) => const _UploadSheet()),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(children: [
                Icon(Icons.lock_outline, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 10),
                Expanded(child: Text(t.sensitiveNote, style: Theme.of(context).textTheme.bodySmall)),
              ]),
            ),
          ),
        ),
        Expanded(
          child: async.when(
            loading: () => const LoadingView(),
            error: (e, _) => ErrorView(message: errorText(t, e), onRetry: () => ref.invalidate(myDocumentsProvider)),
            data: (docs) => docs.isEmpty
                ? EmptyView(icon: Icons.description_outlined, title: t.noDocuments)
                : RefreshIndicator(
                    onRefresh: () async => ref.refresh(myDocumentsProvider.future),
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
                      itemCount: docs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, i) => _DocCard(docs[i]),
                    ),
                  ),
          ),
        ),
      ]),
    );
  }
}

class _DocCard extends StatelessWidget {
  const _DocCard(this.d);
  final MedicalDoc d;
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final (label, color) = d.overdue
        ? (t.docOverdue, const Color(0xFFD64545))
        : switch (d.status) {
            'PENDING' => (t.docPending, const Color(0xFFF08A24)),
            'UNDER_REVIEW' => (t.docUnderReview, const Color(0xFF0B4DA2)),
            'APPROVED' => (t.docApproved, const Color(0xFF2E9D5B)),
            _ => (t.docRejected, const Color(0xFFD64545)),
          };
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(d.type == 'sick_leave' ? t.docSickLeave : t.docMedicalCertificate, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(20)),
              child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
            ),
          ]),
          const SizedBox(height: 2),
          Text(DateFormat.yMMMd(locale).add_Hm().format(d.uploadedAt), style: Theme.of(context).textTheme.bodySmall),
          if (d.isOpen) ...[
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.schedule, size: 18),
              const SizedBox(width: 6),
              Expanded(child: Text(d.overdue ? t.reviewWithin72 : '${t.reviewWithin72} (${t.hoursLeft(d.hoursLeft ?? 0)})')),
            ]),
          ],
          if (d.rejectionReason != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(t.rejectionReason(d.rejectionReason!), style: TextStyle(color: Theme.of(context).colorScheme.error))),
          if (d.comment != null) Padding(padding: const EdgeInsets.only(top: 4), child: Text(t.reviewerComment(d.comment!))),
        ]),
      ),
    );
  }
}

class _UploadSheet extends ConsumerStatefulWidget {
  const _UploadSheet();
  @override
  ConsumerState<_UploadSheet> createState() => _UploadSheetState();
}

class _UploadSheetState extends ConsumerState<_UploadSheet> {
  String _type = 'medical_certificate';
  PlatformFile? _file;
  bool _busy = false;
  String? _error;

  Future<void> _pick() async {
    final r = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'], withData: true);
    if (r != null && r.files.isNotEmpty) setState(() { _file = r.files.first; _error = null; });
  }

  Future<void> _send() async {
    final t = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final f = _file;
    if (f == null || f.bytes == null) return;
    if (f.size > 5 * 1024 * 1024) return setState(() => _error = t.errFileTooLarge);
    setState(() { _busy = true; _error = null; });
    try {
      await ref.read(healthRepositoryProvider).upload(bytes: f.bytes!, filename: f.name, documentType: _type);
      ref.invalidate(myDocumentsProvider);
      if (mounted) Navigator.pop(context);
      messenger.showSnackBar(SnackBar(content: Text('${t.uploadSuccess}. ${t.reviewWithin72}')));
    } catch (e) {
      if (mounted) setState(() { _busy = false; _error = errorText(t, e); });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(t.uploadDocument, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Text(t.selectType, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'medical_certificate', label: Text(t.docMedicalCertificate)),
              ButtonSegment(value: 'sick_leave', label: Text(t.docSickLeave)),
            ],
            selected: {_type},
            onSelectionChanged: (s) => setState(() => _type = s.first),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            icon: const Icon(Icons.attach_file),
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
            onPressed: _busy ? null : _pick,
            label: Text(_file?.name ?? t.chooseFile, overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(height: 8),
          Text(t.reviewWithin72, style: Theme.of(context).textTheme.bodySmall),
          if (_error != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error))),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: (_file == null || _busy) ? null : _send,
            child: _busy ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2.5)) : Text(t.upload),
          ),
        ]),
      ),
    );
  }
}
