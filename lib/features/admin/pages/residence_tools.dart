import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/error_text.dart';
import '../../../l10n/app_localizations.dart';
import '../data/admin_api.dart';

Future<void> assignStudentAction(BuildContext context, WidgetRef ref) =>
    showDialog(context: context, builder: (_) => const _AssignDialog());

class _AssignDialog extends ConsumerStatefulWidget {
  const _AssignDialog();
  @override
  ConsumerState<_AssignDialog> createState() => _AssignDialogState();
}

class _AssignDialogState extends ConsumerState<_AssignDialog> {
  final _q = TextEditingController();
  Timer? _debounce;
  List<Json> _students = [], _residences = [], _rooms = [];
  Json? _student;
  String? _residenceId, _roomId, _error;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    ref.read(adminApiProvider).list('/residences', {'pageSize': 100}).then((r) { if (mounted) setState(() => _residences = r.items); });
    ref.read(adminApiProvider).list('/residences/rooms', {'pageSize': 100}).then((r) { if (mounted) setState(() => _rooms = r.items); });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _q.dispose();
    super.dispose();
  }

  void _search(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (v.trim().length < 2) return setState(() => _students = []);
      final r = await ref.read(adminApiProvider).list('/residences/students', {'search': v.trim(), 'pageSize': 10});
      if (mounted) setState(() => _students = r.items);
    });
  }

  Future<void> _save() async {
    final t = AppLocalizations.of(context)!;
    setState(() { _busy = true; _error = null; });
    try {
      await ref.read(adminApiProvider).post('/residences/assignments', body: {'studentId': _student!['id'], 'residenceId': _residenceId, 'roomId': _roomId});
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) setState(() { _busy = false; _error = errorText(t, e); });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(t.fStudent),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            TextField(controller: _q, onChanged: _search, decoration: InputDecoration(hintText: t.searchHint, prefixIcon: const Icon(Icons.search))),
            for (final s in _students)
              ListTile(
                dense: true, selected: _student?['id'] == s['id'],
                title: Text('${s['fullName']}'), subtitle: Text('${s['registrationNumber']}'),
                onTap: () => setState(() { _student = s; _residenceId = s['residenceId'] as String?; }),
              ),
            if (_student != null) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _residences.any((r) => r['id'] == _residenceId) ? _residenceId : null, isExpanded: true,
                decoration: InputDecoration(labelText: t.fResidence),
                items: [for (final r in _residences) DropdownMenuItem(value: r['id'] as String, child: Text('${r['name']}'))],
                onChanged: (v) => setState(() { _residenceId = v; _roomId = null; }),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _rooms.any((r) => r['id'] == _roomId) ? _roomId : null, isExpanded: true,
                decoration: InputDecoration(labelText: t.fRoom),
                items: [const DropdownMenuItem<String>(value: null, child: Text('—')), for (final r in _rooms) DropdownMenuItem(value: r['id'] as String, child: Text('${r['room_number']}'))],
                onChanged: (v) => setState(() => _roomId = v),
              ),
            ],
            if (_error != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error))),
          ]),
        ),
      ),
      actions: [
        TextButton(onPressed: _busy ? null : () => Navigator.pop(context), child: Text(t.cancelAction)),
        FilledButton(style: FilledButton.styleFrom(minimumSize: const Size(110, 44)), onPressed: (_student == null || _busy) ? null : _save, child: Text(t.save)),
      ],
    );
  }
}
