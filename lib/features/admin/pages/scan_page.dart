import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_exception.dart';
import '../../../l10n/app_localizations.dart';
import '../data/admin_api.dart';

/// Check-in desk: a USB / Bluetooth barcode reader types the code and presses Enter; pasting works too.
class ScanPage extends ConsumerStatefulWidget {
  const ScanPage({super.key, required this.meals, required this.activities});
  final bool meals, activities;
  @override
  ConsumerState<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends ConsumerState<ScanPage> {
  final _c = TextEditingController();
  final _focus = FocusNode();
  late bool _meal = widget.meals;
  bool _busy = false;
  ({bool ok, String text})? _last;

  @override
  void dispose() {
    _c.dispose();
    _focus.dispose();
    super.dispose();
  }

  String _err(AppLocalizations t, Object e) {
    if (e is ApiException) {
      switch (e.errorCode) {
        case 'INVALID_QR': return t.scErrInvalid;
        case 'ALREADY_USED': return t.scErrUsed;
        case 'WRONG_DAY': return t.scErrDay;
        case 'NOT_ACTIVE': return t.scErrInactive;
        case 'FORBIDDEN': return t.scErrInvalid;
      }
      if (e.isNetwork) return t.networkError;
    }
    return t.genericError;
  }

  Future<void> _submit(String code) async {
    final t = AppLocalizations.of(context)!;
    final token = code.trim();
    if (token.isEmpty || _busy) return;
    setState(() => _busy = true);
    try {
      final d = _meal
          ? await ref.read(adminApiProvider).post('/reservations/scan', body: {'qrToken': token})
          : await ref.read(adminApiProvider).post('/activities/attendance', body: {'qrToken': token});
      final name = '${d['studentName'] ?? ''}', item = '${_meal ? d['meal'] : d['activity']}';
      setState(() => _last = (ok: true, text: t.scOk(name, item)));
    } catch (e) {
      setState(() => _last = (ok: false, text: _err(t, e)));
    } finally {
      _c.clear();
      if (mounted) setState(() => _busy = false);
      _focus.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(t.mScan, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            if (widget.meals && widget.activities)
              SegmentedButton<bool>(
                segments: [ButtonSegment(value: true, label: Text(t.scMeal), icon: const Icon(Icons.restaurant)), ButtonSegment(value: false, label: Text(t.scActivity), icon: const Icon(Icons.emoji_events))],
                selected: {_meal}, onSelectionChanged: (s) => setState(() => _meal = s.first),
              ),
            const SizedBox(height: 16),
            TextField(
              controller: _c, focusNode: _focus, autofocus: true, enabled: !_busy, onSubmitted: _submit,
              decoration: InputDecoration(labelText: t.scQr, prefixIcon: const Icon(Icons.qr_code_scanner), helperText: t.scHint, suffixIcon: IconButton(icon: const Icon(Icons.check), tooltip: t.scCheckIn, onPressed: () => _submit(_c.text))),
            ),
            const SizedBox(height: 24),
            if (_busy) const LinearProgressIndicator(),
            if (_last != null)
              Card(
                color: (_last!.ok ? const Color(0xFF2E9D5B) : const Color(0xFFD64545)).withValues(alpha: 0.14),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(children: [
                    Icon(_last!.ok ? Icons.check_circle : Icons.error, size: 40, color: _last!.ok ? const Color(0xFF2E9D5B) : const Color(0xFFD64545)),
                    const SizedBox(width: 16),
                    Expanded(child: Text(_last!.ok ? '${t.scResult}\n${_last!.text}' : _last!.text, style: Theme.of(context).textTheme.titleMedium)),
                  ]),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}
