import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers.dart';
import '../../home/presentation/home_providers.dart';
import '../data/restaurant_repository.dart';

final restaurantRepositoryProvider = Provider((ref) => RestaurantRepository(ref.watch(apiClientProvider)));

/// Reservations depend on live server state (deadlines, capacity): never cached offline.
final weekMealsProvider = FutureProvider.autoDispose<List<Meal>>((ref) => ref.watch(restaurantRepositoryProvider).week(scope: 'campus'));
final residenceMealsProvider = FutureProvider.autoDispose<List<Meal>>((ref) => ref.watch(restaurantRepositoryProvider).week(scope: 'residence'));

void refreshRestaurantData(WidgetRef ref) {
  ref.invalidate(weekMealsProvider);
  ref.invalidate(residenceMealsProvider);
  ref.invalidate(historyProvider);
  ref.invalidate(homeSummaryProvider);
}

class HistoryState {
  const HistoryState(this.items, this.total);
  final List<ReservationItem> items;
  final int total;
  bool get hasMore => items.length < total;
}

class HistoryController extends AutoDisposeAsyncNotifier<HistoryState> {
  static const _size = 20;
  @override
  Future<HistoryState> build() async {
    final r = await ref.read(restaurantRepositoryProvider).history(pageSize: _size);
    return HistoryState(r.items, r.total);
  }

  Future<void> loadMore() async {
    final cur = state.valueOrNull;
    if (cur == null || !cur.hasMore) return;
    final page = (cur.items.length ~/ _size) + 1;
    final r = await ref.read(restaurantRepositoryProvider).history(page: page, pageSize: _size);
    state = AsyncData(HistoryState([...cur.items, ...r.items], r.total));
  }
}

final historyProvider = AutoDisposeAsyncNotifierProvider<HistoryController, HistoryState>(HistoryController.new);
