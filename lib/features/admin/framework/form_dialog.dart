import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/error_text.dart';
import '../../../l10n/app_localizations.dart';
import '../data/admin_api.dart';
import 'resource_config.dart';

/// Create / edit dialog generated from the [FieldSpec]s. Returns true when something was saved.
Future<bool> showResourceForm(BuildContext context, ResourceConfig cfg, {Json? row}) async =>
    await showDialog<bool>(context: context, barrierDismissible: false, builder: (_) => ResourceForm(cfg: cfg, row: row)) ?? false;

class ResourceForm extends ConsumerStatefulWidget {
  const ResourceForm({super.key, required this.cfg, this.row});
  final ResourceConfig cfg;
  final Json? row;
  @override
  ConsumerState<ResourceForm> createState() => _ResourceFormState();
}

class _ResourceFormState extends ConsumerState<ResourceForm> {
  final _form = GlobalKey<FormState>();
  final _ctrl = <String, TextEditingController>{};
  final _values = <String, dynamic>{};
  bool _busy = false;
  String? _error;

  bool get _editing => widget.row != null;
  List<FieldSpec> get _fields => [for (final f in widget.cfg.fields) if (!(f.createOnly && _editing) && !(f.editOnly && !_editing)) f];

  @override
  void initState() {
    super.initState();
    final init = _editing ? (widget.cfg.toInitial?.call(widget.row!) ?? widget.row!) : <String, dynamic>{};
    for (final f in _fields) {
      final v = _editing ? init[f.key] : f.initial;
      switch (f.type) {
        case FieldType.text:
        case FieldType.multiline:
        case FieldType.integer:
        case FieldType.number:
          _ctrl[f.key] = TextEditingController(text: v == null ? '' : '$v');
        case FieldType.json:
          _ctrl[f.key] = TextEditingController(text: v == null ? '' : const JsonEncoder.withIndent(' ').convert(v));
        case FieldType.boolean:
          _values[f.key] = v == true;
        case FieldType.time:
          _values[f.key] = v == null ? null : '$v'.substring(0, 5);
        case FieldType.datetime:
          _values[f.key] = v == null ? null : DateTime.tryParse('$v')?.toLocal();
        case FieldType.stringList:
          _values[f.key] = [for (final e in (v as List? ?? const [])) '$e'];
        case FieldType.hours:
          _values[f.key] = [for (final e in (v as List? ?? const [])) {'day': e['day'], 'from': '${e['from']}'.substring(0, 5), 'to': '${e['to']}'.substring(0, 5)}];
        case FieldType.weekdays:
          _values[f.key] = [for (final e in (v as List? ?? const <int>[0, 1, 2, 3, 4])) e as int];
        default:
          _values[f.key] = v;
      }
    }
  }

  @override
  void dispose() {
    for (final c in _ctrl.values) {
      c.dispose();
    }
    super.dispose();
  }

  /// Builds the request body; empty optional fields are omitted.
  Json _body() {
    final body = <String, dynamic>{};
    for (final f in _fields) {
      switch (f.type) {
        case FieldType.text:
        case FieldType.multiline:
          final s = _ctrl[f.key]!.text.trim();
          if (s.isNotEmpty) body[f.key] = s;
        case FieldType.integer:
          final s = _ctrl[f.key]!.text.trim();
          if (s.isNotEmpty) body[f.key] = int.parse(s);
        case FieldType.number:
          final s = _ctrl[f.key]!.text.trim();
          if (s.isNotEmpty) body[f.key] = double.parse(s.replaceAll(',', '.'));
        case FieldType.json:
          final s = _ctrl[f.key]!.text.trim();
          if (s.isNotEmpty) body[f.key] = jsonDecode(s);
        case FieldType.datetime:
          final d = _values[f.key] as DateTime?;
          if (d != null) {
            body[f.key] = d.toUtc().toIso8601String();
          } else if (_editing && widget.row![f.key] != null) {
            body[f.key] = null;
          }
        case FieldType.boolean:
          body[f.key] = _values[f.key] == true;
        case FieldType.stringList:
        case FieldType.hours:
        case FieldType.weekdays:
          body[f.key] = _values[f.key];
        default:
          final v = _values[f.key];
          if (v != null && '$v'.isNotEmpty) {
            body[f.key] = v;
          } else if (_editing && !f.required && (f.type == FieldType.ref) && widget.row![f.key] != null) {
            body[f.key] = null; // the admin cleared an optional link
          }
      }
    }
    return body;
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final t = AppLocalizations.of(context)!;
    final api = ref.read(adminApiProvider);
    final cfg = widget.cfg;
    setState(() { _busy = true; _error = null; });
    try {
      final body = _body();
      if (_editing) {
        final path = '${cfg.endpoint}/${widget.row!['id']}';
        await (cfg.patchUpdate ? api.patch(path, body: body) : api.put(path, body: body));
      } else {
        await api.post(cfg.endpoint, body: body);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) setState(() { _busy = false; _error = _message(t, e); });
    }
  }

