# frontend_flutter: Flutter app (student mobile + admin web)

One codebase, two entry points:
- `lib/main_student.dart`: student app (Android / iOS)
- `lib/main_admin.dart`: administration dashboard (Flutter Web, role-based menu)

Stack: Flutter >= 3.27, Material 3, Riverpod, Dio, Arabic / French / English (RTL), dark mode.

## Run
```bash
flutter pub get
flutter gen-l10n
flutter analyze && flutter test

# student app (Android emulator reaches the host machine at 10.0.2.2)
flutter run -t lib/main_student.dart --dart-define=API_BASE_URL=http://10.0.2.2:3000/api

# admin dashboard
flutter run -d chrome -t lib/main_admin.dart --dart-define=API_BASE_URL=http://localhost:3000/api
```
Add the web origin to `CORS_ORIGINS` in `../backend_express/.env`.

## Public build-time values
`API_BASE_URL`, `SUPABASE_URL`, `SUPABASE_ANON_KEY` (live bus tracking; the anon key is public by design), `ENABLE_PUSH=true` (after Firebase setup).
No secret key ever goes into this folder.

## Build
```bash
flutter build apk --release -t lib/main_student.dart --dart-define=API_BASE_URL=https://api.example.com/api --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
flutter build web --release -t lib/main_admin.dart --dart-define=API_BASE_URL=https://api.example.com/api
```

## Structure
`lib/core` (theme, network, storage, security, widgets) · `lib/features/<module>` (data / presentation) · `lib/features/admin` (generic CRUD framework, per-module configs, special pages) · `lib/l10n` (ARB files).

## Platform setup (not doable from code)
Biometrics: Android `MainActivity` extends `FlutterFragmentActivity` + `USE_BIOMETRIC`; iOS `NSFaceIDUsageDescription`.
Photos / camera: iOS `NSPhotoLibraryUsageDescription`, `NSCameraUsageDescription`.
Push: `flutterfire configure`, Google services Gradle plugin, APNs key, build with `ENABLE_PUSH=true`.
