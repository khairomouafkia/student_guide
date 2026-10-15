import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/utils/error_text.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../complaints/presentation/status_chip.dart';
import '../data/admin_api.dart';
import '../framework/helpers.dart';
import '../framework/resource_config.dart';

const _statuses = ['NEW', 'RECEIVED', 'IN_PROGRESS', 'RESOLVED', 'CLOSED'];
const _transitions = {
  'NEW': ['RECEIVED', 'IN_PROGRESS', 'RESOLVED', 'CLOSED'],
  'RECEIVED': ['IN_PROGRESS', 'RESOLVED', 'CLOSED'],
  'IN_PROGRESS': ['RESOLVED', 'CLOSED'],
  'RESOLVED': ['IN_PROGRESS', 'CLOSED'],
  'CLOSED': <String>[],
};
const _categories = ['restaurant', 'transport', 'residence', 'health', 'library', 'activities', 'other'];
const _priorities = ['LOW', 'MEDIUM', 'HIGH', 'CRITICAL'];

String statusLabel(AppLocalizations t, String s) => switch (s) {
      'NEW' => t.statusNew, 'RECEIVED' => t.statusReceived, 'IN_PROGRESS' => t.statusInProgress, 'RESOLVED' => t.statusResolved, _ => t.statusClosed };

/// Inbox list. Rows open the detail dialog. The backend already limits the rows to what this role may see.
ResourceConfig complaintsInboxConfig() => ResourceConfig(
      title: (t) => t.complaints,
      endpoint: '/complaints',
      canCreate: false, canEdit: false, canDelete: false,
      filters: [
        FilterSpec('status', (t) => t.fStatus, FilterType.select, options: [for (final s in _statuses) Opt(s, (t) => statusLabel(t, s))]),
        FilterSpec('priority', (t) => t.ciPriority, FilterType.select, options: [for (final p in _priorities) Opt(p, (t) => priorityLabel(t, p))]),
        FilterSpec('category', (t) => t.complaintCategory, FilterType.select, options: [for (final c in _categories) Opt(c, (t) => complaintCategoryLabel(t, c))]),
        FilterSpec('assigned', (t) => t.ciAssigned, FilterType.select, options: [Opt('me', (t) => t.ciMine), Opt('unassigned', (t) => t.ciUnassigned)]),
        FilterSpec('recurring', (t) => t.ciOnlyRecurring, FilterType.select, options: [Opt('true', (t) => t.yes)]),
        FilterSpec('sort', (t) => t.sortBy, FilterType.select, options: [Opt('priority', (t) => t.ciSortPriority), Opt('newest', (t) => t.ciSortNewest), Opt('oldest', (t) => t.ciSortOldest)]),
      ],
      columns: [
        ColumnSpec((t) => t.ciPriority, (r, t) => priorityLabel(t, r['priority'] as String?), chip: true),
        ColumnSpec((t) => t.complaintSubject, (r, t) => '${r['ai_recurring'] == true ? '🔁 ' : ''}${r['duplicate_of'] != null ? '⧉ ' : ''}${cell(r['subject'])}'),
        ColumnSpec((t) => t.complaintCategory, (r, t) => complaintCategoryLabel(t, '${r['category']}')),
        ColumnSpec((t) => t.ciSuggestedDept, (r, t) => r['ai_suggested_department'] == null ? '—' : complaintCategoryLabel(t, '${r['ai_suggested_department']}')),
        ColumnSpec((t) => t.fStatus, (r, t) => statusLabel(t, '${r['status']}')),
        ColumnSpec((t) => t.fCreated, (r, t) => stamp(r['created_at'], null)),
      ],
      onRowTap: (context, ref, row) => showDialog(context: context, builder: (_) => Dialog(insetPadding: const EdgeInsets.all(16), child: _ComplaintDetail(id: '${row['id']}'))),
    );

class _ComplaintDetail extends ConsumerStatefulWidget {
  const _ComplaintDetail({required this.id});
  final String id;
  @override
  ConsumerState<_ComplaintDetail> createState() => _ComplaintDetailState();
}

class _ComplaintDetailState extends ConsumerState<_ComplaintDetail> {
  Json? _d;
  List<Json> _similar = [];
  Object? _error;
  bool _busy = false, _internal = false;
  final _reply = TextEditingController();

