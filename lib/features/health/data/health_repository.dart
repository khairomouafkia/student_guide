import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';

class OpeningHour {
  OpeningHour(this.day, this.from, this.to);
  final int day; // 0 = Sunday
  final String from, to;
}

class HealthCenter {
  HealthCenter({required this.id, required this.name, required this.isOpen, this.location, this.hours = const []});
  final String id, name;
  final bool isOpen;
  final String? location;
  final List<OpeningHour> hours;
  factory HealthCenter.fromJson(Map<String, dynamic> j) => HealthCenter(
        id: j['id'], name: j['name'], isOpen: j['is_open'] ?? true, location: j['location'],
        hours: [for (final h in (j['opening_hours'] as List? ?? const [])) OpeningHour(h['day'], (h['from'] as String).substring(0, 5), (h['to'] as String).substring(0, 5))],
      );
}

class Doctor {
  Doctor({required this.id, required this.name, required this.available, this.specialty, this.photoUrl, this.office});
  final String id, name;
  final bool available;
  final String? specialty, photoUrl, office;
  factory Doctor.fromJson(Map<String, dynamic> j) => Doctor(
        id: j['id'], name: j['full_name'], available: j['is_available'] ?? true,
        specialty: j['specialty'], photoUrl: j['photo_url'], office: j['office']);
}

class MedicalDoc {
  MedicalDoc({required this.id, required this.type, required this.status, required this.uploadedAt, required this.overdue,
      this.hoursLeft, this.rejectionReason, this.comment});
  final String id, type, status;
  final DateTime uploadedAt;
  final bool overdue;
  final int? hoursLeft;
  final String? rejectionReason, comment;
  bool get isOpen => status == 'PENDING' || status == 'UNDER_REVIEW';
  factory MedicalDoc.fromJson(Map<String, dynamic> j) => MedicalDoc(
        id: j['id'], type: j['documentType'], status: j['status'], uploadedAt: DateTime.parse(j['uploadedAt']).toLocal(),
        overdue: j['overdue'] == true, hoursLeft: j['hoursLeft'], rejectionReason: j['rejectionReason'], comment: j['comment']);
}

class HealthRepository {
  HealthRepository(this._api);
  final ApiClient _api;

  Future<HealthCenter?> center() async {
    final d = await _api.get('/health', query: {'pageSize': 1});
    final items = d['items'] as List;
    return items.isEmpty ? null : HealthCenter.fromJson(Map<String, dynamic>.from(items.first));
  }

  Future<List<Doctor>> doctors() async {
    final d = await _api.get('/doctors', query: {'pageSize': 100, 'sort': 'full_name', 'order': 'asc'});
    return [for (final j in d['items']) Doctor.fromJson(Map<String, dynamic>.from(j))];
  }

  Future<List<MedicalDoc>> myDocuments() async =>
      [for (final j in await _api.get('/medical-documents/me') as List) MedicalDoc.fromJson(Map<String, dynamic>.from(j))];

  /// The server checks the real file type (PDF/JPG/PNG) and size (5 MB).
  Future<void> upload({required List<int> bytes, required String filename, required String documentType}) =>
      _api.upload('/medical-documents', FormData.fromMap({
        'documentType': documentType,
        'file': MultipartFile.fromBytes(bytes, filename: filename),
      }));
}
