import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';
import '../auth/presentation/auth_controller.dart';
import 'configs.dart';
import 'framework/helpers.dart';
import 'framework/resource_config.dart';
import 'framework/resource_page.dart';
import 'pages/broadcast_page.dart';
import 'pages/complaints_inbox.dart';
import 'pages/dashboard_page.dart';
import 'pages/health_check_page.dart';
import 'pages/medical_review.dart';
import 'pages/ratings_page.dart';
import 'pages/residence_tools.dart';
import 'pages/scan_page.dart';

class _Item {
  const _Item(this.icon, this.label, this.build);
  final IconData icon;
  final String Function(AppLocalizations) label;
  final Widget Function() build;
}

class _Group {
  const _Group(this.label, this.items);
  final String Function(AppLocalizations)? label;
  final List<_Item> items;
}

Widget _res(ResourceConfig c) => ResourcePage(config: c);

_Item _dashboard() => _Item(Icons.dashboard_outlined, (t) => t.dashboard, () => const DashboardPage());
_Item _complaints() => _Item(Icons.report_gmailerrorred_outlined, (t) => t.complaints, () => _res(complaintsInboxConfig()));

/// Residence meals use the same /meals API: the backend only returns (and accepts) the ones of residence restaurants.
ResourceConfig _residenceMeals() => ResourceConfig(
      title: (t) => t.mResidenceMeals, endpoint: mealsConfig.endpoint, columns: mealsConfig.columns, fields: mealsConfig.fields,
      filters: mealsConfig.filters, defaultSort: mealsConfig.defaultSort, defaultOrder: mealsConfig.defaultOrder);

/// UI convenience only: every request is authorized again by the backend (RBAC + campus/residence scope).
List<_Group> _menuFor(String role) {
  final all = role == 'super_admin';
  final g = <_Group>[_Group(null, [_dashboard()])];
  if (all) {
    g.add(_Group((t) => t.gPeople, [
      _Item(Icons.school_outlined, (t) => t.mStudents, () => _res(studentsConfig)),
      _Item(Icons.admin_panel_settings_outlined, (t) => t.mAdmins, () => _res(adminsConfig)),
    ]));
  }
  if (all || role == 'restaurant_admin') {
    g.add(_Group((t) => t.restaurant, [
      _Item(Icons.storefront_outlined, (t) => t.restaurant, () => _res(restaurantsConfig)),
      _Item(Icons.restaurant_menu, (t) => t.mMeals, () => _res(mealsConfig)),
      _Item(Icons.receipt_long_outlined, (t) => t.mReservations, () => _res(reservationsConfig)),
      _Item(Icons.qr_code_scanner, (t) => t.mScan, () => ScanPage(meals: true, activities: all)),
      _Item(Icons.star_outline, (t) => t.mRatings, () => const RatingsPage(services: ['restaurant'])),
    ]));
  }
  if (all || role == 'transport_admin') {
    g.add(_Group((t) => t.transport, [
      _Item(Icons.alt_route, (t) => t.mRoutes, () => _res(routesConfig)),
      _Item(Icons.pin_drop_outlined, (t) => t.mStops, () => _res(stopsConfig)),
      _Item(Icons.schedule, (t) => t.mSchedules, () => _res(schedulesConfig)),
      _Item(Icons.directions_bus_outlined, (t) => t.mBuses, () => _res(busesConfig)),
      _Item(Icons.badge_outlined, (t) => t.mDrivers, () => _res(driversConfig)),
      _Item(Icons.star_outline, (t) => t.mRatings, () => const RatingsPage(services: ['transport'])),
    ]));
  }
  if (all || role == 'activities_admin') {
    g.add(_Group((t) => t.activities, [
      _Item(Icons.emoji_events_outlined, (t) => t.activities, () => _res(activitiesConfig)),
      if (role == 'activities_admin') _Item(Icons.qr_code_scanner, (t) => t.mScan, () => const ScanPage(meals: false, activities: true)),
      if (role == 'activities_admin') _Item(Icons.star_outline, (t) => t.mRatings, () => const RatingsPage(services: ['activities'])),
    ]));
  }
  if (all || role == 'residence_admin') {
    g.add(_Group((t) => t.residence, [
      _Item(Icons.apartment_outlined, (t) => t.mResidences, () => _res(residencesConfig)),
      _Item(Icons.domain_outlined, (t) => t.mBuildings, () => _res(buildingsConfig)),
      _Item(Icons.meeting_room_outlined, (t) => t.mRooms, () => _res(roomsConfig)),
      _Item(Icons.person_add_alt_1_outlined, (t) => t.fStudent, () => const _AssignPage()),
      _Item(Icons.storefront_outlined, (t) => t.mResidenceRestaurants, () => _res(residenceRestaurantsConfig)),
      _Item(Icons.restaurant_menu, (t) => t.mResidenceMeals, () => _res(_residenceMeals())),
      if (role == 'residence_admin') _Item(Icons.receipt_long_outlined, (t) => t.mReservations, () => _res(reservationsConfig)),
      _Item(Icons.emoji_events_outlined, (t) => t.mResidenceActivities, () => _res(residenceActivitiesConfig)),
      if (role == 'residence_admin') _Item(Icons.qr_code_scanner, (t) => t.mScan, () => const ScanPage(meals: true, activities: true)),
      if (role == 'residence_admin') _Item(Icons.star_outline, (t) => t.mRatings, () => const RatingsPage(services: ['restaurant', 'activities'])),
    ]));
  }
  if (all || role == 'health_admin') {
    g.add(_Group((t) => t.health, [
      _Item(Icons.local_hospital_outlined, (t) => t.mHealthCenter, () => _res(healthCenterConfig)),
      _Item(Icons.medical_services_outlined, (t) => t.doctors, () => _res(doctorsConfig)),
      _Item(Icons.description_outlined, (t) => t.mMedicalReview, () => _res(medicalConfig)),
    ]));
  }
  if (all || role == 'library_admin') {
    g.add(_Group((t) => t.library, [
      _Item(Icons.menu_book_outlined, (t) => t.mBooks, () => _res(booksConfig)),
      _Item(Icons.bookmark_border, (t) => t.mBookReservations, () => _res(bookReservationsConfig)),
    ]));
  }
  g.add(_Group((t) => t.complaints, [_complaints()]));
  if (all) {
    g.add(_Group((t) => t.gSystem, [
      _Item(Icons.campaign_outlined, (t) => t.mBroadcast, () => const BroadcastPage()),
      _Item(Icons.fact_check_outlined, (t) => t.mAudit, () => _res(auditConfig)),
      _Item(Icons.monitor_heart_outlined, (t) => t.mHealthCheck, () => const HealthCheckPage()),
    ]));
  }
  return g;
}

