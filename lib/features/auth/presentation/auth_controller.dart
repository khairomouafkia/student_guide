import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/providers.dart';
import '../../../core/security/biometric_lock.dart';
import '../../../core/storage/offline_cache.dart';
import '../data/auth_repository.dart';

enum AuthStatus { unknown, locked, authenticated, unauthenticated }

class AuthState {
  const AuthState({this.status = AuthStatus.unknown, this.user, this.loading = false, this.error});
  final AuthStatus status;
  final AuthUser? user;
  final bool loading;
  final ApiException? error;
}

final biometricLockProvider = Provider((_) => BiometricLock());

final authRepositoryProvider = Provider(
    (ref) => AuthRepository(ref.watch(apiClientProvider), ref.watch(tokenStorageProvider)));

class AuthController extends Notifier<AuthState> {
  AuthRepository get _repo => ref.read(authRepositoryProvider);

  @override
  AuthState build() {
    Future.microtask(_restore);
    return const AuthState();
  }

  Future<void> _restore() async {
    // a stored session + biometric lock enabled => ask the fingerprint before anything is shown
    final hasSession = await ref.read(tokenStorageProvider).accessToken != null;
    if (hasSession && await ref.read(biometricLockProvider).enabled) {
      state = const AuthState(status: AuthStatus.locked);
      return;
    }
    await _loadSession();
  }

  Future<void> _loadSession() async {
    try {
      final u = await _repo.restore();
      state = u == null
          ? const AuthState(status: AuthStatus.unauthenticated)
          : AuthState(status: AuthStatus.authenticated, user: u);
    } catch (_) {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<bool> _run(Future<AuthUser> Function() f) async {
    state = const AuthState(status: AuthStatus.unauthenticated, loading: true);
    try {
      final u = await f();
      state = AuthState(status: AuthStatus.authenticated, user: u);
      return true;
    } on ApiException catch (e) {
      state = AuthState(status: AuthStatus.unauthenticated, error: e);
      return false;
    }
  }

  Future<bool> loginStudent(String email, String reg, String pw) =>
      _run(() => _repo.loginStudent(email: email, registrationNumber: reg, password: pw));
  Future<bool> loginAdmin(String email, String pw) => _run(() => _repo.loginAdmin(email: email, password: pw));

  /// Called by the lock screen. Returns false when the fingerprint check failed (the screen stays locked).
  Future<bool> unlock(String reason) async {
    if (!await ref.read(biometricLockProvider).authenticate(reason)) return false;
    state = const AuthState();
    await _loadSession();
    return true;
  }

  Future<void> logout() async {
    await _repo.logout();
    await ref.read(biometricLockProvider).setEnabled(false);
    await clearOfflineCaches();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  /// Called by ApiClient when the refresh token is no longer valid.
  void expire() {
    clearOfflineCaches();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(AuthController.new);
