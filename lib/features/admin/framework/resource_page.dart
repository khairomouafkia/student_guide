import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/error_text.dart';
import '../../../core/widgets/state_views.dart';
import '../../../l10n/app_localizations.dart';
import '../data/admin_api.dart';
import 'form_dialog.dart';
import 'resource_config.dart';

/// Generic admin list: search, filters, sort, pagination, create / edit / delete with confirmation.
class ResourcePage extends ConsumerStatefulWidget {
  const ResourcePage({super.key, required this.config});
  final ResourceConfig config;
  @override
  ConsumerState<ResourcePage> createState() => _ResourcePageState();
}

class _ResourcePageState extends ConsumerState<ResourcePage> {
  static const _size = 20;
  final _search = TextEditingController();
  Timer? _debounce;
  int _page = 1;
  String? _sort;
  late String _order = widget.config.defaultOrder;
  final Json _filters = {};
  List<Json> _items = [];
  int _total = 0;
  bool _loading = true;
  Object? _error;

  ResourceConfig get cfg => widget.config;

  @override
  void initState() {
    super.initState();
    _sort = cfg.defaultSort;
    _load();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final q = <String, dynamic>{
        ...cfg.extraQuery, 'page': _page, 'pageSize': _size,
        if (_sort != null) 'sort': _sort, if (_sort != null) 'order': _order,
        if (_search.text.trim().isNotEmpty) cfg.searchParam: _search.text.trim(),
        for (final e in _filters.entries) e.key: (cfg.filters.firstWhere((f) => f.key == e.key).transform?.call('${e.value}') ?? e.value),
      };
      final r = await ref.read(adminApiProvider).list(cfg.endpoint, q);
      if (!mounted) return;
      setState(() { _items = r.items; _total = r.total; _error = null; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e; _loading = false; });
    }
  }

  void _reset() { _page = 1; _load(); }

  Future<void> _delete(Json row) async {
    final t = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final yes = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.confirmDeleteTitle),
        content: Text(t.confirmDeleteBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(t.cancelAction)),
          FilledButton(style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error, minimumSize: const Size(100, 44)), onPressed: () => Navigator.pop(context, true), child: Text(t.delete)),
        ],
      ),
    );
    if (yes != true) return;
    try {
      await ref.read(adminApiProvider).delete('${cfg.endpoint}/${row['id']}');
      messenger.showSnackBar(SnackBar(content: Text(t.deletedOk)));
      if (_items.length == 1 && _page > 1) _page--;
      _load();
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(errorText(t, e))));
    }
  }

  Future<void> _openForm([Json? row]) async {
    final t = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    if (await showResourceForm(context, cfg, row: row)) {
      messenger.showSnackBar(SnackBar(content: Text(t.savedOk)));
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final from = _total == 0 ? 0 : (_page - 1) * _size + 1;
    final to = (_page * _size).clamp(0, _total);
    final hasActions = cfg.canEdit || cfg.canDelete || cfg.rowActions.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(cfg.title(t), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700))),
          for (final h in cfg.headerActions)
            Padding(padding: const EdgeInsetsDirectional.only(end: 8), child: OutlinedButton.icon(icon: Icon(h.icon), label: Text(h.label(t)), onPressed: () async { await h.run(context, ref); _load(); })),
          if (cfg.canCreate && cfg.fields.isNotEmpty) FilledButton.icon(style: FilledButton.styleFrom(minimumSize: const Size(110, 44)), icon: const Icon(Icons.add), label: Text(t.add), onPressed: () => _openForm()),
        ]),
        if (cfg.banner != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Card(child: Padding(padding: const EdgeInsets.all(12), child: Row(children: [Icon(Icons.lock_outline, color: cs.primary), const SizedBox(width: 10), Expanded(child: Text(cfg.banner!(t)))]))),
          ),
        const SizedBox(height: 12),
        Wrap(spacing: 12, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
          if (cfg.hasSearch)
            SizedBox(
              width: 280,
              child: TextField(
                controller: _search,
                decoration: InputDecoration(hintText: t.searchHint, prefixIcon: const Icon(Icons.search), isDense: true),
                onChanged: (_) { _debounce?.cancel(); _debounce = Timer(const Duration(milliseconds: 400), _reset); },
              ),
            ),
          for (final f in cfg.filters) _FilterWidget(spec: f, value: _filters[f.key] as String?, onChanged: (v) { if (v == null) { _filters.remove(f.key); } else { _filters[f.key] = v; } _reset(); }),
          IconButton(tooltip: t.refresh, onPressed: _load, icon: const Icon(Icons.refresh)),
        ]),
        const SizedBox(height: 8),
        if (_loading) const LinearProgressIndicator(minHeight: 2),
        Expanded(
          child: _error != null && _items.isEmpty
              ? ErrorView(message: errorText(t, _error!), onRetry: _load)
              : (!_loading && _items.isEmpty)
                  ? EmptyView(icon: Icons.table_rows_outlined, title: t.noData)
                  : Card(
                      child: LayoutBuilder(
                        builder: (context, box) => SingleChildScrollView(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(minWidth: box.maxWidth),
                              child: DataTable(
                                showCheckboxColumn: false,
                                sortColumnIndex: _sort == null ? null : cfg.columns.indexWhere((c) => c.sortKey == _sort).clamp(0, cfg.columns.length - 1),
                                sortAscending: _order == 'asc',
                                columns: [
                                  for (final c in cfg.columns)
                                    DataColumn(label: Text(c.label(t), style: const TextStyle(fontWeight: FontWeight.w700)), onSort: c.sortKey == null ? null : (_, asc) { _sort = c.sortKey; _order = asc ? 'asc' : 'desc'; _reset(); }),
                                  if (hasActions) DataColumn(label: Text(t.actions, style: const TextStyle(fontWeight: FontWeight.w700))),
                                ],
                                rows: [
                                  for (final row in _items)
                                    DataRow(
                                      onSelectChanged: cfg.onRowTap == null ? null : (_) async { await cfg.onRowTap!(context, ref, row); _load(); },
                                      cells: [
                                        for (final c in cfg.columns)
                                          DataCell(c.chip
                                              ? Chip(label: Text(c.value(row, t)), visualDensity: VisualDensity.compact)
                                              : ConstrainedBox(constraints: const BoxConstraints(maxWidth: 280), child: Text(c.value(row, t), overflow: TextOverflow.ellipsis, maxLines: 2))),
                                        if (hasActions)
                                          DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
                                            if (cfg.canEdit && cfg.fields.isNotEmpty) IconButton(tooltip: t.edit, icon: const Icon(Icons.edit_outlined), onPressed: () => _openForm(row)),
                                            if (cfg.canDelete) IconButton(tooltip: t.delete, icon: Icon(Icons.delete_outline, color: cs.error), onPressed: () => _delete(row)),
                                            for (final a in cfg.rowActions)
                                              if (a.visible?.call(row) ?? true)
                                                IconButton(tooltip: a.label(t), icon: Icon(a.icon), onPressed: () async { await a.run(context, ref, row); _load(); }),
                                          ])),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text(t.pageInfo(from, to, _total)),
          IconButton(onPressed: _page > 1 ? () { _page--; _load(); } : null, icon: const Icon(Icons.chevron_left)),
          IconButton(onPressed: to < _total ? () { _page++; _load(); } : null, icon: const Icon(Icons.chevron_right)),
        ]),
      ]),
    );
  }
}