class _AssignPage extends ConsumerWidget {
  const _AssignPage();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    return Center(child: FilledButton.icon(icon: const Icon(Icons.person_add_alt_1), label: Text(t.fStudent), onPressed: () => assignStudentAction(context, ref)));
  }
}

class AdminShell extends ConsumerStatefulWidget {
  const AdminShell({super.key});
  @override
  ConsumerState<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends ConsumerState<AdminShell> {
  int _group = 0, _item = 0;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final user = ref.watch(authControllerProvider).user!;
    final settings = ref.watch(settingsProvider);
    final groups = _menuFor(user.role);
    final wide = MediaQuery.sizeOf(context).width >= 980;
    final current = groups[_group].items[_item];

    Widget menu({bool drawer = false}) => ListView(padding: const EdgeInsets.symmetric(vertical: 8), children: [
          for (var g = 0; g < groups.length; g++) ...[
            if (groups[g].label != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
                child: Text(groups[g].label!(t).toUpperCase(), style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.outline, letterSpacing: 0.8)),
              ),
            for (var i = 0; i < groups[g].items.length; i++)
              ListTile(
                dense: true, leading: Icon(groups[g].items[i].icon), title: Text(groups[g].items[i].label(t)),
                selected: g == _group && i == _item, selectedTileColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.10),
                onTap: () {
                  setState(() { _group = g; _item = i; });
                  if (drawer) Navigator.pop(context);
                },
              ),
          ],
        ]);

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [Text(t.appName), const SizedBox(width: 12), Chip(label: Text(roleLabel(t, user.role)), visualDensity: VisualDensity.compact)]),
        actions: [
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language), tooltip: t.language, onSelected: ref.read(settingsProvider.notifier).setLocale,
            itemBuilder: (_) => const [PopupMenuItem(value: Locale('ar'), child: Text('العربية')), PopupMenuItem(value: Locale('fr'), child: Text('Français')), PopupMenuItem(value: Locale('en'), child: Text('English'))],
          ),
          IconButton(
            tooltip: t.darkMode, icon: Icon(settings.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => ref.read(settingsProvider.notifier).setTheme(settings.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark),
          ),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Center(child: Text(user.fullName))),
          IconButton(tooltip: t.logout, icon: const Icon(Icons.logout), onPressed: () => ref.read(authControllerProvider.notifier).logout()),
        ],
      ),
      drawer: wide ? null : Drawer(child: SafeArea(child: menu(drawer: true))),
      body: Row(children: [
        if (wide) SizedBox(width: 270, child: Material(color: Theme.of(context).colorScheme.surface, child: menu())),
        if (wide) const VerticalDivider(width: 1),
        Expanded(child: KeyedSubtree(key: ValueKey('$_group-$_item'), child: current.build())),
      ]),
    );
  }
}
