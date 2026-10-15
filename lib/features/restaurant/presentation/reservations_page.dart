import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/error_text.dart';
import '../../../core/widgets/state_views.dart';
import '../../../l10n/app_localizations.dart';
import '../data/restaurant_repository.dart';
import 'qr_dialog.dart';
import 'rating_dialog.dart';
import '../../complaints/presentation/new_complaint_page.dart';
import 'restaurant_providers.dart';

class ReservationsPage extends ConsumerWidget {
  const ReservationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final async = ref.watch(historyProvider);
    return Scaffold(
      appBar: AppBar(title: Text(t.myReservations)),
      body: async.when(
        loading: () => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: 5,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, __) => const SkeletonBox(height: 76, radius: 14),
        ),
        error: (e, _) => ErrorView(message: errorText(t, e), onRetry: () => ref.invalidate(historyProvider)),
        data: (h) => h.items.isEmpty
            ? const EmptyView(icon: Icons.receipt_long_outlined)
            : RefreshIndicator(
                onRefresh: () async => ref.refresh(historyProvider.future),
                child: ListView(padding: const EdgeInsets.all(16), children: [
                  for (final r in h.items) Padding(padding: const EdgeInsets.only(bottom: 8), child: _ReservationTile(r)),
                  if (h.hasMore)
                    TextButton(onPressed: () => ref.read(historyProvider.notifier).loadMore(), child: Text(t.loadMore)),
                ]),
              ),
      ),
    );
  }
}

class _ReservationTile extends ConsumerWidget {
  const _ReservationTile(this.r);
  final ReservationItem r;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final day = DateFormat.MMMEd(locale).format(DateTime.parse(r.date));

    final (label, color) = switch (r.status) {
      'RESERVED' => (t.statusReserved, const Color(0xFF2E9D5B)),
      'ATTENDED' => (t.attended, const Color(0xFF0B4DA2)),
      _ => (t.cancelled, Colors.grey),
    };
    // Heuristic only: the server decides whether rating is allowed.
    final mealStart = DateTime.tryParse('${r.date}T${r.time}:00');
    final canRate = r.status != 'CANCELLED' && mealStart != null && mealStart.isBefore(DateTime.now());

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(r.mealName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(20)),
              child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
            ),
          ]),
          const SizedBox(height: 2),
          Text('$day · ${r.time}', style: Theme.of(context).textTheme.bodySmall),
          if (r.qrToken != null || r.canCancel || canRate || r.status != 'CANCELLED') ...[
            const SizedBox(height: 8),
            Wrap(spacing: 8, children: [
              if (r.qrToken != null)
                TextButton.icon(icon: const Icon(Icons.qr_code_2), label: Text(t.showQr), onPressed: () => showQrDialog(context, r.qrToken!, r.mealName)),
              if (r.canCancel)
                TextButton.icon(
                  icon: const Icon(Icons.close),
                  label: Text(t.cancelReservation),
                  style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    try {
                      await ref.read(restaurantRepositoryProvider).cancel(r.id);
                      messenger.showSnackBar(SnackBar(content: Text(t.cancelSuccess)));
                    } catch (e) {
                      messenger.showSnackBar(SnackBar(content: Text(errorText(t, e))));
                    }
                    refreshRestaurantData(ref);
                  },
                ),
              if (r.status != 'CANCELLED' && canRate)
                TextButton.icon(
                  icon: const Icon(Icons.report_gmailerrorred_outlined),
                  label: Text(t.reportProblem),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(
                      builder: (_) => NewComplaintPage(category: 'restaurant', relatedResourceId: r.mealId, subjectHint: r.mealName))),
                ),
              if (canRate)
                TextButton.icon(
                  icon: const Icon(Icons.star_outline_rounded),
                  label: Text(t.rateMeal),
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final ok = await showRatingDialog(context, (stars, c) => ref.read(restaurantRepositoryProvider).rate(r.mealId, stars, c));
                    if (ok) messenger.showSnackBar(SnackBar(content: Text(t.thanksRating)));
                  },
                ),
            ]),
          ],
        ]),
      ),
    );
  }
}
