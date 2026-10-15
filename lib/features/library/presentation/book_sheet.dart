import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/error_text.dart';
import '../../../core/widgets/state_views.dart';
import '../../../l10n/app_localizations.dart';
import 'library_providers.dart';

Future<void> showBookSheet(BuildContext context, String bookId) => showModalBottomSheet(
      context: context, isScrollControlled: true, showDragHandle: true, builder: (_) => _BookSheet(bookId));

class _BookSheet extends ConsumerStatefulWidget {
  const _BookSheet(this.bookId);
  final String bookId;
  @override
  ConsumerState<_BookSheet> createState() => _BookSheetState();
}

class _BookSheetState extends ConsumerState<_BookSheet> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() action, String ok, {bool close = false}) async {
    final t = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      await action();
      refreshLibraryData(ref, widget.bookId);
      if (close && mounted) Navigator.pop(context);
      messenger.showSnackBar(SnackBar(content: Text(ok)));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(errorText(t, e))));
      refreshLibraryData(ref, widget.bookId);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final repo = ref.read(libraryRepositoryProvider);
    final async = ref.watch(bookDetailProvider(widget.bookId));
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      child: async.when(
        loading: () => const SizedBox(height: 200, child: LoadingView()),
        error: (e, _) => SizedBox(height: 220, child: ErrorView(message: errorText(t, e), onRetry: () => ref.invalidate(bookDetailProvider(widget.bookId)))),
        data: (b) => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 84, height: 116,
                  child: b.coverUrl == null
                      ? ColoredBox(color: cs.surfaceContainerHighest, child: const Icon(Icons.menu_book, size: 36))
                      : Image.network(b.coverUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.menu_book, size: 36)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(b.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(b.author, style: TextStyle(color: cs.outline)),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(b.inStock ? t.copiesAvailable(b.available) : t.outOfStock),
                    backgroundColor: (b.inStock ? const Color(0xFF2E9D5B) : const Color(0xFFD64545)).withValues(alpha: 0.14),
                  ),
                ]),
              ),
            ]),
            const SizedBox(height: 12),
            if (b.category != null) Text('${t.category}: ${b.category}'),
            if (b.isbn != null) Text('${t.isbn}: ${b.isbn}'),
            if (b.location != null) Text('${t.locationLabel}: ${b.location}'),
            if (b.description != null) ...[const SizedBox(height: 12), Text(b.description!)],
            const SizedBox(height: 20),
            if (b.reservationId != null) ...[
              Text(t.pickUpAt, style: TextStyle(color: cs.outline)),
              const SizedBox(height: 8),
              OutlinedButton(
                style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52), foregroundColor: cs.error),
                onPressed: _busy ? null : () => _run(() => repo.cancel(b.reservationId!), t.cancelSuccess),
                child: Text(t.cancelReservation),
              ),
            ] else if (b.inStock)
              FilledButton(
                onPressed: _busy ? null : () => _run(() => repo.reserve(b.id), t.bookReserved),
                child: _busy ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2.5)) : Text(t.reserveBook),
              )
            else
              b.notifyMe
                  ? OutlinedButton.icon(
                      icon: const Icon(Icons.notifications_active),
                      style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                      onPressed: _busy ? null : () => _run(() => repo.removeAlert(b.id), t.notifyMeOff),
                      label: Text(t.notifyMeOn),
                    )
                  : FilledButton.tonalIcon(
                      icon: const Icon(Icons.notifications_none),
                      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                      onPressed: _busy ? null : () => _run(() => repo.addAlert(b.id), t.notifyMeOn),
                      label: Text(t.notifyMe),
                    ),
          ]),
        ),
      ),
    );
  }
}