  AdminApi get _api => ref.read(adminApiProvider);
  bool get _manager => const ['super_admin', 'complaints_admin'].contains(ref.read(authControllerProvider).user?.role);

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _reply.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final d = Json.from(await _api.get('/complaints/${widget.id}') as Map);
      List<Json> sim = [];
      try { sim = [for (final e in await _api.get('/complaints/${widget.id}/similar') as List) Json.from(e as Map)]; } catch (_) {}
      if (mounted) setState(() { _d = d; _similar = sim; _error = null; });
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _run(Future<dynamic> Function() f) async {
    final t = AppLocalizations.of(context)!;
    final m = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try { await f(); await _load(); } catch (e) { m.showSnackBar(SnackBar(content: Text(errorText(t, e)))); } finally { if (mounted) setState(() => _busy = false); }
  }

  Future<void> _patch(Json body) => _run(() => _api.patch('/complaints/${widget.id}', body: body));

  Future<void> _send() async {
    final text = _reply.text.trim();
    if (text.isEmpty) return;
    await _run(() async { await _api.post('/complaints/${widget.id}/replies', body: {'message': text, if (_internal) 'internal': true}); _reply.clear(); });
  }

  Future<void> _attachments() async {
    final urls = [for (final a in await _api.get('/complaints/${widget.id}/attachments') as List) a['url'] as String];
    for (final u in urls) { await launchUrl(Uri.parse(u), mode: LaunchMode.externalApplication); }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final me = ref.watch(authControllerProvider).user;
    final d = _d;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1000, maxHeight: 760),
      child: d == null
          ? SizedBox(height: 240, child: Center(child: _error != null ? Text(errorText(t, _error!)) : const CircularProgressIndicator()))
          : Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
                child: Row(children: [
                  Expanded(child: Text('${d['subject']}', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700))),
                  if (_busy) const Padding(padding: EdgeInsets.all(8), child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ]),
              ),
              Expanded(
                child: LayoutBuilder(builder: (context, box) {
                  final left = _left(context, t, d);
                  final right = _right(context, t, d, me?.id);
                  return box.maxWidth > 760
                      ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 3, child: left), SizedBox(width: 340, child: right)])
                      : ListView(children: [SizedBox(height: 420, child: left), right]);
                }),
              ),
            ]),
    );
  }

  Widget _left(BuildContext context, AppLocalizations t, Json d) {
    final cs = Theme.of(context).colorScheme;
    final updates = [for (final u in d['updates'] as List) Json.from(u as Map)];
    final student = d['student'] as Map?;
    return Column(children: [
      Expanded(
        child: ListView(padding: const EdgeInsets.all(20), children: [
          Wrap(spacing: 8, runSpacing: 4, crossAxisAlignment: WrapCrossAlignment.center, children: [
            ComplaintStatusChip('${d['status']}'),
            Chip(label: Text(complaintCategoryLabel(t, '${d['category']}')), visualDensity: VisualDensity.compact),
            Text(stamp(d['createdAt'], null), style: TextStyle(color: cs.outline)),
          ]),
          if (student != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text('${t.ciStudent}: ${cell(student['fullName'])} · ${cell(student['registrationNumber'])}')),
          const SizedBox(height: 12),
          Card(child: Padding(padding: const EdgeInsets.all(14), child: SelectableText('${d['description']}'))),
          if ((d['attachmentCount'] ?? 0) > 0) TextButton.icon(icon: const Icon(Icons.attach_file), label: Text(t.fileCount(d['attachmentCount'] as int)), onPressed: _attachments),
          const SizedBox(height: 8),
          Text(t.conversation, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          for (final u in updates)
            if (u['message'] == null)
              Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Center(child: Text('${stamp(u['createdAt'], null)} · ${statusLabel(t, '${u['newStatus']}')}', style: Theme.of(context).textTheme.bodySmall)))
            else
              Align(
                alignment: u['fromStudent'] == true ? AlignmentDirectional.centerStart : AlignmentDirectional.centerEnd,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(10), constraints: const BoxConstraints(maxWidth: 420),
                  decoration: BoxDecoration(
                    color: u['internal'] == true ? const Color(0xFFFFF4CC) : (u['fromStudent'] == true ? cs.surfaceContainerHighest : cs.primaryContainer),
                    borderRadius: BorderRadius.circular(12)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${u['fromStudent'] == true ? t.ciStudent : cell(u['author'])}${u['internal'] == true ? ' 🔒' : ''}', style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700, color: u['internal'] == true ? Colors.black87 : null)),
                    SelectableText('${u['message']}', style: TextStyle(color: u['internal'] == true ? Colors.black87 : null)),
                    Text(stamp(u['createdAt'], null), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: u['internal'] == true ? Colors.black54 : null)),
                  ]),
                ),
              ),
        ]),
      ),
      if (d['status'] != 'CLOSED')
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
          child: Column(children: [
            CheckboxListTile(dense: true, contentPadding: EdgeInsets.zero, controlAffinity: ListTileControlAffinity.leading, title: Text(t.ciInternal), value: _internal, onChanged: (v) => setState(() => _internal = v ?? false)),
            Row(children: [
              Expanded(child: TextField(controller: _reply, minLines: 1, maxLines: 4, maxLength: 2000, decoration: InputDecoration(hintText: t.writeReply, counterText: ''))),
              const SizedBox(width: 8),
              FilledButton(style: FilledButton.styleFrom(minimumSize: const Size(90, 48)), onPressed: _busy ? null : _send, child: Text(t.ciSendReply)),
            ]),
          ]),
        ),
    ]);
  }

  Widget _right(BuildContext context, AppLocalizations t, Json d, String? myId) {
    final cs = Theme.of(context).colorScheme;
    final ai = Json.from(d['ai'] as Map);
    final locks = Json.from(d['locks'] as Map);
    final status = '${d['status']}';
    final allowed = [..._transitions[status] ?? <String>[], if (_manager && status == 'CLOSED') 'IN_PROGRESS'];
    final assigned = d['assignedAdmin'] as String?;
    return Container(
      color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
      child: ListView(padding: const EdgeInsets.all(16), children: [
        DropdownButtonFormField<String>(
          value: null, isExpanded: true, decoration: InputDecoration(labelText: t.ciStatus, helperText: statusLabel(t, status)),
          items: [for (final s in allowed) DropdownMenuItem(value: s, child: Text(statusLabel(t, s)))],
          onChanged: _busy || allowed.isEmpty ? null : (v) { if (v != null) _patch({'status': v}); },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: d['priority'] as String?, isExpanded: true,
          decoration: InputDecoration(labelText: t.ciPriority, helperText: locks['priority'] == true ? t.ciLocked : null),
          items: [for (final p in _priorities) DropdownMenuItem(value: p, child: Text(priorityLabel(t, p)))],
          onChanged: _busy ? null : (v) { if (v != null && v != d['priority']) _patch({'priority': v}); },
        ),
        if (_manager) ...[
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: d['category'] as String?, isExpanded: true,
            decoration: InputDecoration(labelText: t.complaintCategory, helperText: locks['category'] == true ? t.ciLocked : null),
            items: [for (final c in _categories) DropdownMenuItem(value: c, child: Text(complaintCategoryLabel(t, c)))],
            onChanged: _busy ? null : (v) { if (v != null && v != d['category']) _patch({'category': v}); },
          ),
        ],
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: Text(assigned == null ? t.ciUnassigned : (assigned == myId ? t.ciMine : t.ciAssigned))),
          if (assigned != myId) TextButton(onPressed: _busy || myId == null ? null : () => _patch({'assignedAdmin': myId}), child: Text(t.ciAssignToMe)),
          if (assigned != null) TextButton(onPressed: _busy ? null : () => _patch({'assignedAdmin': null}), child: Text(t.ciUnassign)),
        ]),
        const Divider(height: 28),
        Row(children: [Icon(Icons.auto_awesome, size: 18, color: cs.primary), const SizedBox(width: 6), Expanded(child: Text(t.ciAiSuggestion, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)))]),
        const SizedBox(height: 8),
        if (ai['summary'] != null) Text('${ai['summary']}'),
        const SizedBox(height: 8),
        if (ai['department'] != null) Text('${t.ciSuggestedDept}: ${complaintCategoryLabel(t, '${ai['department']}')}'),
        if (ai['topic'] != null) Text('${t.ciTopic}: ${ai['topic']}'),
        if (ai['recurring'] == true) Padding(padding: const EdgeInsets.only(top: 6), child: Chip(avatar: const Icon(Icons.repeat, size: 16), label: Text(t.ciRecurring), visualDensity: VisualDensity.compact)),
        if (d['duplicateOf'] != null) Padding(padding: const EdgeInsets.only(top: 6), child: Chip(avatar: const Icon(Icons.copy_all, size: 16), label: Text(t.ciDuplicate), visualDensity: VisualDensity.compact)),
        Text(t.ciSource('${ai['source']}'), style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 12),
        Text(t.ciSimilar, style: Theme.of(context).textTheme.titleSmall),
        if (_similar.isEmpty) Text(t.ciSimilarNone, style: TextStyle(color: cs.outline)),
        for (final s in _similar.take(6))
          ListTile(dense: true, contentPadding: EdgeInsets.zero, title: Text('${s['subject']}', maxLines: 2, overflow: TextOverflow.ellipsis), subtitle: Text('${statusLabel(t, '${s['status']}')} · ${((s['score'] as num) * 100).round()}%')),
      ]),
    );
  }
}
