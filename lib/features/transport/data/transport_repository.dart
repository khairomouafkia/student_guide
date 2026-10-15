import 'package:latlong2/latlong.dart';
import '../../../core/network/api_client.dart';

LatLng _pt(num lat, num lng) => LatLng(lat.toDouble(), lng.toDouble());

class RouteSummary {
  RouteSummary(this.id, this.name, this.isActive);
  final String id, name;
  final bool isActive;
  factory RouteSummary.fromJson(Map<String, dynamic> j) => RouteSummary(j['id'], j['name'], j['is_active'] ?? true);
}

class BusStop {
  BusStop(this.id, this.name, this.position, this.order);
  final String id, name;
  final LatLng position;
  final int order;
  factory BusStop.fromJson(Map<String, dynamic> j) =>
      BusStop(j['id'], j['name'], _pt(j['latitude'], j['longitude']), j['stop_order']);
}

class Schedule {
  Schedule(this.time, this.days);
  final String time; // HH:mm
  final List<int> days; // 0 = Sunday ... 6 = Saturday
  factory Schedule.fromJson(Map<String, dynamic> j) =>
      Schedule((j['departure_time'] as String).substring(0, 5), List<int>.from(j['days_of_week'] ?? const [0, 1, 2, 3, 4]));
  bool runsToday() => days.contains(DateTime.now().weekday % 7);
}

class RouteDetails {
  RouteDetails({required this.id, required this.name, required this.path, required this.stops, required this.schedules});
  final String id, name;
  final List<LatLng> path;
  final List<BusStop> stops;
  final List<Schedule> schedules;
  factory RouteDetails.fromJson(Map<String, dynamic> j) => RouteDetails(
        id: j['id'],
        name: j['name'],
        path: [for (final p in (j['path'] as List? ?? const [])) _pt(p[0], p[1])],
        stops: [for (final s in j['stops']) BusStop.fromJson(Map<String, dynamic>.from(s))],
        schedules: [for (final s in j['schedules']) Schedule.fromJson(Map<String, dynamic>.from(s))],
      );
  /// Points used to frame the camera.
  List<LatLng> get framePoints => path.isNotEmpty ? path : [for (final s in stops) s.position];
}

class LiveBus {
  LiveBus({required this.busId, required this.plate, required this.routeId, required this.status,
      required this.position, required this.updatedAt, this.heading, this.speed});
  final String busId, plate, status;
  final String? routeId;
  final LatLng position;
  final double? heading, speed;
  final DateTime updatedAt;
  bool get stale => DateTime.now().difference(updatedAt).inSeconds > 120;

  factory LiveBus.fromJson(Map<String, dynamic> j) => LiveBus(
        busId: j['busId'], plate: j['plateNumber'] ?? '', routeId: j['routeId'], status: j['status'] ?? 'active',
        position: _pt(j['latitude'], j['longitude']), heading: (j['heading'] as num?)?.toDouble(),
        speed: (j['speed'] as num?)?.toDouble(), updatedAt: DateTime.parse(j['updatedAt']).toLocal(),
      );

  /// Applies a realtime row from bus_locations.
  LiveBus moved(Map<String, dynamic> r) => LiveBus(
        busId: busId, plate: plate, routeId: routeId, status: status,
        position: _pt(r['latitude'], r['longitude']), heading: (r['heading'] as num?)?.toDouble(),
        speed: (r['speed'] as num?)?.toDouble(), updatedAt: DateTime.parse(r['updated_at']).toLocal(),
      );
}

class Eta {
  Eta(this.minutes, this.meters);
  final int minutes, meters;
}

class TransportRepository {
  TransportRepository(this._api);
  final ApiClient _api;

  Future<List<RouteSummary>> routes() async {
    final d = await _api.get('/routes', query: {'pageSize': 100, 'sort': 'name', 'order': 'asc'});
    return [for (final j in d['items']) RouteSummary.fromJson(Map<String, dynamic>.from(j))];
  }

  Future<RouteDetails> details(String id) async =>
      RouteDetails.fromJson(Map<String, dynamic>.from(await _api.get('/routes/$id/details')));

  Future<List<LiveBus>> live() async =>
      [for (final j in await _api.get('/buses/live') as List) LiveBus.fromJson(Map<String, dynamic>.from(j))];

  Future<Eta> eta(String busId, String stopId) async {
    final d = await _api.get('/buses/$busId/eta', query: {'stopId': stopId});
    return Eta(d['etaMinutes'], d['distanceMeters']);
  }

  Future<void> follow(String? routeId) => _api.patch('/students/me', body: {'favoriteRouteId': routeId});

  Future<void> rateRoute(String routeId, int stars, String? comment) => _api.post('/ratings', body: {
        'service': 'transport', 'resourceId': routeId, 'stars': stars,
        if (comment != null && comment.trim().isNotEmpty) 'comment': comment.trim(),
      });
}
