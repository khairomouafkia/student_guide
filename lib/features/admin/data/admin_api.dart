import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/providers.dart';

typedef Json = Map<String, dynamic>;

class PageData {
  PageData(this.items, this.total);
  final List<Json> items;
  final int total;
}

/// Thin helper over the REST API for the admin screens. All authorization is enforced by the backend.
class AdminApi {
  AdminApi(this._api);
  final ApiClient _api;

  Future<PageData> list(String endpoint, Json query) async {
    final d = await _api.get(endpoint, query: query);
    final items = [for (final e in d['items'] as List) Json.from(e as Map)];
    return PageData(items, (d['total'] as num?)?.toInt() ?? items.length);
  }

  Future<dynamic> get(String path, {Json? query}) => _api.get(path, query: query);
  Future<dynamic> post(String path, {Object? body}) => _api.post(path, body: body);
  Future<dynamic> patch(String path, {Object? body}) => _api.patch(path, body: body);
  Future<dynamic> put(String path, {Object? body}) => _api.put(path, body: body);
  Future<dynamic> delete(String path) => _api.delete(path);
}

final adminApiProvider = Provider((ref) => AdminApi(ref.watch(apiClientProvider)));
