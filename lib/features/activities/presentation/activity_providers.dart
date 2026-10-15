import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers.dart';
import '../../home/presentation/home_providers.dart';
import '../data/activity_repository.dart';

final activityRepositoryProvider = Provider((ref) => ActivityRepository(ref.watch(apiClientProvider)));
final activityFilterProvider = StateProvider.autoDispose<ActivityFilter>((_) => const ActivityFilter());

class ActivitiesState {
  const ActivitiesState(this.items, this.total, {this.fromCache = false});
  final List<Activity> items;
  final int total;
  final bool fromCache;
  bool get hasMore => items.length < total;
}

class ActivitiesController extends AutoDisposeAsyncNotifier<ActivitiesState> {
  static const _size = 20;
  @override
  Future<ActivitiesState> build() async {
    final f = ref.watch(activityFilterProvider); // rebuilds on filter change
    final r = await ref.read(activityRepositoryProvider).list(f, pageSize: _size);
    return ActivitiesState(r.items, r.total, fromCache: r.fromCache);
  }

  Future<void> loadMore() async {
    final cur = state.valueOrNull;
    if (cur == null || !cur.hasMore) return;
    final r = await ref.read(activityRepositoryProvider)
        .list(ref.read(activityFilterProvider), page: (cur.items.length ~/ _size) + 1, pageSize: _size);
    state = AsyncData(ActivitiesState([...cur.items, ...r.items], r.total));
  }
}

final activitiesProvider = AutoDisposeAsyncNotifierProvider<ActivitiesController, ActivitiesState>(ActivitiesController.new);
final myRegistrationsProvider = FutureProvider.autoDispose<List<RegistrationItem>>((ref) => ref.watch(activityRepositoryProvider).mine());

void refreshActivityData(WidgetRef ref) {
  ref.invalidate(activitiesProvider);
  ref.invalidate(myRegistrationsProvider);
  ref.invalidate(homeSummaryProvider);
}
