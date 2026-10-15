import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';

class StudentProfile {
  StudentProfile({required this.id, required this.email, required this.fullName, this.avatarUrl,
      this.language = 'ar', this.university, this.registrationNumber, this.faculty, this.major, this.studyYear, this.residence, this.favoriteRouteId});
  final String id, email, fullName, language;
  final String? avatarUrl, university, registrationNumber, faculty, major, residence, favoriteRouteId;
  final int? studyYear;

  factory StudentProfile.fromJson(Map<String, dynamic> j) {
    Map? one(dynamic v) => v is List ? (v.isEmpty ? null : v.first as Map) : v as Map?;
    final s = one(j['students']);
    return StudentProfile(
      id: j['id'], email: j['email'], fullName: j['full_name'] ?? '', avatarUrl: j['avatar_url'],
      language: j['language'] ?? 'ar', university: one(j['universities'])?['name'],
      registrationNumber: s?['registration_number'], faculty: s?['faculty'], major: s?['major'],
      studyYear: s?['study_year'], residence: one(s?['residences'])?['name'], favoriteRouteId: s?['favorite_route_id'],
    );
  }
}

class ProfileResult {
  ProfileResult(this.profile, {this.fromCache = false});
  final StudentProfile profile;
  final bool fromCache;
}

class ProfileRepository {
  ProfileRepository(this._api);
  final ApiClient _api;
  static const _key = 'profile_cache';

  /// Profile is cacheable (offline support); falls back to cache only on network errors.
  Future<ProfileResult> fetch() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final d = await _api.get('/students/me');
      await prefs.setString(_key, jsonEncode(d));
      return ProfileResult(StudentProfile.fromJson(Map<String, dynamic>.from(d)));
    } on ApiException catch (e) {
      final cached = prefs.getString(_key);
      if (e.isNetwork && cached != null) {
        return ProfileResult(StudentProfile.fromJson(Map<String, dynamic>.from(jsonDecode(cached))), fromCache: true);
      }
      rethrow;
    }
  }

  Future<void> updateLanguage(String lang) => _api.patch('/students/me', body: {'language': lang});
  Future<void> setFavoriteRoute(String? routeId) => _api.patch('/students/me', body: {'favoriteRouteId': routeId});

  /// JPEG/PNG only (the server checks the real type); the picker already resized and compressed it.
  Future<void> uploadAvatar(List<int> bytes, String filename) =>
      _api.upload('/students/me/avatar', FormData.fromMap({'file': MultipartFile.fromBytes(bytes, filename: filename)}));
  Future<void> removeAvatar() => _api.delete('/students/me/avatar');

  Future<void> clearCache() async => (await SharedPreferences.getInstance()).remove(_key);
}
