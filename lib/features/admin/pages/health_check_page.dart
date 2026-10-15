import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/error_text.dart';
import '../../../core/widgets/state_views.dart';
import '../../../l10n/app_localizations.dart';
import '../data/admin_api.dart';
import '../framework/helpers.dart';

final _healthProvider = FutureProvider.autoDispose<Json>((ref) async => Json.from(await ref.watch(adminApiProvider).get('/admin/health-check') as Map));

class HealthCheckPage extends ConsumerWidget {
  const HealthCheckPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    return ref.watch(_healthProvider).when(
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(message: errorText(t, e), onRetry: () => ref.invalidate(_healthProvider)),
          data: (d) {
            final s = Map<String, dynamic>.from(d['services'] as Map);
            final c = Map<String, dynamic>.from(d['configured'] as Map);
            Widget svc(String label, Map x) {
              final up = x['status'] == 'up';
              return Card(child: ListTile(
                leading: Icon(up ? Icons.check_circle : Icons.error, color: up ? const Color(0xFF2E9D5B) : const Color(0xFFD64545)),
                title: Text(label), subtitle: Text(up ? t.hcLatency(x['ms'] as int) : '${x['error']}'),
                trailing: Text(up ? t.hcUp : t.hcDown, style: TextStyle(fontWeight: FontWeight.w700, color: up ? const Color(0xFF2E9D5B) : const Color(0xFFD64545))),
              ));
            }
            Widget cfg(String label, bool on) => Card(child: ListTile(
                  leading: Icon(on ? Icons.toggle_on : Icons.toggle_off, size: 32, color: on ? const Color(0xFF2E9D5B) : Colors.grey),
                  title: Text(label), trailing: Text(on ? t.hcConfigured : t.hcNotConfigured)));
            return ListView(padding: const EdgeInsets.all(20), children: [
              Row(children: [
                Expanded(child: Text(t.mHealthCheck, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700))),
                IconButton(tooltip: t.refresh, onPressed: () => ref.invalidate(_healthProvider), icon: const Icon(Icons.refresh)),
              ]),
              Text(stamp(d['checkedAt'], null), style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 12),
              svc(t.hcDatabase, s['database'] as Map), svc(t.hcStorage, s['storage'] as Map), svc(t.hcAuth, s['auth'] as Map),
              const SizedBox(height: 12),
              cfg(t.hcPush, c['push'] == true), cfg(t.hcAi, c['smartComplaints'] == true), cfg(t.hcJobs, c['backgroundJobs'] == true),
            ]);
          },
        );
  }
}
