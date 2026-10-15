import 'package:shared_preferences/shared_preferences.dart';

/// Offline copies of read-only screens (profile, weekly menu, past activities).
/// They contain personal data (e.g. a QR code), so they are wiped at logout.
/// Reservations, complaints and medical data are NEVER cached.
Future<void> clearOfflineCaches() async {
  final p = await SharedPreferences.getInstance();
  for (final k in p.getKeys().where((k) => k == 'profile_cache' || k.startsWith('week_cache_') || k.startsWith('activities_cache_')).toList()) {
    await p.remove(k);
  }
}
