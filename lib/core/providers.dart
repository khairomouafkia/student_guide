import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'network/api_client.dart';
import 'storage/token_storage.dart';
import '../features/auth/presentation/auth_controller.dart';

final tokenStorageProvider = Provider((_) => TokenStorage());

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient(
      ref.watch(tokenStorageProvider),
      onSessionExpired: () => ref.read(authControllerProvider.notifier).expire(),
    ));

/// UI preferences (non-sensitive) persisted in SharedPreferences.
class SettingsState {
  const SettingsState({this.themeMode = ThemeMode.system, this.locale});
  final ThemeMode themeMode;
  final Locale? locale; // null = follow system
  SettingsState copyWith({ThemeMode? themeMode, Locale? locale}) =>
      SettingsState(themeMode: themeMode ?? this.themeMode, locale: locale ?? this.locale);
}

class SettingsController extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    _load();
    return const SettingsState(locale: Locale('ar'));
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    final mode = p.getString('themeMode');
    final lang = p.getString('lang');
    state = SettingsState(
      themeMode: ThemeMode.values.firstWhere((m) => m.name == mode, orElse: () => ThemeMode.system),
      locale: Locale(lang ?? 'ar'),
    );
  }

  Future<void> setTheme(ThemeMode m) async {
    state = state.copyWith(themeMode: m);
    (await SharedPreferences.getInstance()).setString('themeMode', m.name);
  }

  Future<void> setLocale(Locale l) async {
    state = state.copyWith(locale: l);
    (await SharedPreferences.getInstance()).setString('lang', l.languageCode);
  }
}

final settingsProvider = NotifierProvider<SettingsController, SettingsState>(SettingsController.new);
