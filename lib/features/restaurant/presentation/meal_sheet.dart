import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/error_text.dart';
import '../../../l10n/app_localizations.dart';
import '../data/restaurant_repository.dart';
import 'qr_dialog.dart';
import 'restaurant_providers.dart';

String mealTypeLabel(AppLocalizations t, String type) =>
    switch (type) { 'breakfast' => t.breakfast, 'dinner' => t.dinner, _ => t.lunch };

Future<void> showMealSheet(BuildContext context, Meal meal) => showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _MealSheet(meal),
    );

class _MealSheet extends ConsumerStatefulWidget {
  const _MealSheet(this.meal);
  final Meal meal;
  @override
  ConsumerState<_MealSheet> createState() => _MealSheetState();
}

class _MealSheetState extends ConsumerState<_MealSheet> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() action, String successText) async {
    final t = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      await action();
      refreshRestaurantData(ref);
      if (mounted) Navigator.pop(context);
      messenger.showSnackBar(SnackBar(content: Text(successText)));
    } catch (e) {
      if (mounted) setState(() => _busy = false);
      messenger.showSnackBar(SnackBar(content: Text(errorText(t, e))));
      refreshRestaurantData(ref); // server state may have changed (full, deadline...)
    }
  }

  Future<void> _confirmCancel() async {
    final t = AppLocalizations.of(context)!;
    final yes = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.cancelConfirmTitle),
        content: Text(t.cancelConfirmBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(t.no)),
          FilledButton(style: FilledButton.styleFrom(minimumSize: const Size(80, 44)), onPressed: () => Navigator.pop(context, true), child: Text(t.yes)),
        ],
      ),
    );
    if (yes == true) {
      await _run(() => ref.read(restaurantRepositoryProvider).cancel(widget.meal.reservationId!), t.cancelSuccess);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final m = widget.meal;
    final locale = Localizations.localeOf(context).toString();
    final deadline = DateFormat.MMMEd(locale).add_Hm().format(m.deadline);
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (m.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(m.imageUrl!, height: 180, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox.shrink()),
            ),
          const SizedBox(height: 12),
          Text(m.name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('${mealTypeLabel(t, m.type)} · ${m.time} · ${m.restaurantName}', style: TextStyle(color: cs.outline)),
          if (m.description != null) ...[const SizedBox(height: 12), Text(m.description!)],
          if (m.ingredients.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(t.ingredients, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 6),
            Wrap(spacing: 6, runSpacing: 6, children: [for (final i in m.ingredients) Chip(label: Text(i))]),
          ],
          if (m.allergens.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(t.allergens, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 6),
            Wrap(spacing: 6, runSpacing: 6, children: [
              for (final a in m.allergens)
                Chip(avatar: const Icon(Icons.warning_amber_rounded, size: 18), label: Text(a), backgroundColor: Colors.orange.withValues(alpha: 0.15)),
            ]),
          ],
          const SizedBox(height: 16),
          Row(children: [
            const Icon(Icons.schedule, size: 18),
            const SizedBox(width: 6),
            Expanded(child: Text(t.deadlineLabel(deadline))),
          ]),
          if (m.remaining != null) Padding(padding: const EdgeInsets.only(top: 4), child: Text(t.remainingPlaces(m.remaining!), style: TextStyle(color: cs.outline))),
          const SizedBox(height: 20),
          if (m.reserved && m.qrToken != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: FilledButton.tonalIcon(icon: const Icon(Icons.qr_code_2), label: Text(t.showQr), onPressed: () => showQrDialog(context, m.qrToken!, m.name)),
            ),
          if (m.canReserve)
            FilledButton(
              onPressed: _busy ? null : () => _run(() => ref.read(restaurantRepositoryProvider).reserve(m.id), t.reserveSuccess),
              child: _busy ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2.5)) : Text(t.reserve),
            ),
          if (m.canCancel)
            OutlinedButton(
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52), foregroundColor: cs.error),
              onPressed: _busy ? null : _confirmCancel,
              child: Text(t.cancelReservation),
            ),
        ]),
      ),
    );
  }
}