  String _message(AppLocalizations t, Object e) {
    final generic = errorText(t, e);
    // validation errors carry a useful message from the server ("field: reason")
    final s = '$e';
    final m = RegExp(r'ApiException\(VALIDATION_ERROR[^)]*\): (.*)$').firstMatch(s);
    return m != null ? m.group(1)! : generic;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final fields = _fields;
    return AlertDialog(
      title: Text(widget.cfg.title(t)),
      content: SizedBox(
        width: 560,
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              for (final f in fields) Padding(padding: const EdgeInsets.only(bottom: 14), child: _field(context, t, f)),
              if (_error != null) Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ]),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: _busy ? null : () => Navigator.pop(context, false), child: Text(t.cancelAction)),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(110, 44)),
          onPressed: _busy ? null : _save,
          child: _busy ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)) : Text(t.save),
        ),
      ],
    );
  }

  String? _req(AppLocalizations t, FieldSpec f, String? v) => f.required && (v == null || v.trim().isEmpty) ? t.requiredField : null;

  Widget _field(BuildContext context, AppLocalizations t, FieldSpec f) {
    final label = f.label(t) + (f.required ? ' *' : '');
    final locale = Localizations.localeOf(context).toString();
    switch (f.type) {
      case FieldType.text:
      case FieldType.multiline:
        return TextFormField(
          controller: _ctrl[f.key], maxLines: f.type == FieldType.multiline ? 4 : 1,
          decoration: InputDecoration(labelText: label, helperText: f.hint?.call(t)), validator: (v) => _req(t, f, v));
      case FieldType.integer:
        return TextFormField(
          controller: _ctrl[f.key], keyboardType: TextInputType.number, decoration: InputDecoration(labelText: label),
          validator: (v) => _req(t, f, v) ?? ((v ?? '').trim().isNotEmpty && int.tryParse(v!.trim()) == null ? t.requiredField : null));
      case FieldType.number:
        return TextFormField(
          controller: _ctrl[f.key], keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true), decoration: InputDecoration(labelText: label),
          validator: (v) => _req(t, f, v) ?? ((v ?? '').trim().isNotEmpty && double.tryParse(v!.trim().replaceAll(',', '.')) == null ? t.requiredField : null));
      case FieldType.json:
        return TextFormField(
          controller: _ctrl[f.key], maxLines: 5, decoration: InputDecoration(labelText: label),
          validator: (v) {
            final r = _req(t, f, v);
            if (r != null || (v ?? '').trim().isEmpty) return r;
            try { jsonDecode(v!); return null; } catch (_) { return t.requiredField; }
          });
      case FieldType.boolean:
        return SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(label), value: _values[f.key] == true, onChanged: (v) => setState(() => _values[f.key] = v));
      case FieldType.select:
        return DropdownButtonFormField<String>(
          value: f.options.any((o) => o.value == _values[f.key]) ? _values[f.key] as String : null,
          decoration: InputDecoration(labelText: label),
          items: [for (final o in f.options) DropdownMenuItem(value: o.value, child: Text(o.label(t)))],
          validator: (v) => _req(t, f, v), onChanged: (v) => setState(() => _values[f.key] = v));
      case FieldType.ref:
        return _RefDropdown(spec: f, label: label, optional: !f.required, value: _values[f.key] as String?, onChanged: (v) => setState(() => _values[f.key] = v), validator: (v) => _req(t, f, v));
      case FieldType.date:
        return _PickerField(
          label: label, valueText: _values[f.key] == null ? '' : '${_values[f.key]}',
          validator: () => f.required && _values[f.key] == null ? t.requiredField : null,
          onTap: () async {
            final init = DateTime.tryParse('${_values[f.key] ?? ''}') ?? DateTime.now();
            final d = await showDatePicker(context: context, initialDate: init, firstDate: DateTime(2020), lastDate: DateTime(2100));
            if (d != null) setState(() => _values[f.key] = DateFormat('yyyy-MM-dd').format(d));
          });
      case FieldType.time:
        return _PickerField(
          label: label, valueText: '${_values[f.key] ?? ''}',
          validator: () => f.required && _values[f.key] == null ? t.requiredField : null,
          onTap: () async {
            final p = (_values[f.key] as String?)?.split(':');
            final init = p == null ? TimeOfDay.now() : TimeOfDay(hour: int.parse(p[0]), minute: int.parse(p[1]));
            final x = await showTimePicker(context: context, initialTime: init);
            if (x != null) setState(() => _values[f.key] = '${x.hour.toString().padLeft(2, '0')}:${x.minute.toString().padLeft(2, '0')}');
          });
      case FieldType.datetime:
        final d = _values[f.key] as DateTime?;
        return _PickerField(
          label: label, valueText: d == null ? '' : DateFormat.yMMMd(locale).add_Hm().format(d),
          validator: () => f.required && d == null ? t.requiredField : null,
          onTap: () async {
            final day = await showDatePicker(context: context, initialDate: d ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2100));
            if (day == null || !mounted) return;
            final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(d ?? DateTime.now()));
            if (time != null) setState(() => _values[f.key] = DateTime(day.year, day.month, day.day, time.hour, time.minute));
          });
      case FieldType.stringList:
        return _StringListField(label: label, items: List<String>.from(_values[f.key]), onChanged: (l) => setState(() => _values[f.key] = l));
      case FieldType.weekdays:
        final sel = List<int>.from(_values[f.key]);
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 6),
          Wrap(spacing: 6, children: [
            for (var i = 0; i < 7; i++)
              FilterChip(
                label: Text(DateFormat.E(locale).format(DateTime(2024, 1, 7 + i))), // 2024-01-07 is a Sunday: 0 = Sunday
                selected: sel.contains(i),
                onSelected: (on) => setState(() => _values[f.key] = on ? ([...sel, i]..sort()) : sel.where((d) => d != i).toList()),
              ),
          ]),
        ]);
      case FieldType.hours:
        return _HoursField(label: label, rows: List<Map<String, dynamic>>.from((_values[f.key] as List).map((e) => Map<String, dynamic>.from(e))), onChanged: (l) => setState(() => _values[f.key] = l));
    }
  }
}

