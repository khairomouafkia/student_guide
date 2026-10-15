import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/state_views.dart';
import '../../../l10n/app_localizations.dart';
import 'notification_router.dart';
import 'notifications_controller.dart';

IconData _iconFor(String type) => switch (type) {
      'restaurant' => Icons.restaurant_rounded,
      'transport' => Icons.directions_bus_rounded,
      'activities' => Icons.emoji_events_rounded,
      'residence' => Icons.apartment_rounded,
      'health' => Icons.local_hospital_rounded,
      'library' => Icons.local_library_rounded,
      'complaints' => Icons.report_gmailerrorred_rounded,
      _ => Icons.notifications_rounded,
    };

String _ago(DateTime d) {
  final diff = DateTime.now().difference(d);
  if (diff.inMinutes < 1) return '•';
  if (diff.inHours < 1) return '${diff.inMinutes}m';
  if (diff.inDays < 1) return '${diff.inHours}h';
  return '${diff.inDays}d';
}

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final async = ref.watch(notificationsProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.notifications),
        actions: [
          IconButton(
            tooltip: t.markAllRead,
            icon: const Icon(Icons.done_all),
            onPressed: () => ref.read(notificationsProvider.notifier).markAllRead(),
          ),
        ],
      ),
      body: async.when(
        loading: () => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: 6,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, __) => const SkeletonBox(height: 72, radius: 14),
        ),
        error: (e, _) => ErrorView(
          message: e is ApiException && e.isNetwork ? t.networkError : t.genericError,
          onRetry: () => ref.invalidate(notificationsProvider),
        ),
        data: (items) => items.isEmpty
            ? const EmptyView(icon: Icons.notifications_none)
            : RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(unreadCountProvider);
                  await ref.read(notificationsProvider.future);
                },
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final n = items[i];
                    return Card(
                      color: n.isRead ? null : cs.primaryContainer.withValues(alpha: 0.35),
                      child: ListTile(
                        leading: CircleAvatar(backgroundColor: cs.primary.withValues(alpha: 0.12), child: Icon(_iconFor(n.type), color: cs.primary)),
                        title: Text(n.title, style: TextStyle(fontWeight: n.isRead ? FontWeight.w500 : FontWeight.w700)),
                        subtitle: Text(n.body, maxLines: 3, overflow: TextOverflow.ellipsis),
                        trailing: Text(_ago(n.createdAt), style: Theme.of(context).textTheme.bodySmall),
                        onTap: () {
                          if (!n.isRead) ref.read(notificationsProvider.notifier).markRead(n.id);
                          openNotificationTarget(context, n);
                        },
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
