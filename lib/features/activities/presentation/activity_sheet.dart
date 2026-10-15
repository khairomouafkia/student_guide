import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/error_text.dart';
import '../../../l10n/app_localizations.dart';
import '../../restaurant/presentation/qr_dialog.dart';
import '../data/activity_repository.dart';
import 'activity_providers.dart';

String activityTypeLabel(AppLocalizations t, String type) => switch (type) {
      'cultural' => t.typeCultural,
      'sports' => t.typeSports,
      'workshop' => t.typeWorkshop,
      'conference' => t.typeConference,
      'competition' => t.typeCompetition,
      _ => t.typeOther,
    };

Future<void> showActivitySheet(BuildContext context, Activity a) =>
    showModalBottomSheet(context: context, isScrollControlled: true, showDragHandle: true, builder: (_) => _ActivitySheet(a));

class _ActivitySheet extends ConsumerStatefulWidget {
  const _ActivitySheet(this.a);
  final Activity a;
  @override
  ConsumerState<_ActivitySheet> createState() => _ActivitySheetState();
}

class _ActivitySheetState extends ConsumerState<_ActivitySheet> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() action, String ok) async {
    final t = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      await action();
      refreshActivityData(ref);
      if (mounted) Navigator.pop(context);
      messenger.showSnackBar(SnackBar(content: Text(ok)));
    } catch (e) {
      if (mounted) setState(() => _busy = false);
      messenger.showSnackBar(SnackBar(content: Text(errorText(t, e))));
      refreshActivityData(ref);
    }
  }

  Future<void> _confirmCancel() async {
    final t = AppLocalizations.of(context)!;
    final yes = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.cancelConfirmTitle),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(t.no)),
          FilledButton(style: FilledButton.styleFrom(minimumSize: const Size(80, 44)), onPressed: () => Navigator.pop(context, true), child: Text(t.yes)),
        ],
      ),
    );
    if (yes == true) await _run(() => ref.read(activityRepositoryProvider).cancel(widget.a.id), t.registrationCancelled);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final a = widget.a;
    final cs = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).toString();
    final day = DateFormat.yMMMEd(locale).format(DateTime.parse(a.date));
    final closes = DateFormat.MMMEd(locale).add_Hm().format(a.closesAt);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (a.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(a.imageUrl!, height: 170, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox.shrink()),
            ),
          const SizedBox(height: 12),
          Chip(label: Text(activityTypeLabel(t, a.type))),
          Text(a.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Row(children: [const Icon(Icons.event, size: 18), const SizedBox(width: 6), Text('$day · ${a.start}${a.end != null ? ' – ${a.end}' : ''}')]),
          if (a.location != null)
            Padding(padding: const EdgeInsets.only(top: 4), child: Row(children: [const Icon(Icons.place_outlined, size: 18), const SizedBox(width: 6), Expanded(child: Text(a.location!))])),
          if (a.description != null) ...[const SizedBox(height: 12), Text(a.description!)],
          const SizedBox(height: 12),
          Row(children: [const Icon(Icons.schedule, size: 18), const SizedBox(width: 6), Expanded(child: Text(t.registerBefore(closes)))]),
          if (a.remaining != null) Padding(padding: const EdgeInsets.only(top: 4), child: Text(t.remainingPlaces(a.remaining!), style: TextStyle(color: cs.outline))),
          const SizedBox(height: 20),
          if (a.registered && a.qrToken != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: FilledButton.tonalIcon(icon: const Icon(Icons.qr_code_2), label: Text(t.showQr), onPressed: () => showQrDialog(context, a.qrToken!, a.title)),
            ),
          if (a.canRegister)
            FilledButton(
              onPressed: _busy ? null : () => _run(() => ref.read(activityRepositoryProvider).register(a.id), t.registerSuccess),
              child: _busy ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2.5)) : Text(t.registerAction),
            ),
          if (a.canCancel)
            OutlinedButton(
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52), foregroundColor: cs.error),
              onPressed: _busy ? null : _confirmCancel,
              child: Text(t.cancelRegistration),
            ),
        ]),
      ),
    );
  }
}
