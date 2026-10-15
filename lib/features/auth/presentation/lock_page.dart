import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';
import 'auth_controller.dart';

class LockPage extends ConsumerStatefulWidget {
  const LockPage({super.key});
  @override
  ConsumerState<LockPage> createState() => _LockPageState();
}

class _LockPageState extends ConsumerState<LockPage> {
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _unlock());   // prompt right away
  }

  Future<void> _unlock() async {
    if (_busy || !mounted) return;
    final reason = AppLocalizations.of(context)!.biometricReason;
    setState(() => _busy = true);
    await ref.read(authControllerProvider.notifier).unlock(reason);
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.lock_outline_rounded, size: 72, color: cs.primary),
              const SizedBox(height: 16),
              Text(t.appName, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 32),
              FilledButton.icon(icon: const Icon(Icons.fingerprint), label: Text(t.unlock), onPressed: _busy ? null : _unlock),
              const SizedBox(height: 12),
              TextButton(onPressed: () => ref.read(authControllerProvider.notifier).logout(), child: Text(t.usePassword)),
            ]),
          ),
        ),
      ),
    );
  }
}
