import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/error_text.dart';
import '../../../core/widgets/state_views.dart';
import '../../../l10n/app_localizations.dart';
import '../data/admin_api.dart';
import '../framework/helpers.dart';

class RatingsPage extends ConsumerStatefulWidget {
  const RatingsPage({super.key, required this.services});
  final List<String> services; // restaurant | transport | activities
  @override
  ConsumerState<RatingsPage> createState() => _RatingsPageState();
}

class _RatingsPageState extends ConsumerState<RatingsPage> {
  late String _service = widget.services.first;
  Json? _data;
  Object? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final d = await ref.read(adminApiProvider).get('/ratings', query: {'service': _service, 'pageSize': 50});
      if (mounted) setState(() { _data = Json.from(d as Map); _error = null; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e; _loading = false; });
    }
  }

  String _name(AppLocalizations t, String s) => switch (s) { 'restaurant' => t.restaurant, 'transport' => t.transport, _ => t.activities };

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final items = [for (final i in (_data?['items'] as List? ?? const [])) Json.from(i as Map)];
    final sum = _data?['summary'] as Map?;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(t.mRatings, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        if (widget.services.length > 1)
          SegmentedButton<String>(
            segments: [for (final s in widget.services) ButtonSegment(value: s, label: Text(_name(t, s)))],
            selected: {_service}, onSelectionChanged: (v) { _service = v.first; _load(); },
          ),
        const SizedBox(height: 12),
        if (_loading) const LinearProgressIndicator(),
        if (_error != null) Expanded(child: ErrorView(message: errorText(t, _error!), onRetry: _load))
        else ...[
          Row(children: [
            const Icon(Icons.star_rounded, color: Colors.amber, size: 36),
            const SizedBox(width: 8),
            Text(sum?['average'] == null ? '—' : '${sum!['average']}', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(width: 12),
            Text(t.rtCount((sum?['count'] ?? 0) as int)),
          ]),
          const SizedBox(height: 12),
          Expanded(
            child: items.isEmpty
                ? EmptyView(icon: Icons.star_border, title: t.noRatings)
                : Card(child: ListView.separated(
                    itemCount: items.length, separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final r = items[i];
                      return ListTile(
                        leading: Row(mainAxisSize: MainAxisSize.min, children: [for (var s = 1; s <= 5; s++) Icon(s <= (r['stars'] as int) ? Icons.star_rounded : Icons.star_outline_rounded, size: 18, color: Colors.amber)]),
                        title: Text(r['comment'] == null ? '—' : '${r['comment']}'),
                        trailing: Text(stamp(r['created_at'], null)),
                      );
                    })),
          ),
        ],
      ]),
    );
  }
}
