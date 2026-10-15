import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/error_text.dart';
import '../../../l10n/app_localizations.dart';
import '../data/admin_api.dart';

/// Minimal CSV reader (quotes, commas, CRLF). The server validates every row again.
List<Map<String, String>> parseCsv(String text) {
  final rows = <List<String>>[];
  var row = <String>[], cur = StringBuffer(), quoted = false;
  final src = text.replaceAll('\r\n', '\n').replaceAll('\r', '\n').replaceFirst('\uFEFF', '');
  for (var i = 0; i < src.length; i++) {
    final c = src[i];
    if (quoted) {
      if (c == '"' && i + 1 < src.length && src[i + 1] == '"') { cur.write('"'); i++; }
      else if (c == '"') { quoted = false; }
      else { cur.write(c); }
    } else if (c == '"') { quoted = true; }
    else if (c == ',' || c == ';') { row.add(cur.toString().trim()); cur = StringBuffer(); }
    else if (c == '\n') { row.add(cur.toString().trim()); cur = StringBuffer(); if (row.any((e) => e.isNotEmpty)) rows.add(row); row = <String>[]; }
    else { cur.write(c); }
  }
  row.add(cur.toString().trim());
  if (row.any((e) => e.isNotEmpty)) rows.add(row);
  if (rows.length < 2) return [];
  final head = rows.first;
  return [for (final r in rows.skip(1)) {for (var i = 0; i < head.length && i < r.length; i++) head[i]: r[i]}];
}

Future<void> importStudentsAction(BuildContext context, WidgetRef ref) =>
    showDialog(context: context, barrierDismissible: false, builder: (_) => const _ImportDialog());

class _ImportDialog extends ConsumerStatefulWidget {
  const _ImportDialog();
  @override
  ConsumerState<_ImportDialog> createState() => _ImportDialogState();
}

class _ImportDialogState extends ConsumerState<_ImportDialog> {
  List<Map<String, String>> _rows = [];
  bool _invites = false, _busy = false;
  Json? _result;
  String? _error;

  Future<void> _pick() async {
    final r = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['csv'], withData: true);
    if (r == null || r.files.first.bytes == null) return;
    setState(() { _rows = parseCsv(utf8.decode(r.files.first.bytes!, allowMalformed: true)); _result = null; _error = null; });
  }

  Future<void> _run() async {
    final t = AppLocalizations.of(context)!;
    setState(() { _busy = true; _error = null; });
    try {
      final d = await ref.read(adminApiProvider).post('/admin/students/import', body: {'students': _rows, 'sendInvites': _invites});
      setState(() { _result = Json.from(d as Map); _busy = false; });
    } catch (e) {
      setState(() { _busy = false; _error = errorText(t, e); });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final failed = [for (final r in (_result?['results'] as List? ?? const [])) if (r['status'] == 'error') r];
    return AlertDialog(
      title: Text(t.importCsv),
      content: SizedBox(
        width: 560,
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t.importHint, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 12),
            OutlinedButton.icon(icon: const Icon(Icons.upload_file), label: Text(t.chooseCsv), onPressed: _busy ? null : _pick),
            if (_rows.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8), child: Text(t.rowsReady(_rows.length))),
            SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(t.sendInvites), value: _invites, onChanged: _busy ? null : (v) => setState(() => _invites = v)),
            if (_error != null) Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            if (_result != null) ...[
              const Divider(),
              Text(t.importResult(_result!['created'] as int, _result!['failed'] as int), style: Theme.of(context).textTheme.titleSmall),
              for (final f in failed.take(50))
                ListTile(dense: true, contentPadding: EdgeInsets.zero, leading: const Icon(Icons.error_outline, color: Colors.red, size: 18), title: Text(t.rowLabel(f['row'] as int)), subtitle: Text('${f['error']}')),
            ],
          ]),
        ),
      ),
      actions: [
        TextButton(onPressed: _busy ? null : () => Navigator.pop(context), child: Text(t.close)),
        if (_result == null)
          FilledButton(style: FilledButton.styleFrom(minimumSize: const Size(130, 44)), onPressed: (_rows.isEmpty || _busy) ? null : _run,
              child: _busy ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)) : Text(t.startImport)),
      ],
    );
  }
}
