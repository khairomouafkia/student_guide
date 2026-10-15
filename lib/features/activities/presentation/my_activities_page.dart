import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/error_text.dart';
import '../../../core/widgets/state_views.dart';
import '../../../l10n/app_localizations.dart';
import '../../restaurant/presentation/qr_dialog.dart';
import '../../restaurant/presentation/rating_dialog.dart';
import 'activity_providers.dart';

class MyActivitiesPage extends ConsumerWidget {
  const MyActivitiesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final async = ref.watch(myRegistrationsProvider);
    final locale = Localizations.localeOf(context).toString();
    return Scaffold(
      appBar: AppBar(title: Text(t.myActivities)),
      body: async.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(message: errorText(t, e), onRetry: () => ref.invalidate(myRegistrationsProvider)),
        data: (items) => items.isEmpty
            ? const EmptyView(icon: Icons.bookmark_border)
            : RefreshIndicator(
                onRefresh: () async => ref.refresh(myRegistrationsProvider.future),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final r = items[i];
                    final (label, color) = switch (r.status) {
                      'RESERVED' => (t.statusRegistered, const Color(0xFF2E9D5B)),
                      'ATTENDED' => (t.attended, const Color(0xFF0B4DA2)),
                      _ => (t.cancelled, Colors.grey),
                    };
                    final started = DateTime.tryParse('${r.date}T${r.start}:00')?.isBefore(DateTime.now()) ?? false;
                    final canRate = r.status != 'CANCELLED' && started; // server enforces the real rule
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Expanded(child: Text(r.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16))),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: color.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(20)),
                              child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
                            ),
                          ]),
                          Text('${DateFormat.MMMEd(locale).format(DateTime.parse(r.date))} · ${r.start}', style: Theme.of(context).textTheme.bodySmall),
                          if (r.qrToken != null || canRate)
                            Wrap(spacing: 8, children: [
                              if (r.qrToken != null)
                                TextButton.icon(icon: const Icon(Icons.qr_code_2), label: Text(t.showQr), onPressed: () => showQrDialog(context, r.qrToken!, r.title)),
                              if (canRate)
                                TextButton.icon(
                                  icon: const Icon(Icons.star_outline_rounded),
                                  label: Text(t.rateActivity),
                                  onPressed: () async {
                                    final messenger = ScaffoldMessenger.of(context);
                                    final ok = await showRatingDialog(context, (s, c) => ref.read(activityRepositoryProvider).rate(r.activityId, s, c), title: t.rateActivity);
                                    if (ok) messenger.showSnackBar(SnackBar(content: Text(t.thanksRating)));
                                  },
                                ),
                            ]),
                        ]),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
