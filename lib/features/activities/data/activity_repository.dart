import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';

class Activity {
  Activity({required this.id, required this.title, required this.type, required this.date, required this.start,
      required this.closesAt, required this.canRegister, required this.canCancel, this.description, this.imageUrl,
      this.end, this.location, this.remaining, this.registrationId, this.qrToken});
  final String id, title, type, date, start;
  final String? description, imageUrl, end, location, registrationId, qrToken;
  final DateTime closesAt;
  final bool canRegister, canCancel;
  final int? remaining;
  bool get registered => registrationId != null;

  factory Activity.fromJson(Map<String, dynamic> j, {bool cached = false}) {
    final my = j['myRegistration'] as Map?;
    String hm(dynamic v) => (v as String).substring(0, 5);
    return Activity(
      id: j['id'], title: j['title'], type: j['type'], date: j['activity_date'], start: hm(j['start_time']),
      end: j['end_time'] == null ? null : hm(j['end_time']), description: j['description'], imageUrl: j['image_url'],
      location: j['location'], remaining: j['remaining'], closesAt: DateTime.parse(j['closesAt']).toLocal(),
      canRegister: !cached && (j['canRegister'] ?? false), canCancel: !cached && (j['canCancel'] ?? false),
      registrationId: my?['id'], qrToken: my?['qrToken'],
    );
  }
}

class RegistrationItem {
  RegistrationItem({required this.id, required this.status, required this.activityId, required this.title,
      required this.date, required this.start, this.location, this.qrToken});
  final String id, status, activityId, title, date, start;
  final String? location, qrToken;
  factory RegistrationItem.fromJson(Map<String, dynamic> j) {
    final a = Map<String, dynamic>.from(j['activities']);
    return RegistrationItem(
      id: j['id'], status: j['status'], activityId: a['id'], title: a['title'], date: a['activity_date'],
      start: (a['start_time'] as String).substring(0, 5), location: a['location'],
      qrToken: j['status'] == 'RESERVED' ? j['qr_token'] : null,
    );
  }
}

class ActivityFilter {
  const ActivityFilter({this.type, this.past = false, this.search = ''});
  final String? type;
  final bool past;
  final String search;
  ActivityFilter copyWith({String? type, bool clearType = false, bool? past, String? search}) => ActivityFilter(
      type: clearType ? null : (type ?? this.type), past: past ?? this.past, search: search ?? this.search);
}

class ActivityRepository {
  ActivityRepository(this._api);
  final ApiClient _api;

  Future<({List<Activity> items, int total, bool fromCache})> list(ActivityFilter f, {int page = 1, int pageSize = 20}) async {
    // Only the plain "past activities" first page is saved for offline use; upcoming events and registrations are server state.
    final cacheable = f.past && page == 1 && f.type == null && f.search.trim().isEmpty;
    final prefs = await SharedPreferences.getInstance();
    try {
      final d = await _api.get('/activities', query: {
        'page': page, 'pageSize': pageSize, 'past': f.past.toString(),
        if (f.type != null) 'type': f.type,
        if (f.search.trim().isNotEmpty) 'search': f.search.trim(),
      });
      if (cacheable) await prefs.setString('activities_cache_past', jsonEncode(d));
      return (items: [for (final j in d['items']) Activity.fromJson(Map<String, dynamic>.from(j))], total: d['total'] as int, fromCache: false);
    } on ApiException catch (e) {
      final saved = cacheable ? prefs.getString('activities_cache_past') : null;
      if (e.isNetwork && saved != null) {
        final d = jsonDecode(saved);
        return (items: [for (final j in d['items']) Activity.fromJson(Map<String, dynamic>.from(j), cached: true)], total: d['total'] as int, fromCache: true);
      }
      rethrow;
    }
  }

  Future<void> register(String id) => _api.post('/activities/$id/register');
  Future<void> cancel(String id) => _api.delete('/activities/$id/register');

  Future<List<RegistrationItem>> mine() async {
    final d = await _api.get('/activities/me/registrations', query: {'pageSize': 50});
    return [for (final j in d['items']) RegistrationItem.fromJson(Map<String, dynamic>.from(j))];
  }

  Future<void> rate(String activityId, int stars, String? comment) => _api.post('/ratings', body: {
        'service': 'activities', 'resourceId': activityId, 'stars': stars,
        if (comment != null && comment.trim().isNotEmpty) 'comment': comment.trim(),
      });
}
