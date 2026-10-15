import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/utils/error_text.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/state_views.dart';
import '../../../l10n/app_localizations.dart';
import '../../restaurant/presentation/rating_dialog.dart';
import '../../profile/presentation/profile_page.dart';
import '../../home/presentation/home_providers.dart';
import '../../complaints/presentation/new_complaint_page.dart';
import '../data/transport_repository.dart';
import 'transport_providers.dart';

class RouteMapPage extends ConsumerWidget {
  const RouteMapPage({super.key, required this.routeId, required this.routeName});
  final String routeId, routeName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final details = ref.watch(routeDetailsProvider(routeId));
    final following = ref.watch(profileProvider).valueOrNull?.profile.favoriteRouteId == routeId;
    return Scaffold(
      appBar: AppBar(
        title: Text(routeName),
        actions: [
          IconButton(
            tooltip: following ? t.unfollowRoute : t.followRoute,
            icon: Icon(following ? Icons.star_rounded : Icons.star_border_rounded, color: following ? Colors.amber : null),
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              try {
                await ref.read(transportRepositoryProvider).follow(following ? null : routeId);
                ref.invalidate(profileProvider);
                ref.invalidate(homeSummaryProvider);
                messenger.showSnackBar(SnackBar(content: Text(following ? t.followStopped : t.followingNow)));
              } catch (e) {
                messenger.showSnackBar(SnackBar(content: Text(errorText(t, e))));
              }
            },
          ),
          IconButton(
            tooltip: t.reportProblem,
            icon: const Icon(Icons.report_gmailerrorred_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => NewComplaintPage(category: 'transport', relatedResourceId: routeId, subjectHint: routeName))),
          ),
          IconButton(
            tooltip: t.rateService,
            icon: const Icon(Icons.star_outline_rounded),
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final ok = await showRatingDialog(
                context, (s, c) => ref.read(transportRepositoryProvider).rateRoute(routeId, s, c), title: t.rateService);
              if (ok) messenger.showSnackBar(SnackBar(content: Text(t.thanksRating)));
            },
          ),
        ],
      ),
      body: details.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(message: errorText(t, e), onRetry: () => ref.invalidate(routeDetailsProvider(routeId))),
        data: (d) => _MapBody(details: d),
      ),
    );
  }
}

class _MapBody extends ConsumerStatefulWidget {
  const _MapBody({required this.details});
  final RouteDetails details;
  @override
  ConsumerState<_MapBody> createState() => _MapBodyState();
}

class _MapBodyState extends ConsumerState<_MapBody> {
  final _map = MapController();

  RouteDetails get d => widget.details;

