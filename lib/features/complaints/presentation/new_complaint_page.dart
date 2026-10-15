import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/error_text.dart';
import '../../../core/utils/validators.dart';
import '../../../l10n/app_localizations.dart';
import '../data/complaint_repository.dart';
import 'complaint_providers.dart';
import 'status_chip.dart';

/// Opened from the Complaints center, or pre-filled from a meal / bus line ("Report a problem").
class NewComplaintPage extends ConsumerStatefulWidget {
  const NewComplaintPage({super.key, this.category, this.relatedResourceId, this.subjectHint});
  final String? category, relatedResourceId, subjectHint;
  @override
  ConsumerState<NewComplaintPage> createState() => _NewComplaintPageState();
}

class _NewComplaintPageState extends ConsumerState<NewComplaintPage> {
  final _form = GlobalKey<FormState>();
  late final _subject = TextEditingController(text: widget.subjectHint ?? '');
  final _desc = TextEditingController();
  late String _category = widget.category ?? 'restaurant';
  final _files = <PlatformFile>[];
  bool _busy = false;

  @override
  void dispose() {
    _subject.dispose();
    _desc.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    final r = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'], withData: true, allowMultiple: true);
    if (r == null) return;
    setState(() {
      for (final f in r.files) {
        if (_files.length < 3 && f.bytes != null && f.size <= 5 * 1024 * 1024) _files.add(f);
      }
    });
  }

  Future<void> _submit() async {
    final t = AppLocalizations.of(context)!;
    if (!_form.currentState!.validate()) return;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      await ref.read(complaintRepositoryProvider).create(
            category: _category, subject: _subject.text.trim(), description: _desc.text.trim(),
            relatedResourceId: widget.relatedResourceId,
            files: [for (final f in _files) (bytes: f.bytes!, name: f.name)],
          );
      refreshComplaints(ref);
      if (mounted) Navigator.pop(context);
      messenger.showSnackBar(SnackBar(content: Text(t.complaintSent)));
    } catch (e) {
      if (mounted) setState(() => _busy = false);
      messenger.showSnackBar(SnackBar(content: Text(errorText(t, e))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final locked = widget.category != null; // coming from a meal / bus line: the category is known
    String? minLen(String? v, int n) => (v == null || v.trim().length < n) ? t.minChars(n) : null;

    return Scaffold(
      appBar: AppBar(title: Text(t.newComplaint)),
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.all(16), children: [
          Form(
            key: _form,
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              DropdownButtonFormField<String>(
                value: _category,
                decoration: InputDecoration(labelText: t.complaintCategory),
                items: [for (final c in complaintCategories) DropdownMenuItem(value: c, child: Text(complaintCategoryLabel(t, c)))],
                onChanged: locked ? null : (v) => setState(() => _category = v ?? _category),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _subject,
                maxLength: 150,
                decoration: InputDecoration(labelText: t.complaintSubject),
                validator: (v) => Validators.required(t)(v) ?? minLen(v, 3),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _desc,
                maxLines: 6,
                maxLength: 3000,
                decoration: InputDecoration(labelText: t.complaintDescription, alignLabelWithHint: true),
                validator: (v) => Validators.required(t)(v) ?? minLen(v, 10),
              ),
              const SizedBox(height: 8),
              Text(t.attachments, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8, children: [
                for (final f in _files)
                  InputChip(
                    avatar: Icon(f.extension == 'pdf' ? Icons.picture_as_pdf : Icons.image_outlined, size: 18),
                    label: SizedBox(width: 120, child: Text(f.name, overflow: TextOverflow.ellipsis)),
                    onDeleted: () => setState(() => _files.remove(f)),
                  ),
                if (_files.length < 3) ActionChip(avatar: const Icon(Icons.attach_file, size: 18), label: Text(t.addAttachment), onPressed: _busy ? null : _pick),
              ]),
              const SizedBox(height: 16),
              Text(t.complaintHelp, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _busy ? null : _submit,
                child: _busy ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2.5)) : Text(t.submitComplaint),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
