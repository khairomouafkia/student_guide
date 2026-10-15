import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/error_text.dart';
import '../../../core/widgets/state_views.dart';
import '../../../l10n/app_localizations.dart';
import 'health_providers.dart';
import 'medical_documents_page.dart';
import '../../restaurant/presentation/rate_service.dart';

class HealthPage extends ConsumerWidget {
  const HealthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final center = ref.watch(healthCenterProvider);
    final doctors = ref.watch(doctorsProvider);
    final locale = Localizations.localeOf(context).toString();
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(t.health)),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(healthCenterProvider);
          await ref.read(doctorsProvider.future);
        },
        child: ListView(padding: const EdgeInsets.all(16), children: [
          Card(
            child: ListTile(
              leading: CircleAvatar(backgroundColor: cs.primary.withValues(alpha: 0.12), child: Icon(Icons.description_outlined, color: cs.primary)),
              title: Text(t.medicalDocuments, style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(t.reviewWithin72),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MedicalDocumentsPage())),
            ),
          ),
          const SizedBox(height: 20),
          Text(t.healthCenter, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          center.when(
            loading: () => const SkeletonBox(height: 120, radius: 14),
            error: (e, _) => ErrorView(message: errorText(t, e), onRetry: () => ref.invalidate(healthCenterProvider)),
            data: (c) => c == null
                ? Padding(padding: const EdgeInsets.all(16), child: Text(t.noCenter))
                : Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Expanded(child: Text(c.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16))),
                          Chip(
                            label: Text(c.isOpen ? t.openNow : t.closedNow),
                            backgroundColor: (c.isOpen ? const Color(0xFF2E9D5B) : const Color(0xFFD64545)).withValues(alpha: 0.14),
                          ),
                        ]),
                        Align(alignment: AlignmentDirectional.centerEnd, child: TextButton.icon(icon: const Icon(Icons.star_outline_rounded), label: Text(t.rateService), onPressed: () => rateService(context, ref, 'health', c.id))),
                        if (c.location != null) Row(children: [const Icon(Icons.place_outlined, size: 18), const SizedBox(width: 6), Expanded(child: Text(c.location!))]),
                        if (c.hours.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(t.openingHours, style: Theme.of(context).textTheme.titleSmall),
                          const SizedBox(height: 4),
                          for (final h in c.hours)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              // 2024-01-07 was a Sunday: day 0 = Sunday
                              child: Row(children: [
                                SizedBox(width: 90, child: Text(DateFormat.EEEE(locale).format(DateTime(2024, 1, 7 + h.day)))),
                                Text('${h.from} – ${h.to}'),
                              ]),
                            ),
                        ],
                      ]),
                    ),
                  ),
          ),
          const SizedBox(height: 20),
          Text(t.doctors, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          doctors.when(
            loading: () => const Column(children: [SkeletonBox(height: 64, radius: 14), SizedBox(height: 8), SkeletonBox(height: 64, radius: 14)]),
            error: (e, _) => ErrorView(message: errorText(t, e), onRetry: () => ref.invalidate(doctorsProvider)),
            data: (list) => list.isEmpty
                ? Padding(padding: const EdgeInsets.all(16), child: Text(t.noDoctors))
                : Column(children: [
                    for (final d in list)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: d.photoUrl != null ? NetworkImage(d.photoUrl!) : null,
                              child: d.photoUrl == null ? Text(d.name.isEmpty ? '?' : d.name[0].toUpperCase()) : null,
                            ),
                            title: Text(d.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: Text([if (d.specialty != null) d.specialty!, if (d.office != null) '${t.office} ${d.office}'].join(' · ')),
                            trailing: Icon(Icons.circle, size: 12, color: d.available ? const Color(0xFF2E9D5B) : Colors.grey),
                          ),
                        ),
                      ),
                  ]),
          ),
        ]),
      ),
    );
  }
}
