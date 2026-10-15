import '../../../core/network/api_client.dart';

class NextBus {
  NextBus({required this.routeName, this.time, this.daysAhead = 0, this.minutesUntil = 0});
  final String routeName;
  final String? time; // null = the followed line has no schedule
  final int daysAhead, minutesUntil;
  factory NextBus.fromJson(Map<String, dynamic> j) {
    final n = j['next'] as Map?;
    return NextBus(routeName: j['routeName'] ?? '', time: n?['time'], daysAhead: n?['daysAhead'] ?? 0, minutesUntil: n?['minutesUntil'] ?? 0);
  }
}

class HomeSummary {
  HomeSummary({required this.unread, required this.pendingComplaints, required this.libraryReservations, this.nextMeal, this.events = const [], this.nextBus});
  final int unread, pendingComplaints, libraryReservations;
  final ({String name, String date, String time})? nextMeal;
  final List<({String title, String date, String time})> events;
  final NextBus? nextBus;

  factory HomeSummary.fromJson(Map<String, dynamic> j) {
    final m = j['nextMealReservation'];
    final nb = j['nextBus'] as Map?;
    return HomeSummary(
      unread: j['unreadNotifications'] ?? 0,
      pendingComplaints: j['pendingComplaints'] ?? 0,
      libraryReservations: j['libraryReservations'] ?? 0,
      nextMeal: m == null ? null : (name: m['name'], date: m['date'], time: (m['time'] as String).substring(0, 5)),
      events: [for (final e in (j['upcomingEvents'] as List? ?? [])) (title: e['title'], date: e['date'], time: (e['time'] as String).substring(0, 5))],
      nextBus: nb == null ? null : NextBus.fromJson(Map<String, dynamic>.from(nb)),
    );
  }
}

class HomeRepository {
  HomeRepository(this._api);
  final ApiClient _api;
  Future<HomeSummary> summary() async => HomeSummary.fromJson(Map<String, dynamic>.from(await _api.get('/students/me/home')));
}
