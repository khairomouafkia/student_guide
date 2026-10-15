import 'dart:async';
import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../storage/token_storage.dart';
import 'api_exception.dart';

/// Unified client. Backend envelope: {success, message, data} | {success:false, message, errorCode}.
/// Every method returns the `data` field or throws [ApiException].
class ApiClient {
  ApiClient(this._storage, {this.onSessionExpired}) {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      headers: {'Accept': 'application/json'},
    ));
    _refreshDio = Dio(BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
    ));
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (o, h) async {
        if (o.extra['auth'] != false) {
          final t = await _storage.accessToken;
          if (t != null) o.headers['Authorization'] = 'Bearer $t';
        }
        h.next(o);
      },
      onError: (e, h) async {
        final req = e.requestOptions;
        final canRetry = e.response?.statusCode == 401 &&
            req.extra['auth'] != false &&
            req.extra['retried'] != true;
        if (!canRetry) return h.next(e);
        if (await _refresh()) {
          req.extra['retried'] = true;
          if (req.data is FormData) req.data = (req.data as FormData).clone(); // a FormData can be sent only once
          try {
            return h.resolve(await _dio.fetch(req));
          } on DioException catch (e2) {
            return h.next(e2);
          }
        }
        onSessionExpired?.call();
        h.next(e);
      },
    ));
  }

  final TokenStorage _storage;
  final void Function()? onSessionExpired;
  late final Dio _dio;
  late final Dio _refreshDio;
  Completer<bool>? _refreshing; // single-flight refresh

  Future<bool> _refresh() {
    if (_refreshing != null) return _refreshing!.future;
    final c = _refreshing = Completer<bool>();
    () async {
      try {
        final rt = await _storage.refreshToken;
        if (rt == null) return c.complete(false);
        final r = await _refreshDio.post('/auth/refresh', data: {'refreshToken': rt});
        final s = r.data['data']['session'];
        await _storage.save(access: s['accessToken'], refresh: s['refreshToken']);
        c.complete(true);
      } catch (_) {
        await _storage.clear();
        c.complete(false);
      } finally {
        _refreshing = null;
      }
    }();
    return c.future;
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? query, bool auth = true}) =>
      _send('GET', path, query: query, auth: auth);
  Future<dynamic> post(String path, {Object? body, bool auth = true}) =>
      _send('POST', path, body: body, auth: auth);
  /// Multipart upload (e.g. medical documents).
  Future<dynamic> upload(String path, FormData form) => _send('POST', path, body: form);
  Future<dynamic> put(String path, {Object? body}) => _send('PUT', path, body: body);
  Future<dynamic> patch(String path, {Object? body}) => _send('PATCH', path, body: body);
  Future<dynamic> delete(String path) => _send('DELETE', path);

  Future<dynamic> _send(String method, String path,
      {Object? body, Map<String, dynamic>? query, bool auth = true}) async {
    try {
      final r = await _dio.request(path,
          data: body,
          queryParameters: query,
          options: Options(method: method, extra: {'auth': auth}, contentType: body is FormData ? null : Headers.jsonContentType));
      return r.data is Map ? r.data['data'] : r.data;
    } on DioException catch (e) {
      throw _map(e);
    }
  }

  ApiException _map(DioException e) {
    final d = e.response?.data;
    if (d is Map && d['success'] == false) {
      return ApiException(d['message']?.toString() ?? 'Error',
          errorCode: d['errorCode']?.toString() ?? 'UNKNOWN', statusCode: e.response?.statusCode);
    }
    final net = e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout;
    return ApiException(net ? 'NETWORK' : 'ERROR',
        errorCode: net ? 'NETWORK' : 'UNKNOWN', statusCode: e.response?.statusCode, isNetwork: net);
  }
}
