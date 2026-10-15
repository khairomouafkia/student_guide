import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';

const complaintCategories = ['restaurant', 'transport', 'residence', 'health', 'library', 'activities', 'other'];

class ComplaintSummary {
  ComplaintSummary({required this.id, required this.category, required this.subject, required this.status, required this.createdAt, required this.attachmentCount});
  final String id, category, subject, status;
  final DateTime createdAt;
  final int attachmentCount;
  factory ComplaintSummary.fromJson(Map<String, dynamic> j) => ComplaintSummary(
        id: j['id'], category: j['category'], subject: j['subject'], status: j['status'],
        createdAt: DateTime.parse(j['created_at']).toLocal(), attachmentCount: j['attachmentCount'] ?? 0);
}

class ComplaintMessage {
  ComplaintMessage({required this.fromStudent, required this.createdAt, this.message, this.newStatus});
  final bool fromStudent;
  final DateTime createdAt;
  final String? message, newStatus;
  factory ComplaintMessage.fromJson(Map<String, dynamic> j) => ComplaintMessage(
        fromStudent: j['fromStudent'] == true, createdAt: DateTime.parse(j['createdAt']).toLocal(),
        message: j['message'], newStatus: j['newStatus']);
}

class ComplaintDetail {
  ComplaintDetail({required this.id, required this.category, required this.subject, required this.description, required this.status,
      required this.createdAt, required this.attachmentCount, required this.canReply, required this.messages});
  final String id, category, subject, description, status;
  final DateTime createdAt;
  final int attachmentCount;
  final bool canReply;
  final List<ComplaintMessage> messages;
  factory ComplaintDetail.fromJson(Map<String, dynamic> j) => ComplaintDetail(
        id: j['id'], category: j['category'], subject: j['subject'], description: j['description'], status: j['status'],
        createdAt: DateTime.parse(j['createdAt']).toLocal(), attachmentCount: j['attachmentCount'] ?? 0, canReply: j['canReply'] ?? false,
        messages: [for (final m in j['updates']) ComplaintMessage.fromJson(Map<String, dynamic>.from(m))]);
}

class ComplaintRepository {
  ComplaintRepository(this._api);
  final ApiClient _api;

  /// Complaints are server state (never cached): they change every time the administration answers.
  Future<({List<ComplaintSummary> items, int total})> mine({int page = 1, int pageSize = 20}) async {
    final d = await _api.get('/complaints/me', query: {'page': page, 'pageSize': pageSize});
    return (items: [for (final j in d['items']) ComplaintSummary.fromJson(Map<String, dynamic>.from(j))], total: d['total'] as int);
  }

  Future<ComplaintDetail> detail(String id) async => ComplaintDetail.fromJson(Map<String, dynamic>.from(await _api.get('/complaints/$id')));

  Future<void> create({required String category, required String subject, required String description, String? relatedResourceId,
      List<({List<int> bytes, String name})> files = const []}) =>
      _api.upload('/complaints', FormData.fromMap({
        'category': category, 'subject': subject, 'description': description,
        if (relatedResourceId != null) 'relatedResourceId': relatedResourceId,
        'files': [for (final f in files) MultipartFile.fromBytes(f.bytes, filename: f.name)],
      }));

  Future<void> reply(String id, String message) => _api.post('/complaints/$id/replies', body: {'message': message});

  Future<List<String>> attachmentUrls(String id) async =>
      [for (final a in await _api.get('/complaints/$id/attachments') as List) a['url'] as String];
}
