import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/error_text.dart';
import '../../../core/widgets/state_views.dart';
import '../../../l10n/app_localizations.dart';
import 'route_map_page.dart';
import 'transport_providers.dart';

class TransportPage extends ConsumerWidget {
  const TransportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final routes = ref.watch(routesProvider);
    final live = ref.watch(liveBusesProvider).valueOrNull ?? const {};

    return Scaffold(
      appBar: AppBar(title: Text(t.transportLines)),
      body: routes.when(
        loading: () => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: 4,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, __) => const SkeletonBox(height: 72, radius: 14),
        ),
        error: (e, _) => ErrorView(message: errorText(t, e), onRetry: () => ref.invalidate(routesProvider)),
        data: (list) => list.isEmpty
            ? EmptyView(icon: Icons.directions_bus_outlined, title: t.noRoutes)
            : RefreshIndicator(
                onRefresh: () async => ref.refresh(routesProvider.future),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final r = list[i];
                    final n = live.values.where((b) => b.routeId == r.id && !b.stale).length;
                    return Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                          child: Icon(Icons.directions_bus_rounded, color: Theme.of(context).colorScheme.primary),
                        ),
                        title: Text(r.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                        subtitle: n > 0 ? Text(t.busesLive(n), style: const TextStyle(color: Color(0xFF2E9D5B), fontWeight: FontWeight.w600)) : null,
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RouteMapPage(routeId: r.id, routeName: r.name))),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