class _FilterWidget extends ConsumerStatefulWidget {
  const _FilterWidget({required this.spec, required this.value, required this.onChanged});
  final FilterSpec spec;
  final String? value;
  final ValueChanged<String?> onChanged;
  @override
  ConsumerState<_FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends ConsumerState<_FilterWidget> {
  Future<PageData>? _future;
  @override
  void initState() {
    super.initState();
    if (widget.spec.type == FilterType.ref) _future = ref.read(adminApiProvider).list(widget.spec.refEndpoint!, {'page': 1, 'pageSize': 100});
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final s = widget.spec;
    if (s.type == FilterType.date) {
      return OutlinedButton.icon(
        icon: const Icon(Icons.event),
        label: Text(widget.value ?? s.label(t)),
        onPressed: () async {
          final d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2100));
          widget.onChanged(d == null ? null : d.toIso8601String().substring(0, 10));
        },
        onLongPress: () => widget.onChanged(null),
      );
    }
    Widget drop(List<DropdownMenuItem<String?>> items) => SizedBox(
          width: 190,
          child: DropdownButtonFormField<String?>(
            value: widget.value, isDense: true, isExpanded: true,
            decoration: InputDecoration(labelText: s.label(t), isDense: true),
            items: [DropdownMenuItem<String?>(value: null, child: Text(t.filterAll)), ...items],
            onChanged: widget.onChanged,
          ),
        );
    if (s.type == FilterType.select) {
      return drop([for (final o in s.options) DropdownMenuItem<String?>(value: o.value, child: Text(o.label(t)))]);
    }
    return FutureBuilder<PageData>(
      future: _future,
      builder: (_, snap) => drop([for (final e in snap.data?.items ?? const <Json>[]) DropdownMenuItem<String?>(value: e['id'] as String, child: Text('${e[s.refLabel]}', overflow: TextOverflow.ellipsis))]),
    );
  }
}
