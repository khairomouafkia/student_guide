import '../../l10n/app_localizations.dart';
import '../network/api_exception.dart';

/// Maps backend errorCodes to localized, user-friendly messages.
String errorText(AppLocalizations t, Object e) {
  if (e is ApiException) {
    if (e.isNetwork) return t.networkError;
    switch (e.errorCode) {
      case 'DEADLINE_PASSED':
        return t.errDeadline;
      case 'FULL':
        return t.errFull;
      case 'ALREADY_RESERVED':
        return t.errAlready;
      case 'WRONG_RESIDENCE':
      case 'RESTAURANT_CLOSED':
      case 'UNAVAILABLE':
        return t.errUnavailable;
      case 'NOT_ELIGIBLE':
        return t.errNotEligible;
      case 'TOO_EARLY':
        return t.errTooEarly;
      case 'CLOSED':
        return t.errClosed;
      case 'TOO_MANY':
        return t.errTooMany;
      case 'LIMIT_REACHED':
        return t.errLimit;
      case 'AVAILABLE_NOW':
        return t.errAvailableNow;
      case 'FILE_TOO_LARGE':
        return t.errFileTooLarge;
      case 'INVALID_FILE_TYPE':
        return t.errFileType;
    }
  }
  return t.genericError;
}
