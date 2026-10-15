import '../../l10n/app_localizations.dart';

class Validators {
  static String? Function(String?) required(AppLocalizations t) =>
      (v) => (v == null || v.trim().isEmpty) ? t.requiredField : null;

  static String? Function(String?) email(AppLocalizations t) => (v) {
        if (v == null || v.trim().isEmpty) return t.requiredField;
        return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim()) ? null : t.invalidEmail;
      };

  static String? Function(String?) password(AppLocalizations t) => (v) {
        if (v == null || v.isEmpty) return t.requiredField;
        return v.length < 8 ? t.passwordTooShort : null;
      };
}
