import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/utils/error_text.dart';
import '../../../core/providers.dart';
import '../../../core/widgets/state_views.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../notifications/presentation/notifications_controller.dart';
import '../data/profile_repository.dart';

final profileRepositoryProvider = Provider((ref) => ProfileRepository(ref.watch(apiClientProvider)));
final biometricSupportedProvider = FutureProvider.autoDispose<bool>((ref) => ref.watch(biometricLockProvider).supported);
final biometricEnabledProvider = FutureProvider.autoDispose<bool>((ref) => ref.watch(biometricLockProvider).enabled);

Future<void> _changePhoto(BuildContext context, WidgetRef ref, bool hasPhoto) async {
  final t = AppLocalizations.of(context)!;
  final messenger = ScaffoldMessenger.of(context);
  final choice = await showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (_) => SafeArea(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(leading: const Icon(Icons.photo_library_outlined), title: Text(t.fromGallery), onTap: () => Navigator.pop(context, 'gallery')),
        if (!kIsWeb) ListTile(leading: const Icon(Icons.photo_camera_outlined), title: Text(t.fromCamera), onTap: () => Navigator.pop(context, 'camera')),
        if (hasPhoto) ListTile(leading: const Icon(Icons.delete_outline), title: Text(t.removePhoto), onTap: () => Navigator.pop(context, 'remove')),
      ]),
    ),
  );
  if (choice == null) return;
  final repo = ref.read(profileRepositoryProvider);
  try {
    if (choice == 'remove') {
      await repo.removeAvatar();
    } else {
      // resized to 512 px and compressed before upload (image compression)
      final x = await ImagePicker().pickImage(source: choice == 'camera' ? ImageSource.camera : ImageSource.gallery, maxWidth: 512, maxHeight: 512, imageQuality: 80);
      if (x == null) return;
      await repo.uploadAvatar(await x.readAsBytes(), x.name.isEmpty ? 'photo.jpg' : x.name);
    }
    ref.invalidate(profileProvider);
    messenger.showSnackBar(SnackBar(content: Text(t.photoUpdated)));
  } catch (e) {
    messenger.showSnackBar(SnackBar(content: Text(errorText(t, e))));
  }
}

final profileProvider = FutureProvider.autoDispose<ProfileResult>((ref) => ref.watch(profileRepositoryProvider).fetch());

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final async = ref.watch(profileProvider);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.profile)),
      body: async.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          message: e is ApiException && e.isNetwork ? t.networkError : t.genericError,
          onRetry: () => ref.invalidate(profileProvider),
        ),
        data: (r) {
          final p = r.profile;
          final rows = <(IconData, String, String?)>[
            (Icons.person_outline, t.fullName, p.fullName),
            (Icons.badge_outlined, t.registrationNumber, p.registrationNumber),
            (Icons.email_outlined, t.universityEmail, p.email),
            (Icons.account_balance_outlined, t.university, p.university),
            (Icons.school_outlined, t.faculty, p.faculty),
            (Icons.menu_book_outlined, t.major, p.major),
            (Icons.timeline, t.studyYear, p.studyYear?.toString()),
            (Icons.apartment_outlined, t.residenceLabel, p.residence),
          ];
          return RefreshIndicator(
            onRefresh: () async => ref.refresh(profileProvider.future),
            child: ListView(padding: const EdgeInsets.all(16), children: [
              if (r.fromCache)
                Padding(padding: const EdgeInsets.only(bottom: 12), child: Chip(avatar: const Icon(Icons.cloud_off, size: 18), label: Text(t.offlineData))),
              Center(
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => _changePhoto(context, ref, p.avatarUrl != null),
                  child: Stack(children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundImage: p.avatarUrl != null ? NetworkImage(p.avatarUrl!) : null,
                      child: p.avatarUrl == null ? Text(p.fullName.isEmpty ? '?' : p.fullName[0].toUpperCase(), style: const TextStyle(fontSize: 32)) : null,
                    ),
                    PositionedDirectional(end: 0, bottom: 0, child: CircleAvatar(radius: 14, backgroundColor: Theme.of(context).colorScheme.primary, child: const Icon(Icons.photo_camera, size: 15, color: Colors.white))),
                  ]),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(children: [
                  for (final (icon, label, value) in rows)
                    ListTile(leading: Icon(icon), title: Text(label, style: Theme.of(context).textTheme.bodySmall), subtitle: Text(value ?? '—', style: Theme.of(context).textTheme.bodyLarge)),
                ]),
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(t.language, style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 8),
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'ar', label: Text('العربية')),
                          ButtonSegment(value: 'fr', label: Text('Français')),
                          ButtonSegment(value: 'en', label: Text('English')),
                        ],
                        selected: {settings.locale?.languageCode ?? 'ar'},
                        onSelectionChanged: (s) async {
                          await ref.read(settingsProvider.notifier).setLocale(Locale(s.first));
                          ref.read(profileRepositoryProvider).updateLanguage(s.first).catchError((_) {});
                        },
                      ),
                    ]),
                  ),
                  if (ref.watch(biometricSupportedProvider).valueOrNull == true)
                    SwitchListTile(
                      title: Text(t.biometricUnlock),
                      secondary: const Icon(Icons.fingerprint),
                      value: ref.watch(biometricEnabledProvider).valueOrNull ?? false,
                      onChanged: (v) async {
                        final lock = ref.read(biometricLockProvider);
                        if (v && !await lock.authenticate(t.biometricReason)) return;   // prove it works before turning it on
                        await lock.setEnabled(v);
                        ref.invalidate(biometricEnabledProvider);
                      },
                    ),
                  SwitchListTile(
                    title: Text(t.darkMode),
                    value: settings.themeMode == ThemeMode.dark,
                    onChanged: (v) => ref.read(settingsProvider.notifier).setTheme(v ? ThemeMode.dark : ThemeMode.light),
                  ),
                ]),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.logout),
                label: Text(t.logout),
                style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                onPressed: () async {
                  await ref.read(pushServiceProvider).unregister(ref.read(notificationRepositoryProvider));   // stop pushes for this user on this phone
                  await ref.read(authControllerProvider.notifier).logout();    // also wipes offline caches and the biometric flag
                },
              ),
            ]),
          );
        },
      ),
    );
  }
}
