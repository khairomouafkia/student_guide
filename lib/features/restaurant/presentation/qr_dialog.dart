import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../l10n/app_localizations.dart';

Future<void> showQrDialog(BuildContext context, String token, String title) {
  final t = AppLocalizations.of(context)!;
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(12),
          child: QrImageView(data: token, size: 220),
        ),
        const SizedBox(height: 12),
        Text(t.qrHint, textAlign: TextAlign.center),
      ]),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(t.close))],
    ),
  );
}