class _PickerField extends FormField<String> {
  _PickerField({required String label, required String valueText, required VoidCallback onTap, required String? Function() validator})
      : super(
          validator: (_) => validator(),
          builder: (state) => InkWell(
            onTap: onTap,
            child: InputDecorator(
              decoration: InputDecoration(labelText: label, errorText: state.errorText, suffixIcon: const Icon(Icons.edit_calendar_outlined)),
              child: Text(valueText.isEmpty ? ' ' : valueText),
            ),
          ),
        );
}

class _RefDropdown extends ConsumerStatefulWidget {
  const _RefDropdown({required this.spec, required this.label, required this.optional, required this.value, required this.onChanged, required this.validator});
  final bool optional;
  final FieldSpec spec;
  final String label;
  final String? value;
  final ValueChanged<String?> onChanged;
  final String? Function(String?) validator;
  @override
  ConsumerState<_RefDropdown> createState() => _RefDropdownState();
}

class _RefDropdownState extends ConsumerState<_RefDropdown> {
  late final Future<PageData> _future = ref.read(adminApiProvider).list(widget.spec.refEndpoint!, {'page': 1, 'pageSize': 100});
  @override
  Widget build(BuildContext context) => FutureBuilder<PageData>(
        future: _future,
        builder: (_, snap) {
          final items = snap.data?.items ?? const <Json>[];
          final ok = items.any((e) => e['id'] == widget.value);
          return DropdownButtonFormField<String>(
            value: ok ? widget.value : null,
            isExpanded: true,
            decoration: InputDecoration(labelText: widget.label, suffixIcon: snap.connectionState != ConnectionState.done ? const Padding(padding: EdgeInsets.all(12), child: SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))) : null),
            items: [
              if (widget.optional) const DropdownMenuItem<String>(value: null, child: Text('—')),
              for (final e in items) DropdownMenuItem(value: e['id'] as String, child: Text('${e[widget.spec.refLabel] ?? e['id']}', overflow: TextOverflow.ellipsis)),
            ],
            validator: widget.validator,
            onChanged: widget.onChanged,
          );
        },
      );
}

