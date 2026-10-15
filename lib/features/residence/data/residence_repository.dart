import '../../../core/network/api_client.dart';

class MyResidence {
  MyResidence({required this.id, required this.name, this.address, this.services = const [], this.roomNumber, this.building});
  final String id, name;
  final String? address, roomNumber, building;
  final List<String> services;
  factory MyResidence.fromJson(Map<String, dynamic> j) {
    final r = Map<String, dynamic>.from(j['residence']);
    final room = j['room'] as Map?;
    return MyResidence(
      id: r['id'], name: r['name'], address: r['address'], services: List<String>.from(r['services'] ?? const []),
      roomNumber: room?['number'], building: room?['building'],
    );
  }
}

class ResidenceRepository {
  ResidenceRepository(this._api);
  final ApiClient _api;
  Future<MyResidence?> mine() async {
    final d = await _api.get('/residences/me');
    return d == null ? null : MyResidence.fromJson(Map<String, dynamic>.from(d));
  }
}
