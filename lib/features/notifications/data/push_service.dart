import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'notification_repository.dart';

abstract class PushService {
  /// [onForeground] is called when a push arrives while the app is open (refresh the list / badge).
  Future<void> init(NotificationRepository repo, {VoidCallback? onForeground});
  Future<void> unregister(NotificationRepository repo);
}

class NoopPushService implements PushService {
  @override
  Future<void> init(NotificationRepository repo, {VoidCallback? onForeground}) async {}
  @override
  Future<void> unregister(NotificationRepository repo) async {}
}

/// Firebase Cloud Messaging. Off unless you build with --dart-define=ENABLE_PUSH=true AND Firebase is configured
/// (`flutterfire configure`, see README). Any failure is swallowed: in-app notifications keep working.
class FcmPushService implements PushService {
  static const enabled = bool.fromEnvironment('ENABLE_PUSH');
  String? _token;

  String get _platform => defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android';

  @override
  Future<void> init(NotificationRepository repo, {VoidCallback? onForeground}) async {
    if (!enabled || kIsWeb) return;
    try {
      if (Firebase.apps.isEmpty) await Firebase.initializeApp();
      final fm = FirebaseMessaging.instance;
      await fm.requestPermission();
      _token = await fm.getToken();
      if (_token != null) await repo.registerToken(_token!, _platform);
      fm.onTokenRefresh.listen((t) { _token = t; repo.registerToken(t, _platform).catchError((_) {}); });
      FirebaseMessaging.onMessage.listen((_) => onForeground?.call());
    } catch (e) {
      debugPrint('Push disabled: $e');
    }
  }

  @override
  Future<void> unregister(NotificationRepository repo) async {
    final t = _token;
    if (!enabled || t == null) return;
    try {
      await repo.removeToken(t);                       // this phone must stop receiving the previous user's pushes
      await FirebaseMessaging.instance.deleteToken();
    } catch (_) {}
    _token = null;
  }
}
