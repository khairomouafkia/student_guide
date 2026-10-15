import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/error_text.dart';
import '../../../core/widgets/state_views.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../complaints/presentation/status_chip.dart';
import '../data/admin_api.dart';
import '../framework/helpers.dart';

/// Super admin: platform totals + complaint analytics. Other admins: analytics of what they may see.
final dashboardProvider = FutureProvider.autoDispose<Json>((ref) async {
  final api = ref.watch(adminApiProvider);
  final role = ref.watch(authControllerProvider).user?.role;
  if (role == 'super_admin') return Json.from(await api.get('/admin/stats') as Map);
  return {'complaints': Json.from(await api.get('/complaints/analytics', query: {'days': 30}) as Map)};
});

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final async = ref.watch(dashboardProvider);
    return async.when(
      loading: () => const LoadingView(),
      error: (e, _) => ErrorView(message: errorText(t, e), onRetry: () => ref.invalidate(dashboardProvider)),
      data: (d) {
        final totals = d['totals'] as Map?;
        final c = Json.from(d['complaints'] as Map);
        return RefreshIndicator(
          onRefresh: () async => ref.refresh(dashboardProvider.future),
          child: ListView(padding: const EdgeInsets.all(20), children: [
            Row(children: [
              Expanded(child: Text(t.mDashboardReports, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700))),
              Text(t.dLast30, style: TextStyle(color: Theme.of(context).colorScheme.outline)),
            ]),
            const SizedBox(height: 16),
            Wrap(spacing: 12, runSpacing: 12, children: [
              if (totals != null) ...[
                _Stat(Icons.school, t.dStudents, totals['students'], const Color(0xFF0B4DA2)),
                _Stat(Icons.admin_panel_settings, t.dActiveAdmins, totals['activeAdmins'], const Color(0xFF5BA8E8)),
                _Stat(Icons.restaurant, t.dRestaurants, totals['restaurants'], const Color(0xFFF08A24)),
                _Stat(Icons.directions_bus, t.dBuses, totals['buses'], const Color(0xFF0B4DA2)),
                _Stat(Icons.emoji_events, t.dActivities, totals['activities'], const Color(0xFF8E5BD6)),
                _Stat(Icons.local_library, t.dBooks, totals['books'], const Color(0xFF5BA8E8)),
                _Stat(Icons.description, t.dMedicalDocs, totals['medicalDocuments'], const Color(0xFF2E9D5B)),
                _Stat(Icons.alarm, t.dOverdueMedical, totals['overdueMedical'], const Color(0xFFD64545)),
              ],
              _Stat(Icons.report_gmailerrorred, totals != null ? t.dComplaints : '${t.dComplaints} (${t.dLast30})', totals != null ? totals['complaints'] : c['total'], const Color(0xFF6B7280)),
              _Stat(Icons.pending_actions, t.dPending, totals != null ? totals['pendingComplaints'] : c['pending'], const Color(0xFFF08A24)),
              _Stat(Icons.priority_high, t.dHighPriority, totals != null ? totals['highPriorityComplaints'] : c['highPriorityOpen'], const Color(0xFFD64545)),
              _Stat(Icons.repeat, t.dRecurring, c['recurring'], const Color(0xFF8E5BD6)),
              _Stat(Icons.timer_outlined, t.dAvgResolution, c['avgResolutionHours'] == null ? '—' : t.dHours((c['avgResolutionHours'] as num).round()), const Color(0xFF2E9D5B)),
            ]),
            const SizedBox(height: 24),
            Wrap(spacing: 16, runSpacing: 16, children: [
              _ChartCard(t.dByStatus, _pie([
                (t.statusNew, (c['new'] as num?) ?? 0, const Color(0xFFF08A24)),
                (t.statusInProgress, (c['inProgress'] as num?) ?? 0, const Color(0xFF0B4DA2)),
                (t.statusResolved, (c['resolved'] as num?) ?? 0, const Color(0xFF2E9D5B)),
                (t.statusClosed, (c['closed'] as num?) ?? 0, Colors.grey),
              ])),
              _ChartCard(t.dByPriority, _pie([
                for (final p in ['CRITICAL', 'HIGH', 'MEDIUM', 'LOW']) (priorityLabel(t, p), ((c['byPriority'] as Map?)?[p] as num?) ?? 0, priorityColor(p)),
              ])),
              _ChartCard(t.dByCategory, _bars(context, t, Map<String, dynamic>.from(c['byCategory'] as Map? ?? const {})), wide: true),
            ]),
            const SizedBox(height: 24),
            Wrap(spacing: 16, runSpacing: 16, children: [
              _ChartCard(t.dTopProblems, _problems(context, t, [for (final p in (c['topProblems'] as List? ?? const [])) Json.from(p as Map)]), wide: true),
              _ChartCard(t.dAvgRating, _ratings(context, t, Map<String, dynamic>.from(c['avgServiceRating'] as Map? ?? const {}))),
            ]),
          ]),
        );
      },
    );
  }

  Widget _pie(List<(String, num, Color)> parts) {
    final total = parts.fold<num>(0, (a, p) => a + p.$2);
    if (total == 0) return const Center(child: Text('—'));
    return Row(children: [
      Expanded(
        child: PieChart(PieChartData(
          sectionsSpace: 2, centerSpaceRadius: 36,
          sections: [for (final p in parts) if (p.$2 > 0) PieChartSectionData(value: p.$2.toDouble(), color: p.$3, radius: 46, title: '${p.$2}', titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700))],
        )),
      ),
      Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
        for (final p in parts) Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Row(mainAxisSize: MainAxisSize.min, children: [Container(width: 10, height: 10, decoration: BoxDecoration(color: p.$3, shape: BoxShape.circle)), const SizedBox(width: 6), Text(p.$1, style: const TextStyle(fontSize: 12))])),
      ]),
    ]);
  }

  Widget _bars(BuildContext context, AppLocalizations t, Map<String, dynamic> byCat) {
    if (byCat.isEmpty) return const Center(child: Text('—'));
    final keys = byCat.keys.toList();
    return BarChart(BarChartData(
      alignment: BarChartAlignment.spaceAround, borderData: FlBorderData(show: false), gridData: const FlGridData(drawVerticalLine: false),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(), rightTitles: const AxisTitles(),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28)),
        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40, getTitlesWidget: (v, _) {
          final i = v.toInt();
          return i < 0 || i >= keys.length ? const SizedBox() : Padding(padding: const EdgeInsets.only(top: 6), child: Text(complaintCategoryLabel(t, keys[i]), style: const TextStyle(fontSize: 11), textAlign: TextAlign.center));
        })),
      ),
      barGroups: [for (var i = 0; i < keys.length; i++) BarChartGroupData(x: i, barRods: [BarChartRodData(toY: (byCat[keys[i]] as num).toDouble(), width: 22, color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(4))])],
    ));
  }

  Widget _problems(BuildContext context, AppLocalizations t, List<Json> items) {
    if (items.isEmpty) return const Center(child: Text('—'));
    final max = items.map((e) => e['count'] as int).reduce((a, b) => a > b ? a : b);
    return ListView(children: [
      for (final p in items)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(children: [
            SizedBox(width: 190, child: Text('${complaintCategoryLabel(t, '${p['category']}')} · ${'${p['topic']}'.replaceAll('_', ' ')}', overflow: TextOverflow.ellipsis)),
            Expanded(child: LinearProgressIndicator(value: (p['count'] as int) / max, minHeight: 8, borderRadius: BorderRadius.circular(4))),
            const SizedBox(width: 8),
            Text('${p['count']}', style: const TextStyle(fontWeight: FontWeight.w700)),
          ]),
        ),
    ]);
  }

  Widget _ratings(BuildContext context, AppLocalizations t, Map<String, dynamic> m) {
    if (m.isEmpty) return const Center(child: Text('—'));
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      for (final e in m.entries)
        ListTile(
          dense: true,
          title: Text(switch (e.key) { 'restaurant' => t.restaurant, 'transport' => t.transport, 'activities' => t.activities, _ => e.key }),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.star_rounded, color: Colors.amber), Text(e.value == null ? '—' : '${e.value}', style: const TextStyle(fontWeight: FontWeight.w700))]),
        ),
    ]);
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.icon, this.label, this.value, this.color);
  final IconData icon;
  final String label;
  final dynamic value;
  final Color color;
  @override
  Widget build(BuildContext context) => SizedBox(
        width: 210,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              CircleAvatar(backgroundColor: color.withValues(alpha: 0.14), child: Icon(icon, color: color)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${value ?? 0}', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                Text(label, style: Theme.of(context).textTheme.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
              ])),
            ]),
          ),
        ),
      );
}

class _ChartCard extends StatelessWidget {
  const _ChartCard(this.title, this.child, {this.wide = false});
  final String title;
  final Widget child;
  final bool wide;
  @override
  Widget build(BuildContext context) => SizedBox(
        width: wide ? 520 : 400, height: 280,
        child: Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Expanded(child: child),
        ]))),
      );
}
