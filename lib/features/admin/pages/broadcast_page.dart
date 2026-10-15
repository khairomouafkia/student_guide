import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/error_text.dart';
import '../../../l10n/app_localizations.dart';
import '../data/admin_api.dart';

class BroadcastPage extends ConsumerStatefulWidget {
  const BroadcastPage({super.key});
  @override
  ConsumerState<BroadcastPage> createState() => _BroadcastPageState();
}

class _BroadcastPageState extends ConsumerState<BroadcastPage> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController(), _body = TextEditingController();
  String _audience = 'students';
  String? _residenceId;
  List<Json> _residences = [];
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    ref.read(adminApiProvider).list('/residences', {'pageSize': 100}).then((r) { if (mounted) setState(() => _residences = r.items); });
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_form.currentState!.validate()) return;
    final t = AppLocalizations.of(context)!;
    final m = ScaffoldMessenger.of(context);
    final yes = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.bSend),
        content: Text('${_title.text.trim()}\n\n${_body.text.trim()}'),
        actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: Text(t.cancelAction)), FilledButton(style: FilledButton.styleFrom(minimumSize: const Size(100, 44)), onPressed: () => Navigator.pop(context, true), child: Text(t.bSend))],
      ),
    );
    if (yes != true) return;
    setState(() => _busy = true);
    try {
      final d = await ref.read(adminApiProvider).post('/admin/notifications/broadcast', body: {
        'title': _title.text.trim(), 'body': _body.text.trim(), 'audience': _audience, if (_audience == 'residence') 'residenceId': _residenceId});
      m.showSnackBar(SnackBar(content: Text(t.bSent((d['recipients'] as num).toInt()))));
      _title.clear();
      _body.clear();
    } catch (e) {
      m.showSnackBar(SnackBar(content: Text(errorText(t, e))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Align(
        alignment: AlignmentDirectional.topStart,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Form(
            key: _form,
            child: ListView(children: [
              Text(t.mBroadcast, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _audience, decoration: InputDecoration(labelText: t.bAudience),
                items: [DropdownMenuItem(value: 'students', child: Text(t.bStudents)), DropdownMenuItem(value: 'admins', child: Text(t.bAdmins)), DropdownMenuItem(value: 'residence', child: Text(t.bResidence))],
                onChanged: (v) => setState(() => _audience = v ?? 'students'),
              ),
              if (_audience == 'residence') ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _residences.any((r) => r['id'] == _residenceId) ? _residenceId : null, isExpanded: true, decoration: InputDecoration(labelText: t.fResidence),
                  items: [for (final r in _residences) DropdownMenuItem(value: r['id'] as String, child: Text('${r['name']}'))],
                  validator: (v) => v == null ? t.requiredField : null, onChanged: (v) => setState(() => _residenceId = v),
                ),
              ],
              const SizedBox(height: 12),
              TextFormField(controller: _title, maxLength: 80, decoration: InputDecoration(labelText: t.bTitle), validator: (v) => (v ?? '').trim().length < 3 ? t.requiredField : null),
              TextFormField(controller: _body, maxLength: 300, maxLines: 4, decoration: InputDecoration(labelText: t.bBody), validator: (v) => (v ?? '').trim().length < 3 ? t.requiredField : null),
              const SizedBox(height: 16),
              FilledButton.icon(icon: const Icon(Icons.send), onPressed: _busy ? null : _send, label: Text(t.bSend)),
            ]),
          ),
        ),
      ),
    );
  }
}
