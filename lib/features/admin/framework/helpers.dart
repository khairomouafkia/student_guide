import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
import '../data/admin_api.dart';
import 'resource_config.dart';

String cell(dynamic v) => (v == null || '$v'.isEmpty) ? '—' : '$v';
String yesNo(dynamic v, AppLocalizations t) => v == true ? t.yes : t.no;
String hm(dynamic v) => v == null ? '—' : '$v'.substring(0, '$v'.length >= 5 ? 5 : '$v'.length);
String stamp(dynamic iso, BuildContext? ctx) {
  final d = DateTime.tryParse('$iso')?.toLocal();
  return d == null ? '—' : DateFormat('yyyy-MM-dd HH:mm').format(d);
}
dynamic dig(Json row, String path) {
  dynamic cur = row;
  for (final p in path.split('.')) {
    if (cur is Map) {
      cur = cur[p];
    } else if (cur is List && cur.isNotEmpty && cur.first is Map) {
      cur = (cur.first as Map)[p];
    } else {
      return null;
    }
  }
  return cur;
}

String roleLabel(AppLocalizations t, String? r) => switch (r) {
      'super_admin' => t.rSuper,
      'restaurant_admin' => t.rRestaurant,
      'transport_admin' => t.rTransport,
      'activities_admin' => t.rActivities,
      'residence_admin' => t.rResidence,
      'health_admin' => t.rHealth,
      'library_admin' => t.rLibrary,
      'complaints_admin' => t.rComplaints,
      _ => cell(r),
    };

const adminRoles = ['super_admin', 'restaurant_admin', 'transport_admin', 'activities_admin', 'residence_admin', 'health_admin', 'library_admin', 'complaints_admin'];
List<Opt> roleOptions() => [for (final r in adminRoles) Opt(r, (t) => roleLabel(t, r))];
List<Opt> yesNoOptions() => [Opt('true', (t) => t.yes), Opt('false', (t) => t.no)];
List<Opt> languageOptions() => const [Opt('ar', _ar), Opt('fr', _fr), Opt('en', _en)];
String _ar(AppLocalizations t) => 'العربية';
String _fr(AppLocalizations t) => 'Français';
String _en(AppLocalizations t) => 'English';

Color priorityColor(String? p) => switch (p) {
      'CRITICAL' => const Color(0xFFB71C1C),
      'HIGH' => const Color(0xFFD64545),
      'MEDIUM' => const Color(0xFFF08A24),
      _ => const Color(0xFF2E9D5B),
    };
String priorityLabel(AppLocalizations t, String? p) => switch (p) { 'CRITICAL' => t.priCritical, 'HIGH' => t.priHigh, 'MEDIUM' => t.priMedium, 'LOW' => t.priLow, _ => cell(p) };
