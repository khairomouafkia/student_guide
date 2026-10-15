import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers.dart';
import '../data/health_repository.dart';

final healthRepositoryProvider = Provider((ref) => HealthRepository(ref.watch(apiClientProvider)));
final healthCenterProvider = FutureProvider.autoDispose<HealthCenter?>((ref) => ref.watch(healthRepositoryProvider).center());
final doctorsProvider = FutureProvider.autoDispose<List<Doctor>>((ref) => ref.watch(healthRepositoryProvider).doctors());
/// Medical data is sensitive and time-critical: always from the server, never cached on the device.
final myDocumentsProvider = FutureProvider.autoDispose<List<MedicalDoc>>((ref) => ref.watch(healthRepositoryProvider).myDocuments());
