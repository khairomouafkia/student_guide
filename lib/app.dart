import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/providers.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/state_views.dart';
import 'features/admin/admin_shell.dart';
import 'features/auth/presentation/auth_controller.dart';
import 'features/auth/presentation/lock_page.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/shell/student_shell.dart';
import 'l10n/app_localizations.dart';

enum AppFlavor { student, admin }

class StudentGuideApp extends ConsumerWidget {
  const StudentGuideApp({super.key, required this.flavor});
  final AppFlavor flavor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final auth = ref.watch(authControllerProvider);
    final isAdmin = flavor == AppFlavor.admin;

    Widget home;
    switch (auth.status) {
      case AuthStatus.unknown:
        home = const Scaffold(body: LoadingView());
      case AuthStatus.locked:
        home = const LockPage();
      case AuthStatus.unauthenticated:
        home = LoginPage(adminMode: isAdmin);
      case AuthStatus.authenticated:
        // A student token must never open the admin app and vice versa.
        home = (auth.user!.isAdmin == isAdmin)
            ? (isAdmin ? const AdminShell() : const StudentShell())
            : LoginPage(adminMode: isAdmin);
    }

    return MaterialApp(
      title: 'Student Guide',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: settings.themeMode,
      locale: settings.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: home,
    );
  }
}
