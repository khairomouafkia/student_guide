import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/error_text.dart';
import '../../../core/widgets/state_views.dart';
import '../../../l10n/app_localizations.dart';
import '../data/activity_repository.dart';
import 'activity_providers.dart';
import 'activity_sheet.dart';
import 'my_activities_page.dart';

const _types = ['cultural', 'sports', 'workshop', 'conference', 'competition', 'other'];

class ActivitiesPage extends ConsumerStatefulWidget {
  const ActivitiesPage({super.key});
  @override
  ConsumerState<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends ConsumerState<ActivitiesPage> {
  Timer? _debounce;
  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearch(String v) {
    _debounce?.cancel(); // debounced: one request per pause, not per keystroke
    _debounce = Timer(const Duration(milliseconds: 400),
        () => ref.read(activityFilterProvider.notifier).update((f) => f.copyWith(search: v)));
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final filter = ref.watch(activityFilterProvider);
    final async = ref.watch(activitiesProvider);
    final locale = Localizations.localeOf(context).toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(t.activities),
        actions: [
          IconButton(
            tooltip: t.myActivities,
            icon: const Icon(Icons.bookmark_border),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyActivitiesPage())),
          ),
        ],
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: TextField(
            onChanged: _onSearch,
            decoration: InputDecoration(hintText: t.searchHint, prefixIcon: const Icon(Icons.search)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: SegmentedButton<bool>(
            segments: [ButtonSegment(value: false, label: Text(t.upcoming)), ButtonSegment(value: true, label: Text(t.past))],
            selected: {filter.past},
            onSelectionChanged: (s) => ref.read(activityFilterProvider.notifier).update((f) => f.copyWith(past: s.first)),
          ),
        ),
        SizedBox(
          height: 52,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: ChoiceChip(
                  label: Text(t.filterAll),
                  selected: filter.type == null,
                  onSelected: (_) => ref.read(activityFilterProvider.notifier).update((f) => f.copyWith(clearType: true)),
                ),
              ),
              for (final type in _types)
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: ChoiceChip(
                    label: Text(activityTypeLabel(t, type)),
                    selected: filter.type == type,
                    onSelected: (_) => ref.read(activityFilterProvider.notifier).update((f) => f.copyWith(type: type)),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: async.when(
            loading: () => ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, __) => const SkeletonBox(height: 92, radius: 14),
            ),
            error: (e, _) => ErrorView(message: errorText(t, e), onRetry: () => ref.invalidate(activitiesProvider)),
            data: (s) => s.items.isEmpty
                ? EmptyView(icon: Icons.emoji_events_outlined, title: t.noActivities)
                : RefreshIndicator(
                    onRefresh: () async => ref.refresh(activitiesProvider.future),
                    child: ListView(padding: const EdgeInsets.all(16), children: [
                      if (s.fromCache) Padding(padding: const EdgeInsets.only(bottom: 8), child: Card(child: ListTile(leading: const Icon(Icons.cloud_off), title: Text(t.offlineData)))),
                      for (final a in s.items) Padding(padding: const EdgeInsets.only(bottom: 8), child: _ActivityCard(a, locale)),
                      if (s.hasMore) TextButton(onPressed: () => ref.read(activitiesProvider.notifier).loadMore(), child: Text(t.loadMore)),
                    ]),
                  ),
          ),
        ),
      ]),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard(this.a, this.locale);
  final Activity a;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final (label, color) = a.registered
        ? (t.statusRegistered, const Color(0xFF2E9D5B))
        : a.remaining == 0
            ? (t.statusFull, const Color(0xFFD64545))
            : a.canRegister
                ? (t.registerAction, Theme.of(context).colorScheme.primary)
                : (t.statusRegClosed, const Color(0xFFF08A24));
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => showActivitySheet(context, a),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Container(
              width: 56,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Column(children: [
                Text(DateFormat.d(locale).format(DateTime.parse(a.date)), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                Text(DateFormat.MMM(locale).format(DateTime.parse(a.date)), style: Theme.of(context).textTheme.bodySmall),
              ]),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(a.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 2),
                Text('${activityTypeLabel(t, a.type)} · ${a.start}${a.location != null ? ' · ${a.location}' : ''}',
                    maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall),
              ]),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(20)),
              child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
            ),
          ]),
        ),
      ),
    );
  }
}
