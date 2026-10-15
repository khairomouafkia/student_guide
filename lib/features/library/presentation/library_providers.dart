import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers.dart';
import '../../home/presentation/home_providers.dart';
import '../data/library_repository.dart';

final libraryRepositoryProvider = Provider((ref) => LibraryRepository(ref.watch(apiClientProvider)));

class BookFilter {
  const BookFilter({this.search = '', this.category, this.availableOnly = false});
  final String search;
  final String? category;
  final bool availableOnly;
  BookFilter copyWith({String? search, String? category, bool clearCategory = false, bool? availableOnly}) => BookFilter(
      search: search ?? this.search, category: clearCategory ? null : (category ?? this.category), availableOnly: availableOnly ?? this.availableOnly);
}

final bookFilterProvider = StateProvider.autoDispose<BookFilter>((_) => const BookFilter());
final categoriesProvider = FutureProvider.autoDispose<List<String>>((ref) => ref.watch(libraryRepositoryProvider).categories());

class BooksState {
  const BooksState(this.items, this.total);
  final List<Book> items;
  final int total;
  bool get hasMore => items.length < total;
}

class BooksController extends AutoDisposeAsyncNotifier<BooksState> {
  static const _size = 20;
  @override
  Future<BooksState> build() async {
    final f = ref.watch(bookFilterProvider);
    final r = await ref.read(libraryRepositoryProvider).search(search: f.search, category: f.category, availableOnly: f.availableOnly, pageSize: _size);
    return BooksState(r.items, r.total);
  }

  Future<void> loadMore() async {
    final cur = state.valueOrNull;
    if (cur == null || !cur.hasMore) return;
    final f = ref.read(bookFilterProvider);
    final r = await ref.read(libraryRepositoryProvider)
        .search(search: f.search, category: f.category, availableOnly: f.availableOnly, page: (cur.items.length ~/ _size) + 1, pageSize: _size);
    state = AsyncData(BooksState([...cur.items, ...r.items], r.total));
  }
}

final booksProvider = AutoDisposeAsyncNotifierProvider<BooksController, BooksState>(BooksController.new);
final bookDetailProvider = FutureProvider.autoDispose.family<Book, String>((ref, id) => ref.watch(libraryRepositoryProvider).detail(id));
final myBookReservationsProvider = FutureProvider.autoDispose<List<BookReservation>>((ref) => ref.watch(libraryRepositoryProvider).history());

void refreshLibraryData(WidgetRef ref, [String? bookId]) {
  ref.invalidate(booksProvider);
  ref.invalidate(myBookReservationsProvider);
  ref.invalidate(homeSummaryProvider);
  if (bookId != null) ref.invalidate(bookDetailProvider(bookId));
}