  Future<void> _showEta(BusStop stop, List<LiveBus> buses) async {
    final t = AppLocalizations.of(context)!;
    final repo = ref.read(transportRepositoryProvider);
    final active = buses.where((b) => !b.stale).toList();
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(stop.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Text(t.etaTitle, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            if (active.isEmpty)
              Text(t.noBusLive)
            else
              FutureBuilder<List<Eta>>(
                future: Future.wait(active.map((b) => repo.eta(b.busId, stop.id))),
                builder: (_, snap) {
                  if (snap.connectionState != ConnectionState.done) return const LinearProgressIndicator();
                  if (snap.hasError || snap.data == null) return Text(errorText(t, snap.error ?? ''));
                  final best = snap.data!.reduce((a, b) => a.minutes <= b.minutes ? a : b);
                  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(t.etaMinutes(best.minutes), style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(t.etaApprox, style: Theme.of(context).textTheme.bodySmall),
                  ]);
                },
              ),
          ]),
        ),
      ),
    );
  }

  void _busInfo(LiveBus b) {
    final t = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${t.plate}: ${b.plate}', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(t.lastUpdate(ago(b.updatedAt))),
            if (b.speed != null) Text(t.speedKmh(b.speed!.round())),
            if (b.stale)
              Padding(padding: const EdgeInsets.only(top: 8), child: Chip(avatar: const Icon(Icons.signal_wifi_off, size: 18), label: Text(t.statusStale))),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final live = ref.watch(liveBusesProvider).valueOrNull ?? const <String, LiveBus>{};
    final buses = live.values.where((b) => b.routeId == d.id).toList();
    final today = d.schedules.where((s) => s.runsToday()).toList();
    final points = d.framePoints;

    return Stack(children: [
      FlutterMap(
        mapController: _map,
        options: MapOptions(
          initialCenter: points.isNotEmpty ? points.first : const LatLng(36.75, 3.06),
          initialZoom: 13,
          initialCameraFit: points.length >= 2
              ? CameraFit.bounds(bounds: LatLngBounds.fromPoints(points), padding: const EdgeInsets.fromLTRB(40, 40, 40, 260))
              : null,
        ),
        children: [
          // OSM public tiles: fine for development/small usage; use a tile provider plan for production.
          TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'com.studentguide.app'),
          if (d.path.length >= 2) PolylineLayer(polylines: [Polyline(points: d.path, strokeWidth: 5, color: cs.primary.withValues(alpha: 0.8))]),
          MarkerLayer(markers: [
            for (final s in d.stops)
              Marker(
                point: s.position, width: 40, height: 40, alignment: Alignment.topCenter,
                child: GestureDetector(onTap: () => _showEta(s, buses), child: Icon(Icons.location_on, color: cs.error, size: 36)),
              ),
          ]),
          MarkerLayer(markers: [
            for (final b in buses)
              Marker(point: b.position, width: 52, height: 52, child: _BusMarker(bus: b, onTap: () => _busInfo(b))),
          ]),
          const RichAttributionWidget(attributions: [TextSourceAttribution('© OpenStreetMap contributors')]),
        ],
      ),
      Positioned(
        top: 12, right: 12,
        child: FloatingActionButton.small(
          heroTag: 'recenter',
          onPressed: () {
            if (points.length >= 2) {
              _map.fitCamera(CameraFit.bounds(bounds: LatLngBounds.fromPoints(points), padding: const EdgeInsets.fromLTRB(40, 40, 40, 260)));
            }
          },
          child: const Icon(Icons.center_focus_strong),
        ),
      ),
      DraggableScrollableSheet(
        initialChildSize: 0.28, minChildSize: 0.12, maxChildSize: 0.7,
        builder: (_, controller) => Material(
          elevation: 8,
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: ListView(controller: controller, padding: const EdgeInsets.fromLTRB(16, 8, 16, 24), children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: cs.outlineVariant, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 12),
            Text(buses.where((b) => !b.stale).isEmpty ? t.noBusLive : t.busesLive(buses.where((b) => !b.stale).length),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(color: buses.any((b) => !b.stale) ? const Color(0xFF2E9D5B) : cs.outline)),
            const SizedBox(height: 12),
            Text(t.todaysDepartures, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            today.isEmpty
                ? Text(t.noDepartures)
                : Wrap(spacing: 8, runSpacing: 8, children: [for (final s in today) Chip(label: Text(s.time))]),
            const SizedBox(height: 16),
            Text(t.stops, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            for (final s in d.stops)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(radius: 14, child: Text('${s.order + 1}', style: const TextStyle(fontSize: 12))),
                title: Text(s.name),
                trailing: const Icon(Icons.schedule),
                onTap: () {
                  _map.move(s.position, math.max(_map.camera.zoom, 15));
                  _showEta(s, buses);
                },
              ),
          ]),
        ),
      ),
    ]);
  }
}

class _BusMarker extends StatelessWidget {
  const _BusMarker({required this.bus, required this.onTap});
  final LiveBus bus;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final color = bus.stale ? Colors.grey : Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: Stack(alignment: Alignment.center, children: [
        // direction arrow orbiting the bus icon
        Transform.rotate(
          angle: (bus.heading ?? 0) * math.pi / 180,
          child: Align(alignment: Alignment.topCenter, child: Icon(Icons.arrow_drop_up, size: 26, color: color)),
        ),
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
          child: const Icon(Icons.directions_bus_rounded, color: Colors.white, size: 18),
        ),
      ]),
    );
  }
}
