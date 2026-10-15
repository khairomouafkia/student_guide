import '../../../core/network/api_client.dart';
import '../../../core/storage/token_storage.dart';

class AuthUser {
  AuthUser({required this.id, required this.email, required this.fullName, required this.role, this.registrationNumber});
  final String id, email, fullName, role;
  final String? registrationNumber;
  bool get isAdmin => role != 'student';

  factory AuthUser.fromJson(Map<String, dynamic> j) {
    var s = j['students'];
    if (s is List) s = s.isEmpty ? null : s.first;
    return AuthUser(
      id: j['id'],
      email: j['email'],
      fullName: j['full_name'] ?? '',
      role: j['role'] ?? 'student',
      registrationNumber: s is Map ? s['registration_number'] : null,
    );
  }
}

class AuthRepository {
  AuthRepository(this._api, this._storage);
  final ApiClient _api;
  final TokenStorage _storage;

  Future<AuthUser> loginStudent({required String email, required String registrationNumber, required String password}) =>
      _login('/auth/login', {'email': email, 'registrationNumber': registrationNumber, 'password': password});

  Future<AuthUser> loginAdmin({required String email, required String password}) =>
      _login('/auth/admin/login', {'email': email, 'password': password});

  Future<AuthUser> _login(String path, Map<String, dynamic> body) async {
    final d = await _api.post(path, body: body, auth: false);
    final s = d['session'];
    await _storage.save(access: s['accessToken'], refresh: s['refreshToken']);
    return AuthUser.fromJson(Map<String, dynamic>.from(d['profile']));
  }

  /// Restores a session from stored tokens; null if none/invalid.
  Future<AuthUser?> restore() async {
    if (await _storage.accessToken == null) return null;
    final d = await _api.get('/auth/me');
    return d == null ? null : AuthUser.fromJson(Map<String, dynamic>.from(d));
  }

  Future<void> forgotPassword(String email) => _api.post('/auth/forgot-password', body: {'email': email}, auth: false);
  Future<void> logout() => _storage.clear();
}