class _StringListField extends StatefulWidget {
  const _StringListField({required this.label, required this.items, required this.onChanged});
  final String label;
  final List<String> items;
  final ValueChanged<List<String>> onChanged;
  @override
  State<_StringListField> createState() => _StringListFieldState();
}

class _StringListFieldState extends State<_StringListField> {
  final _c = TextEditingController();
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _add() {
    final v = _c.text.trim();
    if (v.isEmpty) return;
    widget.onChanged([...widget.items, v]);
    _c.clear();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(child: TextField(controller: _c, decoration: InputDecoration(labelText: widget.label), onSubmitted: (_) => _add())),
        const SizedBox(width: 8),
        IconButton.filledTonal(tooltip: t.fAddItem, onPressed: _add, icon: const Icon(Icons.add)),
      ]),
      if (widget.items.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Wrap(spacing: 6, runSpacing: 6, children: [
            for (final i in widget.items) InputChip(label: Text(i), onDeleted: () => widget.onChanged(widget.items.where((x) => x != i).toList())),
          ]),
        ),
    ]);
  }
}

class _HoursField extends StatelessWidget {
  const _HoursField({required this.label, required this.rows, required this.onChanged});
  final String label;
  final List<Map<String, dynamic>> rows;
  final ValueChanged<List<Map<String, dynamic>>> onChanged;

  Future<String?> _pick(BuildContext context, String? cur) async {
    final p = cur?.split(':');
    final x = await showTimePicker(context: context, initialTime: p == null ? const TimeOfDay(hour: 8, minute: 0) : TimeOfDay(hour: int.parse(p[0]), minute: int.parse(p[1])));
    return x == null ? null : '${x.hour.toString().padLeft(2, '0')}:${x.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Expanded(child: Text(label, style: Theme.of(context).textTheme.bodySmall)), TextButton.icon(icon: const Icon(Icons.add), label: Text(t.fAddItem), onPressed: () => onChanged([...rows, {'day': 0, 'from': '08:00', 'to': '16:00'}]))]),
      for (var i = 0; i < rows.length; i++)
        Row(children: [
          Expanded(
            flex: 3,
            child: DropdownButton<int>(
              isExpanded: true,
              value: rows[i]['day'] as int,
              items: [for (var d = 0; d < 7; d++) DropdownMenuItem(value: d, child: Text(DateFormat.EEEE(locale).format(DateTime(2024, 1, 7 + d))))],
              onChanged: (v) => onChanged([for (var j = 0; j < rows.length; j++) j == i ? {...rows[j], 'day': v} : rows[j]]),
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(onPressed: () async { final v = await _pick(context, rows[i]['from']); if (v != null) onChanged([for (var j = 0; j < rows.length; j++) j == i ? {...rows[j], 'from': v} : rows[j]]); }, child: Text('${rows[i]['from']}')),
          const SizedBox(width: 6),
          OutlinedButton(onPressed: () async { final v = await _pick(context, rows[i]['to']); if (v != null) onChanged([for (var j = 0; j < rows.length; j++) j == i ? {...rows[j], 'to': v} : rows[j]]); }, child: Text('${rows[i]['to']}')),
          IconButton(onPressed: () => onChanged([for (var j = 0; j < rows.length; j++) if (j != i) rows[j]]), icon: const Icon(Icons.close)),
        ]),
    ]);
  }
}
