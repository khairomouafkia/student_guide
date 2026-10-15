import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/error_text.dart';
import '../../../core/widgets/state_views.dart';
import '../../../l10n/app_localizations.dart';
import 'complaint_detail_page.dart';
import 'complaint_providers.dart';
import 'new_complaint_page.dart';
import 'status_chip.dart';

class ComplaintsPage extends ConsumerWidget {
  const ComplaintsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final async = ref.watch(complaintsProvider);
    final locale = Localizations.localeOf(context).toString();

    return Scaffold(
      appBar: AppBar(title: Text(t.myComplaints)),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: Text(t.newComplaint),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NewComplaintPage())),
      ),
      body: async.when(
        loading: () => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: 4,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, __) => const SkeletonBox(height: 72, radius: 14),
        ),
        error: (e, _) => ErrorView(message: errorText(t, e), onRetry: () => ref.invalidate(complaintsProvider)),
        data: (s) => s.items.isEmpty
            ? EmptyView(icon: Icons.report_gmailerrorred_outlined, title: t.noComplaints)
            : RefreshIndicator(
                onRefresh: () async => ref.refresh(complaintsProvider.future),
                child: ListView(padding: const EdgeInsets.fromLTRB(16, 16, 16, 96), children: [
                  for (final c in s.items)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Card(
                        child: ListTile(
                          title: Text(c.subject, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
                          subtitle: Text('${complaintCategoryLabel(t, c.category)} · ${DateFormat.MMMd(locale).format(c.createdAt)}'),
                          trailing: ComplaintStatusChip(c.status),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ComplaintDetailPage(id: c.id))),
                        ),
                      ),
                    ),
                  if (s.hasMore) TextButton(onPressed: () => ref.read(complaintsProvider.notifier).loadMore(), child: Text(t.loadMore)),
                ]),
              ),
      ),
    );
  }
}
