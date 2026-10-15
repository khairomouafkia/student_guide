import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers.dart';
import '../data/notification_repository.dart';
import '../data/push_service.dart';

final notificationRepositoryProvider = Provider((ref) => NotificationRepository(ref.watch(apiClientProvider)));

final pushServiceProvider = Provider<PushService>((_) => FcmPushService.enabled ? FcmPushService() : NoopPushService());

final unreadCountProvider = FutureProvider.autoDispose<int>((ref) => ref.watch(notificationRepositoryProvider).unreadCount());

class NotificationsController extends AutoDisposeAsyncNotifier<List<AppNotification>> {
  NotificationRepository get _repo => ref.read(notificationRepositoryProvider);

  @override
  Future<List<AppNotification>> build() => _repo.list();

  Future<void> markRead(String id) async {
    final cur = state.valueOrNull;
    if (cur == null) return;
    state = AsyncData([for (final n in cur) n.id == id ? n.copyWith(isRead: true) : n]); // optimistic
    try {
      await _repo.markRead(id);
    } catch (_) {
      ref.invalidateSelf();
    }
    ref.invalidate(unreadCountProvider);
  }

  Future<void> markAllRead() async {
    final cur = state.valueOrNull;
    if (cur == null) return;
    state = AsyncData([for (final n in cur) n.copyWith(isRead: true)]);
    try {
      await _repo.markAllRead();
    } catch (_) {
      ref.invalidateSelf();
    }
    ref.invalidate(unreadCountProvider);
  }
}

final notificationsProvider =
    AutoDisposeAsyncNotifierProvider<NotificationsController, List<AppNotification>>(NotificationsController.new);
