// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Student Guide';

  @override
  String get signIn => 'Sign in';

  @override
  String get adminSignIn => 'Administration sign in';

  @override
  String get universityEmail => 'University email';

  @override
  String get registrationNumber => 'Registration number';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get logout => 'Log out';

  @override
  String welcomeUser(String name) {
    return 'Welcome, $name';
  }

  @override
  String get services => 'Services';

  @override
  String get restaurant => 'Restaurant';

  @override
  String get transport => 'Transport';

  @override
  String get activities => 'Activities';

  @override
  String get residence => 'Residence';

  @override
  String get health => 'Health';

  @override
  String get library => 'Library';

  @override
  String get complaints => 'Complaints';

  @override
  String get notifications => 'Notifications';

  @override
  String get profile => 'Profile';

  @override
  String get home => 'Home';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get settings => 'Settings';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get language => 'Language';

  @override
  String get retry => 'Retry';

  @override
  String get genericError => 'Something went wrong. Please try again.';

  @override
  String get networkError => 'No connection to the server.';

  @override
  String get emptyTitle => 'Nothing here yet';

  @override
  String get requiredField => 'This field is required';

  @override
  String get invalidEmail => 'Enter a valid email';

  @override
  String get passwordTooShort => 'At least 8 characters';

  @override
  String get resetEmailSent => 'If the account exists, a reset email was sent';

  @override
  String get markAllRead => 'Mark all as read';

  @override
  String get pendingComplaints => 'Pending complaints';

  @override
  String get libraryReservations => 'Library reservations';

  @override
  String get mealReservation => 'Next meal';

  @override
  String get upcomingEvents => 'Upcoming events';

  @override
  String get nextBus => 'Next bus';

  @override
  String get noneYet => 'None';

  @override
  String get university => 'University';

  @override
  String get faculty => 'Faculty';

  @override
  String get major => 'Major';

  @override
  String get studyYear => 'Study year';

  @override
  String get residenceLabel => 'Residence';

  @override
  String get fullName => 'Full name';

  @override
  String get unreadNotifications => 'Unread notifications';

  @override
  String get offlineData => 'Showing saved data';

  @override
  String get reserve => 'Reserve';

  @override
  String get cancelReservation => 'Cancel reservation';

  @override
  String get cancelConfirmTitle => 'Cancel this reservation?';

  @override
  String get cancelConfirmBody =>
      'You can only cancel until the reservation deadline.';

  @override
  String get reserveSuccess => 'Meal reserved';

  @override
  String get cancelSuccess => 'Reservation cancelled';

  @override
  String deadlineLabel(String date) {
    return 'Reserve before $date';
  }

  @override
  String get statusReserved => 'Reserved';

  @override
  String get statusFull => 'Full';

  @override
  String get statusClosed => 'Closed';

  @override
  String get statusDeadline => 'Booking closed';

  @override
  String get statusUnavailable => 'Unavailable';

  @override
  String get myReservations => 'My reservations';

  @override
  String get showQr => 'Show QR code';

  @override
  String get qrHint => 'Show this code at the restaurant';

  @override
  String get ingredients => 'Ingredients';

  @override
  String get allergens => 'Allergens';

  @override
  String get weeklyMenu => 'Weekly menu';

  @override
  String get rateMeal => 'Rate this meal';

  @override
  String get comment => 'Comment (optional)';

  @override
  String get send => 'Send';

  @override
  String get thanksRating => 'Thanks for your feedback';

  @override
  String get close => 'Close';

  @override
  String get no => 'No';

  @override
  String get yes => 'Yes';

  @override
  String get attended => 'Attended';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get errDeadline => 'The deadline has passed.';

  @override
  String get errFull => 'Fully booked.';

  @override
  String get errAlready => 'You already have an active booking.';

  @override
  String get errUnavailable => 'Not available.';

  @override
  String get errNotEligible => 'You can only rate services you used.';

  @override
  String get errTooEarly => 'You can rate after it takes place.';

  @override
  String get loadMore => 'Load more';

  @override
  String get noMeals => 'No meals scheduled';

  @override
  String get breakfast => 'Breakfast';

  @override
  String get lunch => 'Lunch';

  @override
  String get dinner => 'Dinner';

  @override
  String remainingPlaces(int n) {
    return '$n left';
  }

  @override
  String get transportLines => 'Bus lines';

  @override
  String get liveBuses => 'Live buses';

  @override
  String get todaysDepartures => 'Today\'s departures';

  @override
  String get stops => 'Stops';

  @override
  String get etaTitle => 'Estimated arrival';

  @override
  String etaMinutes(int n) {
    return '$n min';
  }

  @override
  String get etaApprox => 'Approximate, based on the bus\'s current position.';

  @override
  String get noBusLive => 'No bus is reporting its position right now.';

  @override
  String lastUpdate(String ago) {
    return 'Updated $ago ago';
  }

  @override
  String speedKmh(int n) {
    return '$n km/h';
  }

  @override
  String get plate => 'Plate';

  @override
  String get statusStale => 'Signal lost';

  @override
  String get rateService => 'Rate this service';

  @override
  String get noDepartures => 'No departures today';

  @override
  String busesLive(int n) {
    return '$n live';
  }

  @override
  String get noRoutes => 'No bus lines yet';

  @override
  String get searchHint => 'Search';

  @override
  String get filterAll => 'All';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get past => 'Past';

  @override
  String get registerAction => 'Register';

  @override
  String get cancelRegistration => 'Cancel registration';

  @override
  String get registerSuccess => 'You are registered';

  @override
  String get registrationCancelled => 'Registration cancelled';

  @override
  String registerBefore(String date) {
    return 'Register before $date';
  }

  @override
  String get statusRegistered => 'Registered';

  @override
  String get statusRegClosed => 'Registration closed';

  @override
  String get noActivities => 'No activities found';

  @override
  String get myActivities => 'My activities';

  @override
  String get rateActivity => 'Rate this activity';

  @override
  String get locationLabel => 'Location';

  @override
  String get typeCultural => 'Cultural';

  @override
  String get typeSports => 'Sports';

  @override
  String get typeWorkshop => 'Workshop';

  @override
  String get typeConference => 'Conference';

  @override
  String get typeCompetition => 'Competition';

  @override
  String get typeOther => 'Other';

  @override
  String get searchBooks => 'Search title, author or ISBN';

  @override
  String get availableOnly => 'Available only';

  @override
  String copiesAvailable(int n) {
    return '$n available';
  }

  @override
  String get outOfStock => 'Unavailable';

  @override
  String get reserveBook => 'Reserve this book';

  @override
  String get bookReserved => 'Book reserved';

  @override
  String get notifyMe => 'Notify me when available';

  @override
  String get notifyMeOn => 'We will notify you';

  @override
  String get notifyMeOff => 'Notification removed';

  @override
  String get myBooks => 'My book reservations';

  @override
  String get author => 'Author';

  @override
  String get isbn => 'ISBN';

  @override
  String get category => 'Category';

  @override
  String get statusCollected => 'Collected';

  @override
  String get statusReturned => 'Returned';

  @override
  String get errLimit => 'You reached the limit of 5 active books.';

  @override
  String get errAvailableNow =>
      'The book is available now: you can reserve it.';

  @override
  String get noBooks => 'No books found';

  @override
  String get pickUpAt => 'Pick up at the library';

  @override
  String get healthCenter => 'Health center';

  @override
  String get doctors => 'Doctors';

  @override
  String get medicalDocuments => 'Medical documents';

  @override
  String get uploadDocument => 'Upload a document';

  @override
  String get docMedicalCertificate => 'Medical certificate';

  @override
  String get docSickLeave => 'Sick leave';

  @override
  String get docPending => 'Pending';

  @override
  String get docUnderReview => 'Under review';

  @override
  String get docApproved => 'Approved';

  @override
  String get docRejected => 'Rejected';

  @override
  String get docOverdue => 'Overdue';

  @override
  String get reviewWithin72 => 'The document must be reviewed within 72 hours.';

  @override
  String hoursLeft(int n) {
    return '$n h left';
  }

  @override
  String rejectionReason(String reason) {
    return 'Reason: $reason';
  }

  @override
  String reviewerComment(String comment) {
    return 'Comment: $comment';
  }

  @override
  String get chooseFile => 'Choose a file (PDF, JPG, PNG, max 5 MB)';

  @override
  String get uploadSuccess => 'Document uploaded';

  @override
  String get noDocuments => 'No documents yet';

  @override
  String get openNow => 'Open';

  @override
  String get closedNow => 'Closed';

  @override
  String get noDoctors => 'No doctors listed';

  @override
  String get office => 'Office';

  @override
  String get sensitiveNote =>
      'Medical documents are private: only you and the health center can see them.';

  @override
  String get errFileTooLarge => 'The file is larger than 5 MB.';

  @override
  String get errFileType => 'Only PDF, JPG or PNG files are accepted.';

  @override
  String get selectType => 'Document type';

  @override
  String get openingHours => 'Opening hours';

  @override
  String get noCenter => 'Health center information is not available yet';

  @override
  String get upload => 'Upload';

  @override
  String get myResidence => 'My residence';

  @override
  String get roomLabel => 'Room';

  @override
  String get buildingLabel => 'Building';

  @override
  String get servicesLabel => 'Services';

  @override
  String get noResidence => 'You have not been assigned to a residence yet';

  @override
  String get residenceMeals => 'Residence meals';

  @override
  String get newComplaint => 'New complaint';

  @override
  String get complaintCategory => 'Category';

  @override
  String get complaintSubject => 'Subject';

  @override
  String get complaintDescription => 'Describe the problem';

  @override
  String get attachments => 'Attachments';

  @override
  String get addAttachment => 'Add a file (max 3)';

  @override
  String get submitComplaint => 'Submit complaint';

  @override
  String get complaintSent => 'Your complaint was sent';

  @override
  String get myComplaints => 'My complaints';

  @override
  String get noComplaints => 'You have no complaints';

  @override
  String get statusNew => 'New';

  @override
  String get statusReceived => 'Received';

  @override
  String get statusInProgress => 'In progress';

  @override
  String get statusResolved => 'Resolved';

  @override
  String get categoryOther => 'Other';

  @override
  String get conversation => 'Conversation';

  @override
  String get writeReply => 'Write a reply';

  @override
  String get reportProblem => 'Report a problem';

  @override
  String get complaintClosed => 'This complaint is closed';

  @override
  String get staffLabel => 'Administration';

  @override
  String get you => 'You';

  @override
  String fileCount(int n) {
    return '$n file(s)';
  }

  @override
  String get openAttachment => 'Open attachment';

  @override
  String get errClosed => 'This complaint is closed.';

  @override
  String get errTooMany => 'You reached today\'s limit of complaints.';

  @override
  String get complaintHelp =>
      'Your complaint goes to the team in charge. A person always makes the final decision.';

  @override
  String minChars(int n) {
    return 'At least $n characters';
  }

  @override
  String get add => 'Add';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get cancelAction => 'Cancel';

  @override
  String get actions => 'Actions';

  @override
  String get confirmDeleteTitle => 'Delete this item?';

  @override
  String get confirmDeleteBody => 'This action cannot be undone from the app.';

  @override
  String get savedOk => 'Saved';

  @override
  String get deletedOk => 'Deleted';

  @override
  String pageInfo(int from, int total, int to) {
    return '$from-$to of $total';
  }

  @override
  String get noData => 'No data';

  @override
  String get refresh => 'Refresh';

  @override
  String get copied => 'Copied';

  @override
  String get fName => 'Name';

  @override
  String get fDescription => 'Description';

  @override
  String get fTitle => 'Title';

  @override
  String get fDate => 'Date';

  @override
  String get fTime => 'Time';

  @override
  String get fStart => 'Start';

  @override
  String get fEnd => 'End';

  @override
  String get fCapacity => 'Capacity';

  @override
  String get fImageUrl => 'Image URL (https)';

  @override
  String get fAvailable => 'Available';

  @override
  String get fPublished => 'Published';

  @override
  String get fIsOpen => 'Open';

  @override
  String get fRestaurant => 'Restaurant';

  @override
  String get fRoute => 'Route';

  @override
  String get fDriver => 'Driver';

  @override
  String get fPhone => 'Phone';

  @override
  String get fLicense => 'License number';

  @override
  String get fLatitude => 'Latitude';

  @override
  String get fLongitude => 'Longitude';

  @override
  String get fOrder => 'Order';

  @override
  String get fDeparture => 'Departure';

  @override
  String get fDays => 'Days';

  @override
  String get fDeadline => 'Registration deadline';

  @override
  String get fPath => 'Path (JSON [[lat,lng],...])';

  @override
  String get fSpecialty => 'Specialty';

  @override
  String get fPhotoUrl => 'Photo URL (https)';

  @override
  String get fCover => 'Cover URL (https)';

  @override
  String get fQuantity => 'Quantity';

  @override
  String get fRole => 'Role';

  @override
  String get fActive => 'Active';

  @override
  String get fType => 'Type';

  @override
  String get fStatus => 'Status';

  @override
  String get fLanguage => 'Language';

  @override
  String get fPassword => 'Password (optional)';

  @override
  String get fPasswordHint => 'Empty = an invitation e-mail is sent';

  @override
  String get fResidence => 'Residence';

  @override
  String get fBuilding => 'Building';

  @override
  String get fHealthCenter => 'Health center';

  @override
  String get fSchedule => 'Schedule';

  @override
  String get fRoom => 'Room';

  @override
  String get fStudent => 'Student';

  @override
  String get fBook => 'Book';

  @override
  String get fCreated => 'Created';

  @override
  String get fAddItem => 'Add';

  @override
  String get dStudents => 'Students';

  @override
  String get dActiveAdmins => 'Active admins';

  @override
  String get dRestaurants => 'Restaurants';

  @override
  String get dBuses => 'Buses';

  @override
  String get dActivities => 'Activities';

  @override
  String get dBooks => 'Library books';

  @override
  String get dMedicalDocs => 'Medical documents';

  @override
  String get dComplaints => 'Complaints';

  @override
  String get dPending => 'Pending complaints';

  @override
  String get dHighPriority => 'High priority';

  @override
  String get dOverdueMedical => 'Overdue medical reviews';

  @override
  String get dByStatus => 'Complaints by status';

  @override
  String get dByCategory => 'Complaints by department';

  @override
  String get dByPriority => 'Complaints by priority';

  @override
  String get dAvgResolution => 'Average resolution time';

  @override
  String dHours(int n) {
    return '$n h';
  }

  @override
  String get dTopProblems => 'Most frequent problems';

  @override
  String get dAvgRating => 'Average service rating';

  @override
  String get dRecurring => 'Recurring problems';

  @override
  String get dLast30 => 'Last 30 days';

  @override
  String get priLow => 'Low';

  @override
  String get priMedium => 'Medium';

  @override
  String get priHigh => 'High';

  @override
  String get priCritical => 'Critical';

  @override
  String get mStudents => 'Students';

  @override
  String get mAdmins => 'Administrators';

  @override
  String get mMeals => 'Meals';

  @override
  String get mReservations => 'Reservations';

  @override
  String get mScan => 'QR check-in';

  @override
  String get mRatings => 'Ratings';

  @override
  String get mRoutes => 'Routes';

  @override
  String get mStops => 'Stops';

  @override
  String get mSchedules => 'Schedules';

  @override
  String get mBuses => 'Buses';

  @override
  String get mDrivers => 'Drivers';

  @override
  String get mBuildings => 'Buildings';

  @override
  String get mRooms => 'Rooms';

  @override
  String get mBooks => 'Books';

  @override
  String get mBookReservations => 'Book reservations';

  @override
  String get mMedicalReview => 'Medical documents';

  @override
  String get mBroadcast => 'Send notification';

  @override
  String get mAudit => 'Audit logs';

  @override
  String get mHealthCheck => 'System status';

  @override
  String get mResidences => 'Residences';

  @override
  String get mHealthCenter => 'Health center';

  @override
  String get mResidenceMeals => 'Residence meals';

  @override
  String get mResidenceRestaurants => 'Residence restaurants';

  @override
  String get mResidenceActivities => 'Residence activities';

  @override
  String get gServices => 'Services';

  @override
  String get gPeople => 'People';

  @override
  String get gSystem => 'System';

  @override
  String get rSuper => 'Super admin';

  @override
  String get rRestaurant => 'Restaurant admin';

  @override
  String get rTransport => 'Transport admin';

  @override
  String get rActivities => 'Activities admin';

  @override
  String get rResidence => 'Residence admin';

  @override
  String get rHealth => 'Health admin';

  @override
  String get rLibrary => 'Library admin';

  @override
  String get rComplaints => 'Complaints admin';

  @override
  String get resetPassword => 'Send password reset';

  @override
  String get resetSent => 'Reset e-mail sent';

  @override
  String get disable => 'Disable';

  @override
  String get enable => 'Enable';

  @override
  String get importCsv => 'Import CSV';

  @override
  String get importHint =>
      'Columns: email, fullName, registrationNumber, faculty, major, studyYear';

  @override
  String importResult(int created, int failed) {
    return '$created created, $failed failed';
  }

  @override
  String get sendInvites => 'Send invitation e-mails';

  @override
  String get chooseCsv => 'Choose a CSV file';

  @override
  String rowsReady(int n) {
    return '$n rows ready';
  }

  @override
  String get startImport => 'Start import';

  @override
  String rowLabel(int n) {
    return 'Row $n';
  }

  @override
  String get aAction => 'Action';

  @override
  String get aModule => 'Module';

  @override
  String get aAdmin => 'Admin';

  @override
  String get aResource => 'Resource';

  @override
  String get hcUp => 'Operational';

  @override
  String get hcDown => 'Down';

  @override
  String get hcDatabase => 'Database';

  @override
  String get hcStorage => 'File storage';

  @override
  String get hcAuth => 'Authentication';

  @override
  String get hcPush => 'Push notifications';

  @override
  String get hcAi => 'Smart complaints (AI)';

  @override
  String get hcJobs => 'Background jobs';

  @override
  String get hcConfigured => 'Configured';

  @override
  String get hcNotConfigured => 'Not configured';

  @override
  String hcLatency(int n) {
    return '$n ms';
  }

  @override
  String get bAudience => 'Audience';

  @override
  String get bStudents => 'All students';

  @override
  String get bAdmins => 'All administrators';

  @override
  String get bResidence => 'One residence';

  @override
  String get bTitle => 'Title';

  @override
  String get bBody => 'Message';

  @override
  String get bSend => 'Send';

  @override
  String bSent(int n) {
    return 'Sent to $n people';
  }

  @override
  String get ciPriority => 'Priority';

  @override
  String get ciAssignToMe => 'Assign to me';

  @override
  String get ciUnassign => 'Unassign';

  @override
  String get ciAssigned => 'Assigned';

  @override
  String get ciInternal => 'Internal note (not visible to the student)';

  @override
  String get ciSendReply => 'Send';

  @override
  String get ciAiSuggestion => 'Smart analysis (suggestion only)';

  @override
  String get ciSuggestedDept => 'Suggested department';

  @override
  String get ciTopic => 'Topic';

  @override
  String get ciRecurring => 'Recurring problem';

  @override
  String get ciSimilar => 'Similar complaints';

  @override
  String get ciSimilarNone => 'None found';

  @override
  String get ciDuplicate => 'Possible duplicate';

  @override
  String get ciStatus => 'Change status';

  @override
  String get ciStudent => 'Student';

  @override
  String get ciOnlyRecurring => 'Recurring only';

  @override
  String get ciSortPriority => 'By priority';

  @override
  String get ciSortNewest => 'Newest';

  @override
  String get ciSortOldest => 'Oldest';

  @override
  String get ciLocked => 'Set by an admin: the AI will not change it';

  @override
  String ciSource(String src) {
    return 'Analysis: $src';
  }

  @override
  String get ciAllAssign => 'Everyone';

  @override
  String get ciUnassigned => 'Unassigned';

  @override
  String get ciMine => 'Assigned to me';

  @override
  String get mdOpenFile => 'Open document';

  @override
  String get mdStartReview => 'Start review';

  @override
  String get mdApprove => 'Approve';

  @override
  String get mdReject => 'Reject';

  @override
  String get mdReason => 'Rejection reason (required)';

  @override
  String get mdComment => 'Comment (optional)';

  @override
  String get mdEscalate => 'Escalate to super admin';

  @override
  String get mdEscalated => 'Escalated';

  @override
  String get mdOverdueOnly => 'Overdue only';

  @override
  String get mdDeadline => 'Review deadline';

  @override
  String get mdDone => 'Updated';

  @override
  String get mdSensitive =>
      'Sensitive medical data. Every access is recorded in the audit log.';

  @override
  String get scQr => 'QR code';

  @override
  String get scCheckIn => 'Check in';

  @override
  String get scMeal => 'Meal';

  @override
  String get scActivity => 'Activity';

  @override
  String scOk(String name, String item) {
    return '$name · $item';
  }

  @override
  String get scHint =>
      'Scan with a barcode reader or paste the code, then press Enter.';

  @override
  String get scErrInvalid => 'Invalid QR code';

  @override
  String get scErrUsed => 'Already used';

  @override
  String get scErrDay => 'This code is for another day';

  @override
  String get scErrInactive => 'Reservation is not active';

  @override
  String get rtAverage => 'Average';

  @override
  String rtCount(int n) {
    return '$n ratings';
  }

  @override
  String get acRegistrations => 'Registrations';

  @override
  String get acPublish => 'Publish';

  @override
  String get acUnpublish => 'Unpublish';

  @override
  String get bkCollect => 'Mark as collected';

  @override
  String get bkReturn => 'Mark as returned';

  @override
  String get bkRelease => 'Cancel reservation';

  @override
  String get adminOnlyWeb => 'Administration';

  @override
  String get sortBy => 'Sort by';

  @override
  String get mDashboardReports => 'Dashboard';

  @override
  String get scResult => 'Checked in';

  @override
  String get ratingsFor => 'Ratings for';

  @override
  String get noRatings => 'No ratings yet';

  @override
  String get followRoute => 'Follow this line';

  @override
  String get unfollowRoute => 'Stop following';

  @override
  String get followHint =>
      'Follow a line in Transport to see its next bus here';

  @override
  String get followingNow => 'You follow this line';

  @override
  String get followStopped => 'You no longer follow this line';

  @override
  String get nextBusNoSchedule => 'No schedule for this line';

  @override
  String departsInMin(String time, int n) {
    return '$time (in $n min)';
  }

  @override
  String departsDays(String time, int n) {
    return '$time (+$n d)';
  }

  @override
  String get changePhoto => 'Change photo';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String get fromGallery => 'Choose from gallery';

  @override
  String get fromCamera => 'Take a photo';

  @override
  String get photoUpdated => 'Photo updated';

  @override
  String get offlineActionsOff =>
      'Offline: reservations are disabled until you reconnect';

  @override
  String get biometricUnlock => 'Unlock with biometrics';

  @override
  String get biometricReason => 'Unlock Student Guide';

  @override
  String get unlock => 'Unlock';

  @override
  String get biometricUnavailable =>
      'Biometrics are not available on this device';

  @override
  String get usePassword => 'Use password instead';
}
