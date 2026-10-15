import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

String complaintCategoryLabel(AppLocalizations t, String c) => switch (c) {
      'restaurant' => t.restaurant,
      'transport' => t.transport,
      'residence' => t.residence,
      'health' => t.health,
      'library' => t.library,
      'activities' => t.activities,
      _ => t.categoryOther,
    };

class ComplaintStatusChip extends StatelessWidget {
  const ComplaintStatusChip(this.status, {super.key});
  final String status;
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final (label, color) = switch (status) {
      'NEW' => (t.statusNew, const Color(0xFFF08A24)),
      'RECEIVED' => (t.statusReceived, const Color(0xFF0B4DA2)),
      'IN_PROGRESS' => (t.statusInProgress, const Color(0xFF0B4DA2)),
      'RESOLVED' => (t.statusResolved, const Color(0xFF2E9D5B)),
      _ => (t.statusClosed, Colors.grey),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }
}
