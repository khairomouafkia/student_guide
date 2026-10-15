import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers.dart';
import '../../home/presentation/home_providers.dart';
import '../data/complaint_repository.dart';

final complaintRepositoryProvider = Provider((ref) => ComplaintRepository(ref.watch(apiClientProvider)));

class ComplaintsState {
  const ComplaintsState(this.items, this.total);
  final List<ComplaintSummary> items;
  final int total;
  bool get hasMore => items.length < total;
}

class ComplaintsController extends AutoDisposeAsyncNotifier<ComplaintsState> {
  static const _size = 20;
  @override
  Future<ComplaintsState> build() async {
    final r = await ref.read(complaintRepositoryProvider).mine(pageSize: _size);
    return ComplaintsState(r.items, r.total);
  }

  Future<void> loadMore() async {
    final cur = state.valueOrNull;
    if (cur == null || !cur.hasMore) return;
    final r = await ref.read(complaintRepositoryProvider).mine(page: (cur.items.length ~/ _size) + 1, pageSize: _size);
    state = AsyncData(ComplaintsState([...cur.items, ...r.items], r.total));
  }
}

final complaintsProvider = AutoDisposeAsyncNotifierProvider<ComplaintsController, ComplaintsState>(ComplaintsController.new);
final complaintDetailProvider = FutureProvider.autoDispose.family<ComplaintDetail, String>((ref, id) => ref.watch(complaintRepositoryProvider).detail(id));

void refreshComplaints(WidgetRef ref, [String? id]) {
  ref.invalidate(complaintsProvider);
  ref.invalidate(homeSummaryProvider);
  if (id != null) ref.invalidate(complaintDetailProvider(id));
}
