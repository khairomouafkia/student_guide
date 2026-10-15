import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../../core/widgets/state_views.dart';
import 'home_providers.dart';
import '../../restaurant/presentation/restaurant_page.dart';
import '../../transport/presentation/transport_page.dart';
import '../../activities/presentation/activities_page.dart';
import '../../residence/presentation/residence_page.dart';
import '../../health/presentation/health_page.dart';
import '../../library/presentation/library_page.dart';
import '../../complaints/presentation/complaints_page.dart';

class _Service {
  const _Service(this.icon, this.label, this.color, [this.page]);
  final IconData icon;
  final String Function(AppLocalizations) label;
  final Color color;
  final Widget Function()? page; // null = module not built yet
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final user = ref.watch(authControllerProvider).user;
    final settings = ref.watch(settingsProvider);
    
    final services = <_Service>[
      _Service(Icons.restaurant_rounded, (t) => t.restaurant, const Color(0xFFF08A24), () => const RestaurantPage()),
      _Service(Icons.directions_bus_rounded, (t) => t.transport, const Color(0xFF0B4DA2), () => const TransportPage()),
      _Service(Icons.emoji_events_rounded, (t) => t.activities, const Color(0xFF8E5BD6), () => const ActivitiesPage()),
      _Service(Icons.apartment_rounded, (t) => t.residence, const Color(0xFF2E9D5B), () => const ResidencePage()),
      _Service(Icons.local_hospital_rounded, (t) => t.health, const Color(0xFFD64545), () => const HealthPage()),
      _Service(Icons.local_library_rounded, (t) => t.library, const Color(0xFF5BA8E8), () => const LibraryPage()),
      _Service(Icons.report_gmailerrorred_rounded, (t) => t.complaints, const Color(0xFF6B7280), () => const ComplaintsPage()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(t.appName),
        actions: [
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            tooltip: t.language,
            onSelected: ref.read(settingsProvider.notifier).setLocale,
            itemBuilder: (_) => const [
              PopupMenuItem(value: Locale('ar'), child: Text('العربية')),
              PopupMenuItem(value: Locale('fr'), child: Text('Français')),
              PopupMenuItem(value: Locale('en'), child: Text('English')),
            ],
          ),
          IconButton(
            tooltip: t.darkMode,
            icon: Icon(settings.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => ref
                .read(settingsProvider.notifier)
                .setTheme(settings.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(t.welcomeUser(user?.fullName ?? ''),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          const SizedBox(height: 16),
          const _SummarySection(),
          const SizedBox(height: 20),
          Text(t.services, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          LayoutBuilder(builder: (context, c) {
            final cols = c.maxWidth > 700 ? 4 : (c.maxWidth > 480 ? 3 : 2);
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: cols,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.15,
              children: [for (final s in services) _ServiceCard(s)],
            );
          }),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard(this.s);
  final _Service s;
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: s.page == null ? null : () => Navigator.push(context, MaterialPageRoute(builder: (_) => s.page!())),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: s.color.withValues(alpha: 0.12), shape: BoxShape.circle),
            child: Icon(s.icon, color: s.color, size: 28),
          ),
          const SizedBox(height: 10),
          Text(s.label(t), style: const TextStyle(fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }
}


class _SummarySection extends ConsumerWidget {
  const _SummarySection();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final async = ref.watch(homeSummaryProvider);
    return async.when(
      loading: () => const Column(children: [SkeletonBox(height: 72, radius: 14), SizedBox(height: 8), SkeletonBox(height: 72, radius: 14)]),
      error: (e, _) => ErrorView(message: t.genericError, onRetry: () => ref.invalidate(homeSummaryProvider)),
      data: (s) => Column(children: [
        _InfoTile(Icons.restaurant_rounded, t.mealReservation, s.nextMeal == null ? t.noneYet : '${s.nextMeal!.name} · ${s.nextMeal!.date} ${s.nextMeal!.time}'),
        _InfoTile(Icons.directions_bus_rounded, t.nextBus, s.nextBus == null
            ? t.followHint
            : s.nextBus!.time == null
                ? '${s.nextBus!.routeName} · ${t.nextBusNoSchedule}'
                : '${s.nextBus!.routeName} · ${s.nextBus!.daysAhead == 0 ? t.departsInMin(s.nextBus!.time!, s.nextBus!.minutesUntil) : t.departsDays(s.nextBus!.time!, s.nextBus!.daysAhead)}'),
        _InfoTile(Icons.event_rounded, t.upcomingEvents, s.events.isEmpty ? t.noneYet : s.events.map((e) => '${e.title} (${e.date})').join('\n')),
        _InfoTile(Icons.report_gmailerrorred_rounded, t.pendingComplaints, '${s.pendingComplaints}'),
        _InfoTile(Icons.local_library_rounded, t.libraryReservations, '${s.libraryReservations}'),
      ]),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile(this.icon, this.title, this.value);
  final IconData icon;
  final String title, value;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Card(child: ListTile(leading: Icon(icon, color: Theme.of(context).colorScheme.primary), title: Text(title, style: Theme.of(context).textTheme.bodySmall), subtitle: Text(value, style: Theme.of(context).textTheme.bodyLarge))),
      );
}
