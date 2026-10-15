import '../../../core/network/api_client.dart';

class AppNotification {
  AppNotification({required this.id, required this.type, required this.title, required this.body, required this.isRead, required this.createdAt, this.data = const {}});
  final String id, type, title, body;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic> data;
  AppNotification copyWith({bool? isRead}) =>
      AppNotification(id: id, type: type, title: title, body: body, isRead: isRead ?? this.isRead, createdAt: createdAt, data: data);
  factory AppNotification.fromJson(Map<String, dynamic> j) => AppNotification(
        id: j['id'], type: j['type'], title: j['title'], body: j['body'],
        isRead: j['is_read'] == true, createdAt: DateTime.parse(j['created_at']).toLocal(),
        data: Map<String, dynamic>.from((j['data'] as Map?) ?? const {}));
}

class NotificationRepository {
  NotificationRepository(this._api);
  final ApiClient _api;

  Future<List<AppNotification>> list({int page = 1, int pageSize = 30}) async {
    final d = await _api.get('/notifications', query: {'page': page, 'pageSize': pageSize});
    return [for (final j in d['items']) AppNotification.fromJson(Map<String, dynamic>.from(j))];
  }

  Future<int> unreadCount() async => (await _api.get('/notifications/unread-count'))['count'] as int;
  Future<void> markRead(String id) => _api.patch('/notifications/$id/read');
  Future<void> markAllRead() => _api.post('/notifications/read-all');
  Future<void> registerToken(String token, String platform) =>
      _api.post('/notifications/device-tokens', body: {'token': token, 'platform': platform});
  Future<void> removeToken(String token) => _api.post('/notifications/device-tokens/remove', body: {'token': token});
}
