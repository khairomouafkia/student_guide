import 'package:flutter/material.dart';
import '../../../core/utils/error_text.dart';
import '../../../l10n/app_localizations.dart';

/// Returns true when a rating was submitted. [submit] throws on failure.
Future<bool> showRatingDialog(BuildContext context, Future<void> Function(int stars, String? comment) submit, {String? title}) async {
  final r = await showDialog<bool>(context: context, builder: (_) => _RatingDialog(submit: submit, title: title));
  return r ?? false;
}

class _RatingDialog extends StatefulWidget {
  const _RatingDialog({required this.submit, this.title});
  final Future<void> Function(int, String?) submit;
  final String? title;
  @override
  State<_RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<_RatingDialog> {
  int _stars = 0;
  final _c = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    setState(() { _busy = true; _error = null; });
    try {
      await widget.submit(_stars, _c.text);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) setState(() { _busy = false; _error = errorText(AppLocalizations.of(context)!, e); });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(widget.title ?? t.rateMeal),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          for (var i = 1; i <= 5; i++)
            IconButton(
              onPressed: () => setState(() => _stars = i),
              icon: Icon(i <= _stars ? Icons.star_rounded : Icons.star_outline_rounded, color: Colors.amber, size: 34),
            ),
        ]),
        TextField(controller: _c, maxLines: 3, maxLength: 500, decoration: InputDecoration(labelText: t.comment)),
        if (_error != null) Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
      ]),
      actions: [
        TextButton(onPressed: _busy ? null : () => Navigator.pop(context, false), child: Text(t.close)),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(96, 44)),
          onPressed: (_stars == 0 || _busy) ? null : _send,
          child: _busy ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)) : Text(t.send),
        ),
      ],
    );
  }
}
