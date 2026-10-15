import 'package:flutter_test/flutter_test.dart';
import 'package:student_guide/core/network/api_exception.dart';
import 'package:student_guide/core/utils/error_text.dart';
import 'package:student_guide/features/home/data/home_repository.dart';
import 'package:student_guide/features/library/data/library_repository.dart';
import 'package:student_guide/features/restaurant/data/restaurant_repository.dart';
import 'package:student_guide/features/transport/data/transport_repository.dart';
import 'package:student_guide/l10n/app_localizations_en.dart';

Map<String, dynamic> meal({bool reserved = false}) => {
      'id': 'm1', 'name': 'Couscous', 'meal_date': '2026-10-06', 'meal_time': '12:00:00', 'type': 'lunch',
      'restaurantName': 'Central', 'restaurantOpen': true, 'is_available': true, 'canReserve': true, 'canCancel': reserved,
      'reservationDeadline': '2026-10-05T11:00:00.000Z', 'ingredients': ['semolina'], 'allergens': ['gluten'], 'remaining': 3,
      'myReservation': reserved ? {'id': 'r1', 'qrToken': 'tok'} : null,
    };

void main() {
  group('Meal', () {
    test('parses a server meal', () {
      final m = Meal.fromJson(meal(reserved: true));
      expect(m.time, '12:00');
      expect(m.reserved, isTrue);
      expect(m.qrToken, 'tok');
      expect(m.allergens, ['gluten']);
    });
    test('a saved (offline) copy can never be booked or cancelled, but keeps the QR code', () {
      final m = Meal.fromJson(meal(reserved: true), cached: true);
      expect(m.canReserve, isFalse);
      expect(m.canCancel, isFalse);
      expect(m.fromCache, isTrue);
      expect(m.qrToken, 'tok');
    });
  });

  group('HomeSummary', () {
    test('next bus with a schedule', () {
      final h = HomeSummary.fromJson({
        'unreadNotifications': 2, 'pendingComplaints': 1, 'libraryReservations': 0,
        'nextBus': {'routeId': 'r', 'routeName': 'Ligne 1', 'next': {'time': '12:30', 'daysAhead': 0, 'minutesUntil': 45}},
      });
      expect(h.nextBus!.routeName, 'Ligne 1');
      expect(h.nextBus!.time, '12:30');
      expect(h.nextBus!.minutesUntil, 45);
    });
    test('followed line without schedule, and no followed line', () {
      expect(HomeSummary.fromJson({'nextBus': {'routeId': 'r', 'routeName': 'L', 'next': null}}).nextBus!.time, isNull);
      expect(HomeSummary.fromJson({'nextBus': null}).nextBus, isNull);
    });
  });

  test('Schedule.runsToday uses 0 = Sunday', () {
    final today = DateTime.now().weekday % 7;
    expect(Schedule('08:00', [today]).runsToday(), isTrue);
    expect(Schedule('08:00', [(today + 1) % 7]).runsToday(), isFalse);
  });

  test('LiveBus becomes stale after 2 minutes without a position', () {
    LiveBus bus(DateTime t) => LiveBus.fromJson({'busId': 'b', 'plateNumber': 'AB-1', 'routeId': 'r', 'status': 'active', 'latitude': 36.7, 'longitude': 3.0, 'updatedAt': t.toUtc().toIso8601String()});
    expect(bus(DateTime.now().subtract(const Duration(seconds: 20))).stale, isFalse);
    expect(bus(DateTime.now().subtract(const Duration(minutes: 5))).stale, isTrue);
  });

  test('Book.inStock', () {
    expect(Book.fromJson({'id': 'b', 'title': 'T', 'author': 'A', 'quantity': 2, 'available_quantity': 0}).inStock, isFalse);
    expect(Book.fromJson({'id': 'b', 'title': 'T', 'author': 'A', 'quantity': 2, 'available_quantity': 1}).inStock, isTrue);
  });

  group('errorText maps backend codes to friendly messages', () {
    final t = AppLocalizationsEn();
    test('known codes', () {
      expect(errorText(t, ApiException('x', errorCode: 'DEADLINE_PASSED')), t.errDeadline);
      expect(errorText(t, ApiException('x', errorCode: 'FULL')), t.errFull);
      expect(errorText(t, ApiException('x', errorCode: 'LIMIT_REACHED')), t.errLimit);
      expect(errorText(t, ApiException('x', errorCode: 'FILE_TOO_LARGE')), t.errFileTooLarge);
      expect(errorText(t, ApiException('x', errorCode: 'WRONG_RESIDENCE')), t.errUnavailable);
    });
    test('network and unknown errors', () {
      expect(errorText(t, ApiException('NETWORK', isNetwork: true)), t.networkError);
      expect(errorText(t, ApiException('boom', errorCode: 'SOMETHING_NEW')), t.genericError);
      expect(errorText(t, StateError('x')), t.genericError);
    });
  });
}
