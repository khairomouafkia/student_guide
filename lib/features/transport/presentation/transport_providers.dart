import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase/supabase.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers.dart';
import '../data/transport_repository.dart';

final transportRepositoryProvider = Provider((ref) => TransportRepository(ref.watch(apiClientProvider)));

final routesProvider = FutureProvider.autoDispose<List<RouteSummary>>((ref) => ref.watch(transportRepositoryProvider).routes());

final routeDetailsProvider = FutureProvider.autoDispose.family<RouteDetails, String>(
    (ref, id) => ref.watch(transportRepositoryProvider).details(id));

/// Live bus positions: initial load from the API, then Supabase Realtime pushes.
/// A 15 s poll runs as a safety net (Realtime disconnects, token expiry, missing config).
final liveBusesProvider = StreamProvider.autoDispose<Map<String, LiveBus>>((ref) {
  final repo = ref.watch(transportRepositoryProvider);
  final storage = ref.watch(tokenStorageProvider);
  final ctrl = StreamController<Map<String, LiveBus>>();
  var buses = <String, LiveBus>{};
  Timer? poll;
  SupabaseClient? client;

  Future<void> fetch() async {
    try {
      buses = {for (final b in await repo.live()) b.busId: b};
      if (!ctrl.isClosed) ctrl.add(Map.of(buses));
    } catch (e) {
      if (!ctrl.isClosed && buses.isEmpty) ctrl.addError(e);
    }
  }

  Future<void> start() async {
    await fetch();
    poll = Timer.periodic(const Duration(seconds: 15), (_) => fetch());
    if (AppConstants.supabaseUrl.isEmpty || AppConstants.supabaseAnonKey.isEmpty) return;
    final token = await storage.accessToken;
    if (token == null || ctrl.isClosed) return;
    client = SupabaseClient(AppConstants.supabaseUrl, AppConstants.supabaseAnonKey);
    client!.realtime.setAuth(token); // RLS on bus_locations scopes events to the student's university
    client!
        .channel('bus_locations_live')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'bus_locations',
          callback: (payload) {
            final r = payload.newRecord;
            if (r.isEmpty || ctrl.isClosed) return;
            final known = buses[r['bus_id']];
            if (known == null) {
              fetch(); // a bus we have no metadata for yet
              return;
            }
            buses[known.busId] = known.moved(Map<String, dynamic>.from(r));
            ctrl.add(Map.of(buses));
          },
        )
        .subscribe();
  }

  start();
  ref.onDispose(() {
    poll?.cancel();
    client?.dispose();
    ctrl.close();
  });
  return ctrl.stream;
});
