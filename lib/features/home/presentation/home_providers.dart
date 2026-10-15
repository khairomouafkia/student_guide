import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers.dart';
import '../data/home_repository.dart';

final homeSummaryProvider = FutureProvider.autoDispose<HomeSummary>(
    (ref) => HomeRepository(ref.watch(apiClientProvider)).summary());
