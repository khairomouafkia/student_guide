import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers.dart';
import '../../../core/utils/error_text.dart';
import '../../../core/widgets/state_views.dart';
import '../../../l10n/app_localizations.dart';
import '../../activities/presentation/activities_page.dart';
import '../../restaurant/presentation/meals_week_view.dart';
import '../../restaurant/presentation/reservations_page.dart';
import '../../restaurant/presentation/restaurant_providers.dart';
import '../../restaurant/presentation/rate_service.dart';
import '../data/residence_repository.dart';

final myResidenceProvider = FutureProvider.autoDispose<MyResidence?>((ref) => ResidenceRepository(ref.watch(apiClientProvider)).mine());

class ResidencePage extends ConsumerWidget {
  const ResidencePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final res = ref.watch(myResidenceProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.myResidence),
        actions: [
          IconButton(
            tooltip: t.myReservations,
            icon: const Icon(Icons.receipt_long_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReservationsPage())),
          ),
        ],
      ),
      body: res.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(message: errorText(t, e), onRetry: () => ref.invalidate(myResidenceProvider)),
        data: (r) {
          if (r == null) return EmptyView(icon: Icons.apartment_outlined, title: t.noResidence);
          return Column(children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Icon(Icons.apartment_rounded, color: cs.primary),
                      const SizedBox(width: 10),
                      Expanded(child: Text(r.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700))),
                    ]),
                    if (r.address != null) Padding(padding: const EdgeInsets.only(top: 6), child: Text(r.address!, style: TextStyle(color: cs.outline))),
                    if (r.roomNumber != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text('${t.roomLabel} ${r.roomNumber}${r.building != null ? ' · ${t.buildingLabel} ${r.building}' : ''}'),
                      ),
                    if (r.services.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Wrap(spacing: 6, runSpacing: 6, children: [for (final s in r.services) Chip(label: Text(s))]),
                    ],
                    const SizedBox(height: 8),
                    TextButton.icon(icon: const Icon(Icons.star_outline_rounded), label: Text(t.rateService), onPressed: () => rateService(context, ref, 'residence', r.id)),
                    TextButton.icon(
                      icon: const Icon(Icons.emoji_events_outlined),
                      label: Text(t.activities),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ActivitiesPage())),
                    ),
                  ]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(alignment: AlignmentDirectional.centerStart, child: Text(t.residenceMeals, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700))),
            ),
            Expanded(
              child: MealsWeekView(
                async: ref.watch(residenceMealsProvider),
                onRetry: () => ref.invalidate(residenceMealsProvider),
                onRefresh: () async => ref.refresh(residenceMealsProvider.future),
              ),
            ),
          ]);
        },
      ),
    );
  }
}
