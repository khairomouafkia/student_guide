import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/utils/error_text.dart';
import '../../../core/widgets/state_views.dart';
import '../../../l10n/app_localizations.dart';
import '../data/complaint_repository.dart';
import 'complaint_providers.dart';
import 'status_chip.dart';

class ComplaintDetailPage extends ConsumerStatefulWidget {
  const ComplaintDetailPage({super.key, required this.id});
  final String id;
  @override
  ConsumerState<ComplaintDetailPage> createState() => _ComplaintDetailPageState();
}

class _ComplaintDetailPageState extends ConsumerState<ComplaintDetailPage> {
  final _reply = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _reply.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final t = AppLocalizations.of(context)!;
    final text = _reply.text.trim();
    if (text.isEmpty) return;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _sending = true);
    try {
      await ref.read(complaintRepositoryProvider).reply(widget.id, text);
      _reply.clear();
      refreshComplaints(ref, widget.id);
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(errorText(t, e))));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _openAttachments() async {
    final t = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final urls = await ref.read(complaintRepositoryProvider).attachmentUrls(widget.id);
      if (!mounted) return;
      await showModalBottomSheet(
        context: context,
        showDragHandle: true,
        builder: (_) => SafeArea(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            for (var i = 0; i < urls.length; i++)
              ListTile(
                leading: const Icon(Icons.attach_file),
                title: Text('${t.openAttachment} ${i + 1}'),
                onTap: () => launchUrl(Uri.parse(urls[i]), mode: LaunchMode.externalApplication), // signed link, valid 60 s
              ),
          ]),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(errorText(t, e))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final async = ref.watch(complaintDetailProvider(widget.id));
    final locale = Localizations.localeOf(context).toString();
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(t.complaints)),
      body: async.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(message: errorText(t, e), onRetry: () => ref.invalidate(complaintDetailProvider(widget.id))),
        data: (c) => Column(children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => ref.refresh(complaintDetailProvider(widget.id).future),
              child: ListView(padding: const EdgeInsets.all(16), children: [
                Row(children: [
                  Expanded(child: Text(c.subject, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700))),
                  ComplaintStatusChip(c.status),
                ]),
                const SizedBox(height: 4),
                Text('${complaintCategoryLabel(t, c.category)} · ${DateFormat.yMMMd(locale).add_Hm().format(c.createdAt)}', style: TextStyle(color: cs.outline)),
                const SizedBox(height: 12),
                Card(child: Padding(padding: const EdgeInsets.all(14), child: Text(c.description))),
                if (c.attachmentCount > 0)
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton.icon(icon: const Icon(Icons.attach_file), label: Text(t.fileCount(c.attachmentCount)), onPressed: _openAttachments),
                  ),
                if (c.messages.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(t.conversation, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  for (final m in c.messages) _Bubble(m: m, locale: locale),
                ],
              ]),
            ),
          ),
          if (c.canReply)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(children: [
                  Expanded(child: TextField(controller: _reply, minLines: 1, maxLines: 4, maxLength: 2000, decoration: InputDecoration(hintText: t.writeReply, counterText: ''))),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _sending ? null : _send,
                    icon: _sending ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.send),
                  ),
                ]),
              ),
            )
          else
            Padding(padding: const EdgeInsets.all(16), child: Text(t.complaintClosed, style: TextStyle(color: cs.outline))),
        ]),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.m, required this.locale});
  final ComplaintMessage m;
  final String locale;
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    // pure status change (no text): show a small system line
    if (m.message == null && m.newStatus != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Center(child: Wrap(spacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
          Text(DateFormat.MMMd(locale).add_Hm().format(m.createdAt), style: Theme.of(context).textTheme.bodySmall),
          ComplaintStatusChip(m.newStatus!),
        ])),
      );
    }
    return Align(
      alignment: m.fromStudent ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.8),
        decoration: BoxDecoration(color: m.fromStudent ? cs.primaryContainer : cs.surfaceContainerHighest, borderRadius: BorderRadius.circular(14)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(m.fromStudent ? t.you : t.staffLabel, style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(m.message ?? ''),
          const SizedBox(height: 4),
          Text(DateFormat.MMMd(locale).add_Hm().format(m.createdAt), style: Theme.of(context).textTheme.bodySmall),
        ]),
      ),
    );
  }
}
