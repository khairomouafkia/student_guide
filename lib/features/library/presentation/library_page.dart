import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/error_text.dart';
import '../../../core/widgets/state_views.dart';
import '../../../l10n/app_localizations.dart';
import '../data/library_repository.dart';
import 'book_sheet.dart';
import 'library_providers.dart';
import 'my_books_page.dart';

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});
  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage> {
  Timer? _debounce;
  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearch(String v) {
    _debounce?.cancel(); // debounced search: one request per pause
    _debounce = Timer(const Duration(milliseconds: 400), () => ref.read(bookFilterProvider.notifier).update((f) => f.copyWith(search: v)));
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final filter = ref.watch(bookFilterProvider);
    final async = ref.watch(booksProvider);
    final cats = ref.watch(categoriesProvider).valueOrNull ?? const <String>[];

    return Scaffold(
      appBar: AppBar(
        title: Text(t.library),
        actions: [
          IconButton(
            tooltip: t.myBooks,
            icon: const Icon(Icons.bookmark_border),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyBooksPage())),
          ),
        ],
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: TextField(onChanged: _onSearch, decoration: InputDecoration(hintText: t.searchBooks, prefixIcon: const Icon(Icons.search))),
        ),
        if (cats.isNotEmpty)
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: ChoiceChip(label: Text(t.filterAll), selected: filter.category == null, onSelected: (_) => ref.read(bookFilterProvider.notifier).update((f) => f.copyWith(clearCategory: true))),
                ),
                for (final c in cats)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: ChoiceChip(label: Text(c), selected: filter.category == c, onSelected: (_) => ref.read(bookFilterProvider.notifier).update((f) => f.copyWith(category: c))),
                  ),
              ],
            ),
          ),
        SwitchListTile(
          dense: true,
          title: Text(t.availableOnly),
          value: filter.availableOnly,
          onChanged: (v) => ref.read(bookFilterProvider.notifier).update((f) => f.copyWith(availableOnly: v)),
        ),
        Expanded(
          child: async.when(
            loading: () => ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: 5,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, __) => const SkeletonBox(height: 84, radius: 14),
            ),
            error: (e, _) => ErrorView(message: errorText(t, e), onRetry: () => ref.invalidate(booksProvider)),
            data: (s) => s.items.isEmpty
                ? EmptyView(icon: Icons.menu_book_outlined, title: t.noBooks)
                : RefreshIndicator(
                    onRefresh: () async => ref.refresh(booksProvider.future),
                    child: ListView(padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), children: [
                      for (final b in s.items) Padding(padding: const EdgeInsets.only(bottom: 8), child: _BookTile(b)),
                      if (s.hasMore) TextButton(onPressed: () => ref.read(booksProvider.notifier).loadMore(), child: Text(t.loadMore)),
                    ]),
                  ),
          ),
        ),
      ]),
    );
  }
}

class _BookTile extends StatelessWidget {
  const _BookTile(this.b);
  final Book b;
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final color = b.inStock ? const Color(0xFF2E9D5B) : const Color(0xFFD64545);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => showBookSheet(context, b.id),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 48, height: 68,
                child: b.coverUrl == null
                    ? ColoredBox(color: Theme.of(context).colorScheme.surfaceContainerHighest, child: const Icon(Icons.menu_book))
                    : Image.network(b.coverUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.menu_book)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(b.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 2),
                Text(b.author, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall),
              ]),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(20)),
              child: Text(b.inStock ? t.copiesAvailable(b.available) : t.outOfStock, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
            ),
          ]),
        ),
      ),
    );
  }
}
