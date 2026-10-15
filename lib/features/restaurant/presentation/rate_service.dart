import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers.dart';
import '../../../l10n/app_localizations.dart';
import 'rating_dialog.dart';

/// Generic rating flow for library | health | residence (the server checks that the student really used the service).
Future<void> rateService(BuildContext context, WidgetRef ref, String service, String resourceId) async {
  final t = AppLocalizations.of(context)!;
  final messenger = ScaffoldMessenger.of(context);
  final api = ref.read(apiClientProvider);
  final ok = await showRatingDialog(
    context,
    (stars, comment) => api.post('/ratings', body: {
      'service': service, 'resourceId': resourceId, 'stars': stars,
      if (comment != null && comment.trim().isNotEmpty) 'comment': comment.trim(),
    }),
    title: t.rateService,
  );
  if (ok) messenger.showSnackBar(SnackBar(content: Text(t.thanksRating)));
}
