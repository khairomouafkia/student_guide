import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  TokenStorage([FlutterSecureStorage? s]) : _s = s ?? const FlutterSecureStorage();
  final FlutterSecureStorage _s;
  static const _a = 'access_token', _r = 'refresh_token';

  Future<String?> get accessToken => _s.read(key: _a);
  Future<String?> get refreshToken => _s.read(key: _r);

  Future<void> save({required String access, required String refresh}) async {
    await _s.write(key: _a, value: access);
    await _s.write(key: _r, value: refresh);
  }

  Future<void> clear() async {
    await _s.delete(key: _a);
    await _s.delete(key: _r);
  }
}
