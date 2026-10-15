import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';
import 'meals_week_view.dart';
import 'reservations_page.dart';
import 'restaurant_providers.dart';

class RestaurantPage extends ConsumerWidget {
  const RestaurantPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.weeklyMenu),
        actions: [
          IconButton(
            tooltip: t.myReservations,
            icon: const Icon(Icons.receipt_long_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReservationsPage())),
          ),
        ],
      ),
      body: MealsWeekView(
        async: ref.watch(weekMealsProvider),
        onRetry: () => ref.invalidate(weekMealsProvider),
        onRefresh: () async => ref.refresh(weekMealsProvider.future),
      ),
    );
  }
}

