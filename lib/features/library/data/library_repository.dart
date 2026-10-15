import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';

class Book {
  Book({required this.id, required this.title, required this.author, required this.quantity, required this.available,
      this.isbn, this.category, this.description, this.coverUrl, this.location, this.reservationId, this.notifyMe = false});
  final String id, title, author;
  final String? isbn, category, description, coverUrl, location, reservationId;
  final int quantity, available;
  final bool notifyMe;
  bool get inStock => available > 0;

  factory Book.fromJson(Map<String, dynamic> j) => Book(
        id: j['id'], title: j['title'], author: j['author'], isbn: j['isbn'], category: j['category'],
        description: j['description'], coverUrl: j['cover_url'], location: j['location'],
        quantity: j['quantity'] ?? 0, available: j['available_quantity'] ?? 0,
        reservationId: (j['myReservation'] as Map?)?['id'], notifyMe: j['notifyMe'] == true,
      );
}

class BookReservation {
  BookReservation({required this.id, required this.status, required this.bookId, required this.title, required this.author, this.location});
  final String id, status, bookId, title, author;
  final String? location;
  factory BookReservation.fromJson(Map<String, dynamic> j) {
    final b = Map<String, dynamic>.from(j['books']);
    return BookReservation(id: j['id'], status: j['status'], bookId: b['id'], title: b['title'], author: b['author'], location: b['location']);
  }
}

class LibraryRepository {
  LibraryRepository(this._api);
  final ApiClient _api;
  static const _catKey = 'library_categories';

  Future<({List<Book> items, int total})> search({String search = '', String? category, bool availableOnly = false, int page = 1, int pageSize = 20}) async {
    final d = await _api.get('/books', query: {
      'page': page, 'pageSize': pageSize, 'available': availableOnly.toString(),
      if (search.trim().isNotEmpty) 'search': search.trim(),
      if (category != null) 'category': category,
    });
    return (items: [for (final j in d['items']) Book.fromJson(Map<String, dynamic>.from(j))], total: d['total'] as int);
  }

  /// Categories rarely change: cached for offline use (stock and reservations never are).
  Future<List<String>> categories() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final d = List<String>.from(await _api.get('/books/categories') as List);
      await prefs.setString(_catKey, jsonEncode(d));
      return d;
    } on ApiException catch (e) {
      final cached = prefs.getString(_catKey);
      if (e.isNetwork && cached != null) return List<String>.from(jsonDecode(cached));
      rethrow;
    }
  }

  Future<Book> detail(String id) async => Book.fromJson(Map<String, dynamic>.from(await _api.get('/books/$id')));
  Future<void> reserve(String bookId) => _api.post('/books/reservations', body: {'bookId': bookId});
  Future<void> cancel(String reservationId) => _api.delete('/books/reservations/$reservationId');
  Future<void> addAlert(String bookId) => _api.post('/books/$bookId/alert');
  Future<void> removeAlert(String bookId) => _api.delete('/books/$bookId/alert');

  Future<List<BookReservation>> history() async {
    final d = await _api.get('/books/reservations/me', query: {'pageSize': 50});
    return [for (final j in d['items']) BookReservation.fromJson(Map<String, dynamic>.from(j))];
  }
}
