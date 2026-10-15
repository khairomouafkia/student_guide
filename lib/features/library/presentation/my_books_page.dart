import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/error_text.dart';
import '../../../core/widgets/state_views.dart';
import '../../../l10n/app_localizations.dart';
import '../../restaurant/presentation/rate_service.dart';
import 'book_sheet.dart';
import 'library_providers.dart';

class MyBooksPage extends ConsumerWidget {
  const MyBooksPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final async = ref.watch(myBookReservationsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(t.myBooks)),
      body: async.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(message: errorText(t, e), onRetry: () => ref.invalidate(myBookReservationsProvider)),
        data: (items) => items.isEmpty
            ? const EmptyView(icon: Icons.bookmark_border)
            : RefreshIndicator(
                onRefresh: () async => ref.refresh(myBookReservationsProvider.future),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final r = items[i];
                    final (label, color) = switch (r.status) {
                      'RESERVED' => (t.statusReserved, const Color(0xFF2E9D5B)),
                      'ATTENDED' => (t.statusCollected, const Color(0xFF0B4DA2)),
                      'RETURNED' => (t.statusReturned, Colors.grey),
                      _ => (t.cancelled, Colors.grey),
                    };
                    return Card(
                      child: ListTile(
                        title: Text(r.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                        subtitle: Text(r.author),
                        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                          if (r.status == 'ATTENDED' || r.status == 'RETURNED')
                            IconButton(tooltip: t.rateService, icon: const Icon(Icons.star_outline_rounded), onPressed: () => rateService(context, ref, 'library', r.bookId)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: color.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(20)),
                            child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
                          ),
                        ]),
                        onTap: () => showBookSheet(context, r.bookId),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
