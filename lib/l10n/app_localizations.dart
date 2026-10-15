import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Student Guide'**
  String get appName;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @adminSignIn.
  ///
  /// In en, this message translates to:
  /// **'Administration sign in'**
  String get adminSignIn;

  /// No description provided for @universityEmail.
  ///
  /// In en, this message translates to:
  /// **'University email'**
  String get universityEmail;

  /// No description provided for @registrationNumber.
  ///
  /// In en, this message translates to:
  /// **'Registration number'**
  String get registrationNumber;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @welcomeUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}'**
  String welcomeUser(String name);

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @restaurant.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get restaurant;

  /// No description provided for @transport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get transport;

  /// No description provided for @activities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get activities;

  /// No description provided for @residence.
  ///
  /// In en, this message translates to:
  /// **'Residence'**
  String get residence;

  /// No description provided for @health.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get health;

  /// No description provided for @library.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get library;

  /// No description provided for @complaints.
  ///
  /// In en, this message translates to:
  /// **'Complaints'**
  String get complaints;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get genericError;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'No connection to the server.'**
  String get networkError;

  /// No description provided for @emptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get emptyTitle;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get invalidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get passwordTooShort;

  /// No description provided for @resetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'If the account exists, a reset email was sent'**
  String get resetEmailSent;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllRead;

  /// No description provided for @pendingComplaints.
  ///
  /// In en, this message translates to:
  /// **'Pending complaints'**
  String get pendingComplaints;

  /// No description provided for @libraryReservations.
  ///
  /// In en, this message translates to:
  /// **'Library reservations'**
  String get libraryReservations;

  /// No description provided for @mealReservation.
  ///
  /// In en, this message translates to:
  /// **'Next meal'**
  String get mealReservation;

  /// No description provided for @upcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'Upcoming events'**
  String get upcomingEvents;

  /// No description provided for @nextBus.
  ///
  /// In en, this message translates to:
  /// **'Next bus'**
  String get nextBus;

  /// No description provided for @noneYet.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get noneYet;

  /// No description provided for @university.
  ///
  /// In en, this message translates to:
  /// **'University'**
  String get university;

  /// No description provided for @faculty.
  ///
  /// In en, this message translates to:
  /// **'Faculty'**
  String get faculty;

  /// No description provided for @major.
  ///
  /// In en, this message translates to:
  /// **'Major'**
  String get major;

  /// No description provided for @studyYear.
  ///
  /// In en, this message translates to:
  /// **'Study year'**
  String get studyYear;

  /// No description provided for @residenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Residence'**
  String get residenceLabel;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @unreadNotifications.
  ///
  /// In en, this message translates to:
  /// **'Unread notifications'**
  String get unreadNotifications;

  /// No description provided for @offlineData.
  ///
  /// In en, this message translates to:
  /// **'Showing saved data'**
  String get offlineData;

  /// No description provided for @reserve.
  ///
  /// In en, this message translates to:
  /// **'Reserve'**
  String get reserve;

  /// No description provided for @cancelReservation.
  ///
  /// In en, this message translates to:
  /// **'Cancel reservation'**
  String get cancelReservation;

  /// No description provided for @cancelConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel this reservation?'**
  String get cancelConfirmTitle;

  /// No description provided for @cancelConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'You can only cancel until the reservation deadline.'**
  String get cancelConfirmBody;

  /// No description provided for @reserveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Meal reserved'**
  String get reserveSuccess;

  /// No description provided for @cancelSuccess.
  ///
  /// In en, this message translates to:
  /// **'Reservation cancelled'**
  String get cancelSuccess;

  /// No description provided for @deadlineLabel.
  ///
  /// In en, this message translates to:
  /// **'Reserve before {date}'**
  String deadlineLabel(String date);

  /// No description provided for @statusReserved.
  ///
  /// In en, this message translates to:
  /// **'Reserved'**
  String get statusReserved;

  /// No description provided for @statusFull.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get statusFull;

  /// No description provided for @statusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get statusClosed;

  /// No description provided for @statusDeadline.
  ///
  /// In en, this message translates to:
  /// **'Booking closed'**
  String get statusDeadline;

  /// No description provided for @statusUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get statusUnavailable;

  /// No description provided for @myReservations.
  ///
  /// In en, this message translates to:
  /// **'My reservations'**
  String get myReservations;

  /// No description provided for @showQr.
  ///
  /// In en, this message translates to:
  /// **'Show QR code'**
  String get showQr;

  /// No description provided for @qrHint.
  ///
  /// In en, this message translates to:
  /// **'Show this code at the restaurant'**
  String get qrHint;

  /// No description provided for @ingredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredients;

  /// No description provided for @allergens.
  ///
  /// In en, this message translates to:
  /// **'Allergens'**
  String get allergens;

  /// No description provided for @weeklyMenu.
  ///
  /// In en, this message translates to:
  /// **'Weekly menu'**
  String get weeklyMenu;

  /// No description provided for @rateMeal.
  ///
  /// In en, this message translates to:
  /// **'Rate this meal'**
  String get rateMeal;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment (optional)'**
  String get comment;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @thanksRating.
  ///
  /// In en, this message translates to:
  /// **'Thanks for your feedback'**
  String get thanksRating;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @attended.
  ///
  /// In en, this message translates to:
  /// **'Attended'**
  String get attended;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @errDeadline.
  ///
  /// In en, this message translates to:
  /// **'The deadline has passed.'**
  String get errDeadline;

  /// No description provided for @errFull.
  ///
  /// In en, this message translates to:
  /// **'Fully booked.'**
  String get errFull;

  /// No description provided for @errAlready.
  ///
  /// In en, this message translates to:
  /// **'You already have an active booking.'**
  String get errAlready;

  /// No description provided for @errUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Not available.'**
  String get errUnavailable;

  /// No description provided for @errNotEligible.
  ///
  /// In en, this message translates to:
  /// **'You can only rate services you used.'**
  String get errNotEligible;

  /// No description provided for @errTooEarly.
  ///
  /// In en, this message translates to:
  /// **'You can rate after it takes place.'**
  String get errTooEarly;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get loadMore;

  /// No description provided for @noMeals.
  ///
  /// In en, this message translates to:
  /// **'No meals scheduled'**
  String get noMeals;

  /// No description provided for @breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get breakfast;

  /// No description provided for @lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get lunch;

  /// No description provided for @dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get dinner;

  /// No description provided for @remainingPlaces.
  ///
  /// In en, this message translates to:
  /// **'{n} left'**
  String remainingPlaces(int n);

  /// No description provided for @transportLines.
  ///
  /// In en, this message translates to:
  /// **'Bus lines'**
  String get transportLines;

  /// No description provided for @liveBuses.
  ///
  /// In en, this message translates to:
  /// **'Live buses'**
  String get liveBuses;

  /// No description provided for @todaysDepartures.
  ///
  /// In en, this message translates to:
  /// **'Today\'s departures'**
  String get todaysDepartures;

  /// No description provided for @stops.
  ///
  /// In en, this message translates to:
  /// **'Stops'**
  String get stops;

  /// No description provided for @etaTitle.
  ///
  /// In en, this message translates to:
  /// **'Estimated arrival'**
  String get etaTitle;

  /// No description provided for @etaMinutes.
  ///
  /// In en, this message translates to:
  /// **'{n} min'**
  String etaMinutes(int n);

  /// No description provided for @etaApprox.
  ///
  /// In en, this message translates to:
  /// **'Approximate, based on the bus\'s current position.'**
  String get etaApprox;

  /// No description provided for @noBusLive.
  ///
  /// In en, this message translates to:
  /// **'No bus is reporting its position right now.'**
  String get noBusLive;

  /// No description provided for @lastUpdate.
  ///
  /// In en, this message translates to:
  /// **'Updated {ago} ago'**
  String lastUpdate(String ago);

  /// No description provided for @speedKmh.
  ///
  /// In en, this message translates to:
  /// **'{n} km/h'**
  String speedKmh(int n);

  /// No description provided for @plate.
  ///
  /// In en, this message translates to:
  /// **'Plate'**
  String get plate;

  /// No description provided for @statusStale.
  ///
  /// In en, this message translates to:
  /// **'Signal lost'**
  String get statusStale;

  /// No description provided for @rateService.
  ///
  /// In en, this message translates to:
  /// **'Rate this service'**
  String get rateService;

  /// No description provided for @noDepartures.
  ///
  /// In en, this message translates to:
  /// **'No departures today'**
  String get noDepartures;

  /// No description provided for @busesLive.
  ///
  /// In en, this message translates to:
  /// **'{n} live'**
  String busesLive(int n);

  /// No description provided for @noRoutes.
  ///
  /// In en, this message translates to:
  /// **'No bus lines yet'**
  String get noRoutes;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchHint;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @past.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// No description provided for @registerAction.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerAction;

  /// No description provided for @cancelRegistration.
  ///
  /// In en, this message translates to:
  /// **'Cancel registration'**
  String get cancelRegistration;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'You are registered'**
  String get registerSuccess;

  /// No description provided for @registrationCancelled.
  ///
  /// In en, this message translates to:
  /// **'Registration cancelled'**
  String get registrationCancelled;

  /// No description provided for @registerBefore.
  ///
  /// In en, this message translates to:
  /// **'Register before {date}'**
  String registerBefore(String date);

  /// No description provided for @statusRegistered.
  ///
  /// In en, this message translates to:
  /// **'Registered'**
  String get statusRegistered;

  /// No description provided for @statusRegClosed.
  ///
  /// In en, this message translates to:
  /// **'Registration closed'**
  String get statusRegClosed;

  /// No description provided for @noActivities.
  ///
  /// In en, this message translates to:
  /// **'No activities found'**
  String get noActivities;

  /// No description provided for @myActivities.
  ///
  /// In en, this message translates to:
  /// **'My activities'**
  String get myActivities;

  /// No description provided for @rateActivity.
  ///
  /// In en, this message translates to:
  /// **'Rate this activity'**
  String get rateActivity;

  /// No description provided for @locationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationLabel;

  /// No description provided for @typeCultural.
  ///
  /// In en, this message translates to:
  /// **'Cultural'**
  String get typeCultural;

  /// No description provided for @typeSports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get typeSports;

  /// No description provided for @typeWorkshop.
  ///
  /// In en, this message translates to:
  /// **'Workshop'**
  String get typeWorkshop;

  /// No description provided for @typeConference.
  ///
  /// In en, this message translates to:
  /// **'Conference'**
  String get typeConference;

  /// No description provided for @typeCompetition.
  ///
  /// In en, this message translates to:
  /// **'Competition'**
  String get typeCompetition;

  /// No description provided for @typeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get typeOther;

  /// No description provided for @searchBooks.
  ///
  /// In en, this message translates to:
  /// **'Search title, author or ISBN'**
  String get searchBooks;

  /// No description provided for @availableOnly.
  ///
  /// In en, this message translates to:
  /// **'Available only'**
  String get availableOnly;

  /// No description provided for @copiesAvailable.
  ///
  /// In en, this message translates to:
  /// **'{n} available'**
  String copiesAvailable(int n);

  /// No description provided for @outOfStock.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get outOfStock;

  /// No description provided for @reserveBook.
  ///
  /// In en, this message translates to:
  /// **'Reserve this book'**
  String get reserveBook;

  /// No description provided for @bookReserved.
  ///
  /// In en, this message translates to:
  /// **'Book reserved'**
  String get bookReserved;

  /// No description provided for @notifyMe.
  ///
  /// In en, this message translates to:
  /// **'Notify me when available'**
  String get notifyMe;

  /// No description provided for @notifyMeOn.
  ///
  /// In en, this message translates to:
  /// **'We will notify you'**
  String get notifyMeOn;

  /// No description provided for @notifyMeOff.
  ///
  /// In en, this message translates to:
  /// **'Notification removed'**
  String get notifyMeOff;

  /// No description provided for @myBooks.
  ///
  /// In en, this message translates to:
  /// **'My book reservations'**
  String get myBooks;

  /// No description provided for @author.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get author;

  /// No description provided for @isbn.
  ///
  /// In en, this message translates to:
  /// **'ISBN'**
  String get isbn;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @statusCollected.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get statusCollected;

  /// No description provided for @statusReturned.
  ///
  /// In en, this message translates to:
  /// **'Returned'**
  String get statusReturned;

  /// No description provided for @errLimit.
  ///
  /// In en, this message translates to:
  /// **'You reached the limit of 5 active books.'**
  String get errLimit;

  /// No description provided for @errAvailableNow.
  ///
  /// In en, this message translates to:
  /// **'The book is available now: you can reserve it.'**
  String get errAvailableNow;

  /// No description provided for @noBooks.
  ///
  /// In en, this message translates to:
  /// **'No books found'**
  String get noBooks;

  /// No description provided for @pickUpAt.
  ///
  /// In en, this message translates to:
  /// **'Pick up at the library'**
  String get pickUpAt;

  /// No description provided for @healthCenter.
  ///
  /// In en, this message translates to:
  /// **'Health center'**
  String get healthCenter;

  /// No description provided for @doctors.
  ///
  /// In en, this message translates to:
  /// **'Doctors'**
  String get doctors;

  /// No description provided for @medicalDocuments.
  ///
  /// In en, this message translates to:
  /// **'Medical documents'**
  String get medicalDocuments;

  /// No description provided for @uploadDocument.
  ///
  /// In en, this message translates to:
  /// **'Upload a document'**
  String get uploadDocument;

  /// No description provided for @docMedicalCertificate.
  ///
  /// In en, this message translates to:
  /// **'Medical certificate'**
  String get docMedicalCertificate;

  /// No description provided for @docSickLeave.
  ///
  /// In en, this message translates to:
  /// **'Sick leave'**
  String get docSickLeave;

  /// No description provided for @docPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get docPending;

  /// No description provided for @docUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Under review'**
  String get docUnderReview;

  /// No description provided for @docApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get docApproved;

  /// No description provided for @docRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get docRejected;

  /// No description provided for @docOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get docOverdue;

  /// No description provided for @reviewWithin72.
  ///
  /// In en, this message translates to:
  /// **'The document must be reviewed within 72 hours.'**
  String get reviewWithin72;

  /// No description provided for @hoursLeft.
  ///
  /// In en, this message translates to:
  /// **'{n} h left'**
  String hoursLeft(int n);

  /// No description provided for @rejectionReason.
  ///
  /// In en, this message translates to:
  /// **'Reason: {reason}'**
  String rejectionReason(String reason);

  /// No description provided for @reviewerComment.
  ///
  /// In en, this message translates to:
  /// **'Comment: {comment}'**
  String reviewerComment(String comment);

  /// No description provided for @chooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose a file (PDF, JPG, PNG, max 5 MB)'**
  String get chooseFile;

  /// No description provided for @uploadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Document uploaded'**
  String get uploadSuccess;

  /// No description provided for @noDocuments.
  ///
  /// In en, this message translates to:
  /// **'No documents yet'**
  String get noDocuments;

  /// No description provided for @openNow.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openNow;

  /// No description provided for @closedNow.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closedNow;

  /// No description provided for @noDoctors.
  ///
  /// In en, this message translates to:
  /// **'No doctors listed'**
  String get noDoctors;

  /// No description provided for @office.
  ///
  /// In en, this message translates to:
  /// **'Office'**
  String get office;

  /// No description provided for @sensitiveNote.
  ///
  /// In en, this message translates to:
  /// **'Medical documents are private: only you and the health center can see them.'**
  String get sensitiveNote;

  /// No description provided for @errFileTooLarge.
  ///
  /// In en, this message translates to:
  /// **'The file is larger than 5 MB.'**
  String get errFileTooLarge;

  /// No description provided for @errFileType.
  ///
  /// In en, this message translates to:
  /// **'Only PDF, JPG or PNG files are accepted.'**
  String get errFileType;

  /// No description provided for @selectType.
  ///
  /// In en, this message translates to:
  /// **'Document type'**
  String get selectType;

  /// No description provided for @openingHours.
  ///
  /// In en, this message translates to:
  /// **'Opening hours'**
  String get openingHours;

  /// No description provided for @noCenter.
  ///
  /// In en, this message translates to:
  /// **'Health center information is not available yet'**
  String get noCenter;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @myResidence.
  ///
  /// In en, this message translates to:
  /// **'My residence'**
  String get myResidence;

  /// No description provided for @roomLabel.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get roomLabel;

  /// No description provided for @buildingLabel.
  ///
  /// In en, this message translates to:
  /// **'Building'**
  String get buildingLabel;

  /// No description provided for @servicesLabel.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get servicesLabel;

  /// No description provided for @noResidence.
  ///
  /// In en, this message translates to:
  /// **'You have not been assigned to a residence yet'**
  String get noResidence;

  /// No description provided for @residenceMeals.
  ///
  /// In en, this message translates to:
  /// **'Residence meals'**
  String get residenceMeals;

  /// No description provided for @newComplaint.
  ///
  /// In en, this message translates to:
  /// **'New complaint'**
  String get newComplaint;

  /// No description provided for @complaintCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get complaintCategory;

  /// No description provided for @complaintSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get complaintSubject;

  /// No description provided for @complaintDescription.
  ///
  /// In en, this message translates to:
  /// **'Describe the problem'**
  String get complaintDescription;

  /// No description provided for @attachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachments;

  /// No description provided for @addAttachment.
  ///
  /// In en, this message translates to:
  /// **'Add a file (max 3)'**
  String get addAttachment;

  /// No description provided for @submitComplaint.
  ///
  /// In en, this message translates to:
  /// **'Submit complaint'**
  String get submitComplaint;

  /// No description provided for @complaintSent.
  ///
  /// In en, this message translates to:
  /// **'Your complaint was sent'**
  String get complaintSent;

  /// No description provided for @myComplaints.
  ///
  /// In en, this message translates to:
  /// **'My complaints'**
  String get myComplaints;

  /// No description provided for @noComplaints.
  ///
  /// In en, this message translates to:
  /// **'You have no complaints'**
  String get noComplaints;

  /// No description provided for @statusNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get statusNew;

  /// No description provided for @statusReceived.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get statusReceived;

  /// No description provided for @statusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get statusInProgress;

  /// No description provided for @statusResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get statusResolved;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// No description provided for @conversation.
  ///
  /// In en, this message translates to:
  /// **'Conversation'**
  String get conversation;

  /// No description provided for @writeReply.
  ///
  /// In en, this message translates to:
  /// **'Write a reply'**
  String get writeReply;

  /// No description provided for @reportProblem.
  ///
  /// In en, this message translates to:
  /// **'Report a problem'**
  String get reportProblem;

  /// No description provided for @complaintClosed.
  ///
  /// In en, this message translates to:
  /// **'This complaint is closed'**
  String get complaintClosed;

  /// No description provided for @staffLabel.
  ///
  /// In en, this message translates to:
  /// **'Administration'**
  String get staffLabel;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @fileCount.
  ///
  /// In en, this message translates to:
  /// **'{n} file(s)'**
  String fileCount(int n);

  /// No description provided for @openAttachment.
  ///
  /// In en, this message translates to:
  /// **'Open attachment'**
  String get openAttachment;

  /// No description provided for @errClosed.
  ///
  /// In en, this message translates to:
  /// **'This complaint is closed.'**
  String get errClosed;

  /// No description provided for @errTooMany.
  ///
  /// In en, this message translates to:
  /// **'You reached today\'s limit of complaints.'**
  String get errTooMany;

  /// No description provided for @complaintHelp.
  ///
  /// In en, this message translates to:
  /// **'Your complaint goes to the team in charge. A person always makes the final decision.'**
  String get complaintHelp;

  /// No description provided for @minChars.
  ///
  /// In en, this message translates to:
  /// **'At least {n} characters'**
  String minChars(int n);

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancelAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelAction;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @confirmDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this item?'**
  String get confirmDeleteTitle;

  /// No description provided for @confirmDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone from the app.'**
  String get confirmDeleteBody;

  /// No description provided for @savedOk.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get savedOk;

  /// No description provided for @deletedOk.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get deletedOk;

  /// No description provided for @pageInfo.
  ///
  /// In en, this message translates to:
  /// **'{from}-{to} of {total}'**
  String pageInfo(int from, int total, int to);

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @fName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fName;

  /// No description provided for @fDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get fDescription;

  /// No description provided for @fTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get fTitle;

  /// No description provided for @fDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get fDate;

  /// No description provided for @fTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get fTime;

  /// No description provided for @fStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get fStart;

  /// No description provided for @fEnd.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get fEnd;

  /// No description provided for @fCapacity.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get fCapacity;

  /// No description provided for @fImageUrl.
  ///
  /// In en, this message translates to:
  /// **'Image URL (https)'**
  String get fImageUrl;

  /// No description provided for @fAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get fAvailable;

  /// No description provided for @fPublished.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get fPublished;

  /// No description provided for @fIsOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get fIsOpen;

  /// No description provided for @fRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get fRestaurant;

  /// No description provided for @fRoute.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get fRoute;

  /// No description provided for @fDriver.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get fDriver;

  /// No description provided for @fPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get fPhone;

  /// No description provided for @fLicense.
  ///
  /// In en, this message translates to:
  /// **'License number'**
  String get fLicense;

  /// No description provided for @fLatitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get fLatitude;

  /// No description provided for @fLongitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get fLongitude;

  /// No description provided for @fOrder.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get fOrder;

  /// No description provided for @fDeparture.
  ///
  /// In en, this message translates to:
  /// **'Departure'**
  String get fDeparture;

  /// No description provided for @fDays.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get fDays;

  /// No description provided for @fDeadline.
  ///
  /// In en, this message translates to:
  /// **'Registration deadline'**
  String get fDeadline;

  /// No description provided for @fPath.
  ///
  /// In en, this message translates to:
  /// **'Path (JSON [[lat,lng],...])'**
  String get fPath;

  /// No description provided for @fSpecialty.
  ///
  /// In en, this message translates to:
  /// **'Specialty'**
  String get fSpecialty;

  /// No description provided for @fPhotoUrl.
  ///
  /// In en, this message translates to:
  /// **'Photo URL (https)'**
  String get fPhotoUrl;

  /// No description provided for @fCover.
  ///
  /// In en, this message translates to:
  /// **'Cover URL (https)'**
  String get fCover;

  /// No description provided for @fQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get fQuantity;

  /// No description provided for @fRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get fRole;

  /// No description provided for @fActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get fActive;

  /// No description provided for @fType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get fType;

  /// No description provided for @fStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get fStatus;

  /// No description provided for @fLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get fLanguage;

  /// No description provided for @fPassword.
  ///
  /// In en, this message translates to:
  /// **'Password (optional)'**
  String get fPassword;

  /// No description provided for @fPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Empty = an invitation e-mail is sent'**
  String get fPasswordHint;

  /// No description provided for @fResidence.
  ///
  /// In en, this message translates to:
  /// **'Residence'**
  String get fResidence;

  /// No description provided for @fBuilding.
  ///
  /// In en, this message translates to:
  /// **'Building'**
  String get fBuilding;

  /// No description provided for @fHealthCenter.
  ///
  /// In en, this message translates to:
  /// **'Health center'**
  String get fHealthCenter;

  /// No description provided for @fSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get fSchedule;

  /// No description provided for @fRoom.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get fRoom;

  /// No description provided for @fStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get fStudent;

  /// No description provided for @fBook.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get fBook;

  /// No description provided for @fCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get fCreated;

  /// No description provided for @fAddItem.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get fAddItem;

  /// No description provided for @dStudents.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get dStudents;

  /// No description provided for @dActiveAdmins.
  ///
  /// In en, this message translates to:
  /// **'Active admins'**
  String get dActiveAdmins;

  /// No description provided for @dRestaurants.
  ///
  /// In en, this message translates to:
  /// **'Restaurants'**
  String get dRestaurants;

  /// No description provided for @dBuses.
  ///
  /// In en, this message translates to:
  /// **'Buses'**
  String get dBuses;

  /// No description provided for @dActivities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get dActivities;

  /// No description provided for @dBooks.
  ///
  /// In en, this message translates to:
  /// **'Library books'**
  String get dBooks;

  /// No description provided for @dMedicalDocs.
  ///
  /// In en, this message translates to:
  /// **'Medical documents'**
  String get dMedicalDocs;

  /// No description provided for @dComplaints.
  ///
  /// In en, this message translates to:
  /// **'Complaints'**
  String get dComplaints;

  /// No description provided for @dPending.
  ///
  /// In en, this message translates to:
  /// **'Pending complaints'**
  String get dPending;

  /// No description provided for @dHighPriority.
  ///
  /// In en, this message translates to:
  /// **'High priority'**
  String get dHighPriority;

  /// No description provided for @dOverdueMedical.
  ///
  /// In en, this message translates to:
  /// **'Overdue medical reviews'**
  String get dOverdueMedical;

  /// No description provided for @dByStatus.
  ///
  /// In en, this message translates to:
  /// **'Complaints by status'**
  String get dByStatus;

  /// No description provided for @dByCategory.
  ///
  /// In en, this message translates to:
  /// **'Complaints by department'**
  String get dByCategory;

  /// No description provided for @dByPriority.
  ///
  /// In en, this message translates to:
  /// **'Complaints by priority'**
  String get dByPriority;

  /// No description provided for @dAvgResolution.
  ///
  /// In en, this message translates to:
  /// **'Average resolution time'**
  String get dAvgResolution;

  /// No description provided for @dHours.
  ///
  /// In en, this message translates to:
  /// **'{n} h'**
  String dHours(int n);

  /// No description provided for @dTopProblems.
  ///
  /// In en, this message translates to:
  /// **'Most frequent problems'**
  String get dTopProblems;

  /// No description provided for @dAvgRating.
  ///
  /// In en, this message translates to:
  /// **'Average service rating'**
  String get dAvgRating;

  /// No description provided for @dRecurring.
  ///
  /// In en, this message translates to:
  /// **'Recurring problems'**
  String get dRecurring;

  /// No description provided for @dLast30.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get dLast30;

  /// No description provided for @priLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get priLow;

  /// No description provided for @priMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get priMedium;

  /// No description provided for @priHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get priHigh;

  /// No description provided for @priCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get priCritical;

  /// No description provided for @mStudents.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get mStudents;

  /// No description provided for @mAdmins.
  ///
  /// In en, this message translates to:
  /// **'Administrators'**
  String get mAdmins;

  /// No description provided for @mMeals.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get mMeals;

  /// No description provided for @mReservations.
  ///
  /// In en, this message translates to:
  /// **'Reservations'**
  String get mReservations;

  /// No description provided for @mScan.
  ///
  /// In en, this message translates to:
  /// **'QR check-in'**
  String get mScan;

  /// No description provided for @mRatings.
  ///
  /// In en, this message translates to:
  /// **'Ratings'**
  String get mRatings;

  /// No description provided for @mRoutes.
  ///
  /// In en, this message translates to:
  /// **'Routes'**
  String get mRoutes;

  /// No description provided for @mStops.
  ///
  /// In en, this message translates to:
  /// **'Stops'**
  String get mStops;

  /// No description provided for @mSchedules.
  ///
  /// In en, this message translates to:
  /// **'Schedules'**
  String get mSchedules;

  /// No description provided for @mBuses.
  ///
  /// In en, this message translates to:
  /// **'Buses'**
  String get mBuses;

  /// No description provided for @mDrivers.
  ///
  /// In en, this message translates to:
  /// **'Drivers'**
  String get mDrivers;

  /// No description provided for @mBuildings.
  ///
  /// In en, this message translates to:
  /// **'Buildings'**
  String get mBuildings;

  /// No description provided for @mRooms.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get mRooms;

  /// No description provided for @mBooks.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get mBooks;

  /// No description provided for @mBookReservations.
  ///
  /// In en, this message translates to:
  /// **'Book reservations'**
  String get mBookReservations;

  /// No description provided for @mMedicalReview.
  ///
  /// In en, this message translates to:
  /// **'Medical documents'**
  String get mMedicalReview;

  /// No description provided for @mBroadcast.
  ///
  /// In en, this message translates to:
  /// **'Send notification'**
  String get mBroadcast;

  /// No description provided for @mAudit.
  ///
  /// In en, this message translates to:
  /// **'Audit logs'**
  String get mAudit;

  /// No description provided for @mHealthCheck.
  ///
  /// In en, this message translates to:
  /// **'System status'**
  String get mHealthCheck;

  /// No description provided for @mResidences.
  ///
  /// In en, this message translates to:
  /// **'Residences'**
  String get mResidences;

  /// No description provided for @mHealthCenter.
  ///
  /// In en, this message translates to:
  /// **'Health center'**
  String get mHealthCenter;

  /// No description provided for @mResidenceMeals.
  ///
  /// In en, this message translates to:
  /// **'Residence meals'**
  String get mResidenceMeals;

  /// No description provided for @mResidenceRestaurants.
  ///
  /// In en, this message translates to:
  /// **'Residence restaurants'**
  String get mResidenceRestaurants;

  /// No description provided for @mResidenceActivities.
  ///
  /// In en, this message translates to:
  /// **'Residence activities'**
  String get mResidenceActivities;

  /// No description provided for @gServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get gServices;

  /// No description provided for @gPeople.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get gPeople;

  /// No description provided for @gSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get gSystem;

  /// No description provided for @rSuper.
  ///
  /// In en, this message translates to:
  /// **'Super admin'**
  String get rSuper;

  /// No description provided for @rRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Restaurant admin'**
  String get rRestaurant;

  /// No description provided for @rTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport admin'**
  String get rTransport;

  /// No description provided for @rActivities.
  ///
  /// In en, this message translates to:
  /// **'Activities admin'**
  String get rActivities;

  /// No description provided for @rResidence.
  ///
  /// In en, this message translates to:
  /// **'Residence admin'**
  String get rResidence;

  /// No description provided for @rHealth.
  ///
  /// In en, this message translates to:
  /// **'Health admin'**
  String get rHealth;

  /// No description provided for @rLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library admin'**
  String get rLibrary;

  /// No description provided for @rComplaints.
  ///
  /// In en, this message translates to:
  /// **'Complaints admin'**
  String get rComplaints;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Send password reset'**
  String get resetPassword;

  /// No description provided for @resetSent.
  ///
  /// In en, this message translates to:
  /// **'Reset e-mail sent'**
  String get resetSent;

  /// No description provided for @disable.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get disable;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// No description provided for @importCsv.
  ///
  /// In en, this message translates to:
  /// **'Import CSV'**
  String get importCsv;

  /// No description provided for @importHint.
  ///
  /// In en, this message translates to:
  /// **'Columns: email, fullName, registrationNumber, faculty, major, studyYear'**
  String get importHint;

  /// No description provided for @importResult.
  ///
  /// In en, this message translates to:
  /// **'{created} created, {failed} failed'**
  String importResult(int created, int failed);

  /// No description provided for @sendInvites.
  ///
  /// In en, this message translates to:
  /// **'Send invitation e-mails'**
  String get sendInvites;

  /// No description provided for @chooseCsv.
  ///
  /// In en, this message translates to:
  /// **'Choose a CSV file'**
  String get chooseCsv;

  /// No description provided for @rowsReady.
  ///
  /// In en, this message translates to:
  /// **'{n} rows ready'**
  String rowsReady(int n);

  /// No description provided for @startImport.
  ///
  /// In en, this message translates to:
  /// **'Start import'**
  String get startImport;

  /// No description provided for @rowLabel.
  ///
  /// In en, this message translates to:
  /// **'Row {n}'**
  String rowLabel(int n);

  /// No description provided for @aAction.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get aAction;

  /// No description provided for @aModule.
  ///
  /// In en, this message translates to:
  /// **'Module'**
  String get aModule;

  /// No description provided for @aAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get aAdmin;

  /// No description provided for @aResource.
  ///
  /// In en, this message translates to:
  /// **'Resource'**
  String get aResource;

  /// No description provided for @hcUp.
  ///
  /// In en, this message translates to:
  /// **'Operational'**
  String get hcUp;

  /// No description provided for @hcDown.
  ///
  /// In en, this message translates to:
  /// **'Down'**
  String get hcDown;

  /// No description provided for @hcDatabase.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get hcDatabase;

  /// No description provided for @hcStorage.
  ///
  /// In en, this message translates to:
  /// **'File storage'**
  String get hcStorage;

  /// No description provided for @hcAuth.
  ///
  /// In en, this message translates to:
  /// **'Authentication'**
  String get hcAuth;

  /// No description provided for @hcPush.
  ///
  /// In en, this message translates to:
  /// **'Push notifications'**
  String get hcPush;

  /// No description provided for @hcAi.
  ///
  /// In en, this message translates to:
  /// **'Smart complaints (AI)'**
  String get hcAi;

  /// No description provided for @hcJobs.
  ///
  /// In en, this message translates to:
  /// **'Background jobs'**
  String get hcJobs;

  /// No description provided for @hcConfigured.
  ///
  /// In en, this message translates to:
  /// **'Configured'**
  String get hcConfigured;

  /// No description provided for @hcNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Not configured'**
  String get hcNotConfigured;

  /// No description provided for @hcLatency.
  ///
  /// In en, this message translates to:
  /// **'{n} ms'**
  String hcLatency(int n);

  /// No description provided for @bAudience.
  ///
  /// In en, this message translates to:
  /// **'Audience'**
  String get bAudience;

  /// No description provided for @bStudents.
  ///
  /// In en, this message translates to:
  /// **'All students'**
  String get bStudents;

  /// No description provided for @bAdmins.
  ///
  /// In en, this message translates to:
  /// **'All administrators'**
  String get bAdmins;

  /// No description provided for @bResidence.
  ///
  /// In en, this message translates to:
  /// **'One residence'**
  String get bResidence;

  /// No description provided for @bTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get bTitle;

  /// No description provided for @bBody.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get bBody;

  /// No description provided for @bSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get bSend;

  /// No description provided for @bSent.
  ///
  /// In en, this message translates to:
  /// **'Sent to {n} people'**
  String bSent(int n);

  /// No description provided for @ciPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get ciPriority;

  /// No description provided for @ciAssignToMe.
  ///
  /// In en, this message translates to:
  /// **'Assign to me'**
  String get ciAssignToMe;

  /// No description provided for @ciUnassign.
  ///
  /// In en, this message translates to:
  /// **'Unassign'**
  String get ciUnassign;

  /// No description provided for @ciAssigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get ciAssigned;

  /// No description provided for @ciInternal.
  ///
  /// In en, this message translates to:
  /// **'Internal note (not visible to the student)'**
  String get ciInternal;

  /// No description provided for @ciSendReply.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get ciSendReply;

  /// No description provided for @ciAiSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Smart analysis (suggestion only)'**
  String get ciAiSuggestion;

  /// No description provided for @ciSuggestedDept.
  ///
  /// In en, this message translates to:
  /// **'Suggested department'**
  String get ciSuggestedDept;

  /// No description provided for @ciTopic.
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get ciTopic;

  /// No description provided for @ciRecurring.
  ///
  /// In en, this message translates to:
  /// **'Recurring problem'**
  String get ciRecurring;

  /// No description provided for @ciSimilar.
  ///
  /// In en, this message translates to:
  /// **'Similar complaints'**
  String get ciSimilar;

  /// No description provided for @ciSimilarNone.
  ///
  /// In en, this message translates to:
  /// **'None found'**
  String get ciSimilarNone;

  /// No description provided for @ciDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Possible duplicate'**
  String get ciDuplicate;

  /// No description provided for @ciStatus.
  ///
  /// In en, this message translates to:
  /// **'Change status'**
  String get ciStatus;

  /// No description provided for @ciStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get ciStudent;

  /// No description provided for @ciOnlyRecurring.
  ///
  /// In en, this message translates to:
  /// **'Recurring only'**
  String get ciOnlyRecurring;

  /// No description provided for @ciSortPriority.
  ///
  /// In en, this message translates to:
  /// **'By priority'**
  String get ciSortPriority;

  /// No description provided for @ciSortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get ciSortNewest;

  /// No description provided for @ciSortOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest'**
  String get ciSortOldest;

  /// No description provided for @ciLocked.
  ///
  /// In en, this message translates to:
  /// **'Set by an admin: the AI will not change it'**
  String get ciLocked;

  /// No description provided for @ciSource.
  ///
  /// In en, this message translates to:
  /// **'Analysis: {src}'**
  String ciSource(String src);

  /// No description provided for @ciAllAssign.
  ///
  /// In en, this message translates to:
  /// **'Everyone'**
  String get ciAllAssign;

  /// No description provided for @ciUnassigned.
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get ciUnassigned;

  /// No description provided for @ciMine.
  ///
  /// In en, this message translates to:
  /// **'Assigned to me'**
  String get ciMine;

  /// No description provided for @mdOpenFile.
  ///
  /// In en, this message translates to:
  /// **'Open document'**
  String get mdOpenFile;

  /// No description provided for @mdStartReview.
  ///
  /// In en, this message translates to:
  /// **'Start review'**
  String get mdStartReview;

  /// No description provided for @mdApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get mdApprove;

  /// No description provided for @mdReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get mdReject;

  /// No description provided for @mdReason.
  ///
  /// In en, this message translates to:
  /// **'Rejection reason (required)'**
  String get mdReason;

  /// No description provided for @mdComment.
  ///
  /// In en, this message translates to:
  /// **'Comment (optional)'**
  String get mdComment;

  /// No description provided for @mdEscalate.
  ///
  /// In en, this message translates to:
  /// **'Escalate to super admin'**
  String get mdEscalate;

  /// No description provided for @mdEscalated.
  ///
  /// In en, this message translates to:
  /// **'Escalated'**
  String get mdEscalated;

  /// No description provided for @mdOverdueOnly.
  ///
  /// In en, this message translates to:
  /// **'Overdue only'**
  String get mdOverdueOnly;

  /// No description provided for @mdDeadline.
  ///
  /// In en, this message translates to:
  /// **'Review deadline'**
  String get mdDeadline;

  /// No description provided for @mdDone.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get mdDone;

  /// No description provided for @mdSensitive.
  ///
  /// In en, this message translates to:
  /// **'Sensitive medical data. Every access is recorded in the audit log.'**
  String get mdSensitive;

  /// No description provided for @scQr.
  ///
  /// In en, this message translates to:
  /// **'QR code'**
  String get scQr;

  /// No description provided for @scCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Check in'**
  String get scCheckIn;

  /// No description provided for @scMeal.
  ///
  /// In en, this message translates to:
  /// **'Meal'**
  String get scMeal;

  /// No description provided for @scActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get scActivity;

  /// No description provided for @scOk.
  ///
  /// In en, this message translates to:
  /// **'{name} · {item}'**
  String scOk(String name, String item);

  /// No description provided for @scHint.
  ///
  /// In en, this message translates to:
  /// **'Scan with a barcode reader or paste the code, then press Enter.'**
  String get scHint;

  /// No description provided for @scErrInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid QR code'**
  String get scErrInvalid;

  /// No description provided for @scErrUsed.
  ///
  /// In en, this message translates to:
  /// **'Already used'**
  String get scErrUsed;

  /// No description provided for @scErrDay.
  ///
  /// In en, this message translates to:
  /// **'This code is for another day'**
  String get scErrDay;

  /// No description provided for @scErrInactive.
  ///
  /// In en, this message translates to:
  /// **'Reservation is not active'**
  String get scErrInactive;

  /// No description provided for @rtAverage.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get rtAverage;

  /// No description provided for @rtCount.
  ///
  /// In en, this message translates to:
  /// **'{n} ratings'**
  String rtCount(int n);

  /// No description provided for @acRegistrations.
  ///
  /// In en, this message translates to:
  /// **'Registrations'**
  String get acRegistrations;

  /// No description provided for @acPublish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get acPublish;

  /// No description provided for @acUnpublish.
  ///
  /// In en, this message translates to:
  /// **'Unpublish'**
  String get acUnpublish;

  /// No description provided for @bkCollect.
  ///
  /// In en, this message translates to:
  /// **'Mark as collected'**
  String get bkCollect;

  /// No description provided for @bkReturn.
  ///
  /// In en, this message translates to:
  /// **'Mark as returned'**
  String get bkReturn;

  /// No description provided for @bkRelease.
  ///
  /// In en, this message translates to:
  /// **'Cancel reservation'**
  String get bkRelease;

  /// No description provided for @adminOnlyWeb.
  ///
  /// In en, this message translates to:
  /// **'Administration'**
  String get adminOnlyWeb;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @mDashboardReports.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get mDashboardReports;

  /// No description provided for @scResult.
  ///
  /// In en, this message translates to:
  /// **'Checked in'**
  String get scResult;

  /// No description provided for @ratingsFor.
  ///
  /// In en, this message translates to:
  /// **'Ratings for'**
  String get ratingsFor;

  /// No description provided for @noRatings.
  ///
  /// In en, this message translates to:
  /// **'No ratings yet'**
  String get noRatings;

  /// No description provided for @followRoute.
  ///
  /// In en, this message translates to:
  /// **'Follow this line'**
  String get followRoute;

  /// No description provided for @unfollowRoute.
  ///
  /// In en, this message translates to:
  /// **'Stop following'**
  String get unfollowRoute;

  /// No description provided for @followHint.
  ///
  /// In en, this message translates to:
  /// **'Follow a line in Transport to see its next bus here'**
  String get followHint;

  /// No description provided for @followingNow.
  ///
  /// In en, this message translates to:
  /// **'You follow this line'**
  String get followingNow;

  /// No description provided for @followStopped.
  ///
  /// In en, this message translates to:
  /// **'You no longer follow this line'**
  String get followStopped;

  /// No description provided for @nextBusNoSchedule.
  ///
  /// In en, this message translates to:
  /// **'No schedule for this line'**
  String get nextBusNoSchedule;

  /// No description provided for @departsInMin.
  ///
  /// In en, this message translates to:
  /// **'{time} (in {n} min)'**
  String departsInMin(String time, int n);

  /// No description provided for @departsDays.
  ///
  /// In en, this message translates to:
  /// **'{time} (+{n} d)'**
  String departsDays(String time, int n);

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get changePhoto;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhoto;

  /// No description provided for @fromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get fromGallery;

  /// No description provided for @fromCamera.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get fromCamera;

  /// No description provided for @photoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Photo updated'**
  String get photoUpdated;

  /// No description provided for @offlineActionsOff.
  ///
  /// In en, this message translates to:
  /// **'Offline: reservations are disabled until you reconnect'**
  String get offlineActionsOff;

  /// No description provided for @biometricUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock with biometrics'**
  String get biometricUnlock;

  /// No description provided for @biometricReason.
  ///
  /// In en, this message translates to:
  /// **'Unlock Student Guide'**
  String get biometricReason;

  /// No description provided for @unlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// No description provided for @biometricUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Biometrics are not available on this device'**
  String get biometricUnavailable;

  /// No description provided for @usePassword.
  ///
  /// In en, this message translates to:
  /// **'Use password instead'**
  String get usePassword;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
