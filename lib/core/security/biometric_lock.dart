import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Optional "unlock with fingerprint / face" in front of an already signed-in session (mobile only).
/// It protects the app on a shared or lost phone; the tokens themselves stay in the secure storage.
class BiometricLock {
  BiometricLock([LocalAuthentication? auth]) : _auth = auth ?? LocalAuthentication();
  final LocalAuthentication _auth;
  static const _key = 'biometric_lock';

  Future<bool> get supported async {
    if (kIsWeb) return false;
    try {
      return await _auth.isDeviceSupported() && await _auth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  Future<bool> get enabled async => (await SharedPreferences.getInstance()).getBool(_key) ?? false;
  Future<void> setEnabled(bool v) async => (await SharedPreferences.getInstance()).setBool(_key, v);

  Future<bool> authenticate(String reason) async {
    try {
      return await _auth.authenticate(localizedReason: reason, options: const AuthenticationOptions(biometricOnly: true, stickyAuth: true));
    } catch (_) {
      return false;
    }
  }
}
