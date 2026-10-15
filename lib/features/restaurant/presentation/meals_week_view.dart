import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/error_text.dart';
import '../../../core/widgets/state_views.dart';
import '../../../l10n/app_localizations.dart';
import '../data/restaurant_repository.dart';
import 'meal_sheet.dart';

/// Weekly schedule grouped by day. Shared by the campus restaurant and the residence restaurant.
class MealsWeekView extends StatelessWidget {
  const MealsWeekView({super.key, required this.async, required this.onRetry, required this.onRefresh});
  final AsyncValue<List<Meal>> async;
  final VoidCallback onRetry;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    return async.when(
      loading: () => ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) => const SkeletonBox(height: 84, radius: 14),
      ),
      error: (e, _) => ErrorView(message: errorText(t, e), onRetry: onRetry),
      data: (meals) {
        if (meals.isEmpty) return EmptyView(icon: Icons.restaurant_menu, title: t.noMeals);
        final byDay = <String, List<Meal>>{};
        for (final m in meals) {
          byDay.putIfAbsent(m.date, () => []).add(m);
        }
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView(padding: const EdgeInsets.all(16), children: [
            if (meals.first.fromCache)
              Padding(padding: const EdgeInsets.only(bottom: 8), child: Card(child: ListTile(leading: const Icon(Icons.cloud_off), title: Text(t.offlineData), subtitle: Text(t.offlineActionsOff)))),
            for (final e in byDay.entries) ...[
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Text(DateFormat.MMMEd(locale).format(DateTime.parse(e.key)),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              ),
              for (final m in e.value) Padding(padding: const EdgeInsets.only(bottom: 8), child: MealCard(m)),
            ],
          ]),
        );
      },
    );
  }
}

class MealCard extends StatelessWidget {
  const MealCard(this.meal, {super.key});
  final Meal meal;

  ({String label, Color color}) _status(BuildContext context, AppLocalizations t) {
    if (meal.reserved) return (label: t.statusReserved, color: const Color(0xFF2E9D5B));
    if (!meal.restaurantOpen) return (label: t.statusClosed, color: Colors.grey);
    if (!meal.isAvailable) return (label: t.statusUnavailable, color: Colors.grey);
    if (meal.remaining == 0) return (label: t.statusFull, color: const Color(0xFFD64545));
    if (!meal.canReserve) return (label: t.statusDeadline, color: const Color(0xFFF08A24));
    return (label: t.reserve, color: Theme.of(context).colorScheme.primary);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final status = _status(context, t);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => showMealSheet(context, meal),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 64,
                height: 64,
                child: meal.imageUrl == null
                    ? ColoredBox(color: Theme.of(context).colorScheme.surfaceContainerHighest, child: const Icon(Icons.restaurant))
                    : Image.network(meal.imageUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.restaurant)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(meal.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 2),
                Text('${mealTypeLabel(t, meal.type)} · ${meal.time}', style: Theme.of(context).textTheme.bodySmall),
              ]),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: status.color.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(20)),
              child: Text(status.label, style: TextStyle(color: status.color, fontWeight: FontWeight.w600, fontSize: 12)),
            ),
          ]),
        ),
      ),
    );
  }
}
