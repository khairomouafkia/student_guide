import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';

class Meal {
  Meal({required this.id, required this.name, required this.date, required this.time, required this.type,
      required this.restaurantName, required this.restaurantOpen, required this.isAvailable, required this.canReserve,
      required this.canCancel, required this.deadline, this.description, this.imageUrl, this.ingredients = const [],
      this.allergens = const [], this.remaining, this.reservationId, this.qrToken, this.fromCache = false});
  final String id, name, date, time, type, restaurantName;
  final bool restaurantOpen, isAvailable, canReserve, canCancel;
  final DateTime deadline;
  final String? description, imageUrl, reservationId, qrToken;
  final List<String> ingredients, allergens;
  final int? remaining;
  final bool fromCache; // saved copy shown offline: booking actions are off
  bool get reserved => reservationId != null;

  factory Meal.fromJson(Map<String, dynamic> j, {bool cached = false}) {
    final my = j['myReservation'] as Map?;
    return Meal(
      id: j['id'], name: j['name'], date: j['meal_date'], time: (j['meal_time'] as String).substring(0, 5),
      type: j['type'], restaurantName: j['restaurantName'] ?? '', restaurantOpen: j['restaurantOpen'] ?? true,
      isAvailable: j['is_available'] ?? true, canReserve: !cached && (j['canReserve'] ?? false), canCancel: !cached && (j['canCancel'] ?? false), fromCache: cached,
      deadline: DateTime.parse(j['reservationDeadline']).toLocal(), description: j['description'], imageUrl: j['image_url'],
      ingredients: List<String>.from(j['ingredients'] ?? const []), allergens: List<String>.from(j['allergens'] ?? const []),
      remaining: j['remaining'], reservationId: my?['id'], qrToken: my?['qrToken'],
    );
  }
}

class ReservationItem {
  ReservationItem({required this.id, required this.status, required this.mealId, required this.mealName,
      required this.date, required this.time, required this.canCancel, this.qrToken});
  final String id, status, mealId, mealName, date, time;
  final bool canCancel;
  final String? qrToken;
  factory ReservationItem.fromJson(Map<String, dynamic> j) {
    final m = Map<String, dynamic>.from(j['meal']);
    return ReservationItem(
      id: j['id'], status: j['status'], mealId: m['id'], mealName: m['name'], date: m['meal_date'],
      time: (m['meal_time'] as String).substring(0, 5), canCancel: j['canCancel'] ?? false, qrToken: j['qrToken'],
    );
  }
}

class RestaurantRepository {
  RestaurantRepository(this._api);
  final ApiClient _api;

  /// scope: 'campus' | 'residence' (null = both)
  Future<List<Meal>> week({String? scope}) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'week_cache_${scope ?? 'all'}';
    try {
      final d = await _api.get('/meals/week', query: {if (scope != null) 'scope': scope});
      await prefs.setString(key, jsonEncode(d));
      return [for (final j in d as List) Meal.fromJson(Map<String, dynamic>.from(j))];
    } on ApiException catch (e) {
      final saved = prefs.getString(key);
      if (e.isNetwork && saved != null) {
        return [for (final j in jsonDecode(saved) as List) Meal.fromJson(Map<String, dynamic>.from(j), cached: true)];
      }
      rethrow;
    }
  }

  Future<void> reserve(String mealId) => _api.post('/reservations', body: {'mealId': mealId});
  Future<void> cancel(String reservationId) => _api.delete('/reservations/$reservationId');

  Future<({List<ReservationItem> items, int total})> history({int page = 1, int pageSize = 20}) async {
    final d = await _api.get('/reservations/me', query: {'page': page, 'pageSize': pageSize});
    return (
      items: [for (final j in d['items']) ReservationItem.fromJson(Map<String, dynamic>.from(j))],
      total: d['total'] as int,
    );
  }

  Future<void> rate(String mealId, int stars, String? comment) => _api.post('/ratings', body: {
        'service': 'restaurant', 'resourceId': mealId, 'stars': stars,
        if (comment != null && comment.trim().isNotEmpty) 'comment': comment.trim(),
      });
}
