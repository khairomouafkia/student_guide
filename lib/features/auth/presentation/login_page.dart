import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/utils/validators.dart';
import '../../../l10n/app_localizations.dart';
import 'auth_controller.dart';

/// Students: email + registration number + password. Admin (web): email + password.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key, this.adminMode = false});
  final bool adminMode;
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _reg = TextEditingController();
  final _pw = TextEditingController();
  bool _hide = true;

  @override
  void dispose() {
    _email.dispose();
    _reg.dispose();
    _pw.dispose();
    super.dispose();
  }

  String _errorText(AppLocalizations t, ApiException e) =>
      e.isNetwork ? t.networkError : (e.statusCode == 401 || e.statusCode == 422 ? e.message : t.genericError);

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    final c = ref.read(authControllerProvider.notifier);
    final ok = widget.adminMode
        ? await c.loginAdmin(_email.text.trim(), _pw.text)
        : await c.loginStudent(_email.text.trim(), _reg.text.trim(), _pw.text);
    if (!ok && mounted) {
      final err = ref.read(authControllerProvider).error;
      if (err != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(_errorText(AppLocalizations.of(context)!, err))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final loading = ref.watch(authControllerProvider.select((s) => s.loading));
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _form,
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Icon(Icons.school_rounded, size: 72, color: cs.primary),
                  const SizedBox(height: 12),
                  Text(t.appName,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700)),
                  if (widget.adminMode)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(t.adminSignIn, textAlign: TextAlign.center, style: TextStyle(color: cs.outline)),
                    ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    decoration: InputDecoration(labelText: t.universityEmail, prefixIcon: const Icon(Icons.email_outlined)),
                    validator: Validators.email(t),
                  ),
                  if (!widget.adminMode) ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _reg,
                      decoration: InputDecoration(labelText: t.registrationNumber, prefixIcon: const Icon(Icons.badge_outlined)),
                      validator: Validators.required(t),
                    ),
                  ],
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _pw,
                    obscureText: _hide,
                    autofillHints: const [AutofillHints.password],
                    decoration: InputDecoration(
                      labelText: t.password,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_hide ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                        onPressed: () => setState(() => _hide = !_hide),
                      ),
                    ),
                    validator: Validators.password(t),
                    onFieldSubmitted: (_) => _submit(),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton(
                      onPressed: () async {
                        final email = _email.text.trim();
                        if (Validators.email(t)(email) != null) {
                          _form.currentState!.validate();
                          return;
                        }
                        await ref.read(authRepositoryProvider).forgotPassword(email).catchError((_) {});
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.resetEmailSent)));
                        }
                      },
                      child: Text(t.forgotPassword),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: loading ? null : _submit,
                    child: loading
                        ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
                        : Text(t.signIn),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
