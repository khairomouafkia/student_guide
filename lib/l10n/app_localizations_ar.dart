// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'دليل الطالب';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get adminSignIn => 'دخول الإدارة';

  @override
  String get universityEmail => 'البريد الجامعي';

  @override
  String get registrationNumber => 'رقم التسجيل';

  @override
  String get password => 'كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get rememberMe => 'تذكرني';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String welcomeUser(String name) {
    return 'مرحبًا، $name';
  }

  @override
  String get services => 'الخدمات';

  @override
  String get restaurant => 'المطعم';

  @override
  String get transport => 'النقل';

  @override
  String get activities => 'الأنشطة';

  @override
  String get residence => 'الإقامة';

  @override
  String get health => 'الصحة';

  @override
  String get library => 'المكتبة';

  @override
  String get complaints => 'الشكاوى';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get home => 'الرئيسية';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get settings => 'الإعدادات';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get language => 'اللغة';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get genericError => 'حدث خطأ. يرجى المحاولة مرة أخرى.';

  @override
  String get networkError => 'لا يوجد اتصال بالخادم.';

  @override
  String get emptyTitle => 'لا يوجد شيء بعد';

  @override
  String get requiredField => 'هذا الحقل مطلوب';

  @override
  String get invalidEmail => 'أدخل بريدًا إلكترونيًا صالحًا';

  @override
  String get passwordTooShort => '8 أحرف على الأقل';

  @override
  String get resetEmailSent =>
      'إذا كان الحساب موجودًا فقد أُرسل بريد إعادة التعيين';

  @override
  String get markAllRead => 'تحديد الكل كمقروء';

  @override
  String get pendingComplaints => 'شكاوى قيد المعالجة';

  @override
  String get libraryReservations => 'حجوزات المكتبة';

  @override
  String get mealReservation => 'الوجبة القادمة';

  @override
  String get upcomingEvents => 'فعاليات قادمة';

  @override
  String get nextBus => 'الحافلة القادمة';

  @override
  String get noneYet => 'لا يوجد';

  @override
  String get university => 'الجامعة';

  @override
  String get faculty => 'الكلية';

  @override
  String get major => 'التخصص';

  @override
  String get studyYear => 'السنة الدراسية';

  @override
  String get residenceLabel => 'الإقامة';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get unreadNotifications => 'إشعارات غير مقروءة';

  @override
  String get offlineData => 'عرض بيانات محفوظة';

  @override
  String get reserve => 'احجز';

  @override
  String get cancelReservation => 'إلغاء الحجز';

  @override
  String get cancelConfirmTitle => 'إلغاء هذا الحجز؟';

  @override
  String get cancelConfirmBody => 'يمكنك الإلغاء فقط قبل انتهاء مهلة الحجز.';

  @override
  String get reserveSuccess => 'تم حجز الوجبة';

  @override
  String get cancelSuccess => 'تم إلغاء الحجز';

  @override
  String deadlineLabel(String date) {
    return 'احجز قبل $date';
  }

  @override
  String get statusReserved => 'محجوزة';

  @override
  String get statusFull => 'مكتملة';

  @override
  String get statusClosed => 'مغلقة';

  @override
  String get statusDeadline => 'انتهى وقت الحجز';

  @override
  String get statusUnavailable => 'غير متاحة';

  @override
  String get myReservations => 'حجوزاتي';

  @override
  String get showQr => 'عرض رمز QR';

  @override
  String get qrHint => 'اعرض هذا الرمز عند المطعم';

  @override
  String get ingredients => 'المكونات';

  @override
  String get allergens => 'مسببات الحساسية';

  @override
  String get weeklyMenu => 'قائمة الأسبوع';

  @override
  String get rateMeal => 'قيّم هذه الوجبة';

  @override
  String get comment => 'تعليق (اختياري)';

  @override
  String get send => 'إرسال';

  @override
  String get thanksRating => 'شكرًا على تقييمك';

  @override
  String get close => 'إغلاق';

  @override
  String get no => 'لا';

  @override
  String get yes => 'نعم';

  @override
  String get attended => 'تم الاستلام';

  @override
  String get cancelled => 'ملغاة';

  @override
  String get errDeadline => 'انتهت المهلة.';

  @override
  String get errFull => 'العدد مكتمل.';

  @override
  String get errAlready => 'لديك حجز نشط بالفعل.';

  @override
  String get errUnavailable => 'غير متاح.';

  @override
  String get errNotEligible => 'يمكنك تقييم الخدمات التي استخدمتها فقط.';

  @override
  String get errTooEarly => 'يمكنك التقييم بعد انتهاء الفعالية.';

  @override
  String get loadMore => 'عرض المزيد';

  @override
  String get noMeals => 'لا توجد وجبات مبرمجة';

  @override
  String get breakfast => 'الفطور';

  @override
  String get lunch => 'الغداء';

  @override
  String get dinner => 'العشاء';

  @override
  String remainingPlaces(int n) {
    return 'متبقي $n';
  }

  @override
  String get transportLines => 'خطوط الحافلات';

  @override
  String get liveBuses => 'الحافلات مباشرة';

  @override
  String get todaysDepartures => 'رحلات اليوم';

  @override
  String get stops => 'المحطات';

  @override
  String get etaTitle => 'وقت الوصول المتوقع';

  @override
  String etaMinutes(int n) {
    return '$n د';
  }

  @override
  String get etaApprox => 'تقريبي، حسب الموقع الحالي للحافلة.';

  @override
  String get noBusLive => 'لا توجد حافلة ترسل موقعها حاليًا.';

  @override
  String lastUpdate(String ago) {
    return 'آخر تحديث منذ $ago';
  }

  @override
  String speedKmh(int n) {
    return '$n كم/س';
  }

  @override
  String get plate => 'رقم اللوحة';

  @override
  String get statusStale => 'انقطع الإشارة';

  @override
  String get rateService => 'قيّم هذه الخدمة';

  @override
  String get noDepartures => 'لا توجد رحلات اليوم';

  @override
  String busesLive(int n) {
    return '$n مباشرة';
  }

  @override
  String get noRoutes => 'لا توجد خطوط بعد';

  @override
  String get searchHint => 'بحث';

  @override
  String get filterAll => 'الكل';

  @override
  String get upcoming => 'القادمة';

  @override
  String get past => 'السابقة';

  @override
  String get registerAction => 'سجّل';

  @override
  String get cancelRegistration => 'إلغاء التسجيل';

  @override
  String get registerSuccess => 'تم تسجيلك';

  @override
  String get registrationCancelled => 'تم إلغاء التسجيل';

  @override
  String registerBefore(String date) {
    return 'سجّل قبل $date';
  }

  @override
  String get statusRegistered => 'مسجّل';

  @override
  String get statusRegClosed => 'انتهى التسجيل';

  @override
  String get noActivities => 'لا توجد أنشطة';

  @override
  String get myActivities => 'أنشطتي';

  @override
  String get rateActivity => 'قيّم هذا النشاط';

  @override
  String get locationLabel => 'المكان';

  @override
  String get typeCultural => 'ثقافي';

  @override
  String get typeSports => 'رياضي';

  @override
  String get typeWorkshop => 'ورشة';

  @override
  String get typeConference => 'مؤتمر';

  @override
  String get typeCompetition => 'مسابقة';

  @override
  String get typeOther => 'أخرى';

  @override
  String get searchBooks => 'ابحث بالعنوان أو المؤلف أو ISBN';

  @override
  String get availableOnly => 'المتوفرة فقط';

  @override
  String copiesAvailable(int n) {
    return 'متوفر $n';
  }

  @override
  String get outOfStock => 'غير متوفر';

  @override
  String get reserveBook => 'احجز هذا الكتاب';

  @override
  String get bookReserved => 'تم حجز الكتاب';

  @override
  String get notifyMe => 'أبلغني عند التوفر';

  @override
  String get notifyMeOn => 'سنبلغك عند التوفر';

  @override
  String get notifyMeOff => 'تم إلغاء التنبيه';

  @override
  String get myBooks => 'حجوزات الكتب';

  @override
  String get author => 'المؤلف';

  @override
  String get isbn => 'ISBN';

  @override
  String get category => 'التصنيف';

  @override
  String get statusCollected => 'تم الاستلام';

  @override
  String get statusReturned => 'تمت الإعادة';

  @override
  String get errLimit => 'وصلت إلى الحد الأقصى: 5 كتب نشطة.';

  @override
  String get errAvailableNow => 'الكتاب متوفر الآن: يمكنك حجزه.';

  @override
  String get noBooks => 'لا توجد كتب';

  @override
  String get pickUpAt => 'يُستلم من المكتبة';

  @override
  String get healthCenter => 'المركز الصحي';

  @override
  String get doctors => 'الأطباء';

  @override
  String get medicalDocuments => 'الوثائق الطبية';

  @override
  String get uploadDocument => 'رفع وثيقة';

  @override
  String get docMedicalCertificate => 'شهادة طبية';

  @override
  String get docSickLeave => 'عطلة مرضية';

  @override
  String get docPending => 'قيد الانتظار';

  @override
  String get docUnderReview => 'قيد المراجعة';

  @override
  String get docApproved => 'مقبولة';

  @override
  String get docRejected => 'مرفوضة';

  @override
  String get docOverdue => 'متأخرة';

  @override
  String get reviewWithin72 => 'يجب مراجعة الوثيقة خلال 72 ساعة.';

  @override
  String hoursLeft(int n) {
    return 'متبقي $n ساعة';
  }

  @override
  String rejectionReason(String reason) {
    return 'السبب: $reason';
  }

  @override
  String reviewerComment(String comment) {
    return 'تعليق: $comment';
  }

  @override
  String get chooseFile =>
      'اختر ملفًا (PDF أو JPG أو PNG، بحد أقصى 5 ميغابايت)';

  @override
  String get uploadSuccess => 'تم رفع الوثيقة';

  @override
  String get noDocuments => 'لا توجد وثائق بعد';

  @override
  String get openNow => 'مفتوح';

  @override
  String get closedNow => 'مغلق';

  @override
  String get noDoctors => 'لا يوجد أطباء';

  @override
  String get office => 'المكتب';

  @override
  String get sensitiveNote =>
      'الوثائق الطبية خاصة: لا يراها إلا أنت والمركز الصحي.';

  @override
  String get errFileTooLarge => 'حجم الملف أكبر من 5 ميغابايت.';

  @override
  String get errFileType => 'يُقبل فقط PDF أو JPG أو PNG.';

  @override
  String get selectType => 'نوع الوثيقة';

  @override
  String get openingHours => 'ساعات العمل';

  @override
  String get noCenter => 'معلومات المركز الصحي غير متوفرة بعد';

  @override
  String get upload => 'رفع';

  @override
  String get myResidence => 'إقامتي';

  @override
  String get roomLabel => 'الغرفة';

  @override
  String get buildingLabel => 'المبنى';

  @override
  String get servicesLabel => 'الخدمات';

  @override
  String get noResidence => 'لم يتم تسكينك في إقامة بعد';

  @override
  String get residenceMeals => 'وجبات الإقامة';

  @override
  String get newComplaint => 'شكوى جديدة';

  @override
  String get complaintCategory => 'القسم';

  @override
  String get complaintSubject => 'الموضوع';

  @override
  String get complaintDescription => 'اشرح المشكلة';

  @override
  String get attachments => 'المرفقات';

  @override
  String get addAttachment => 'أضف ملفًا (3 كحد أقصى)';

  @override
  String get submitComplaint => 'إرسال الشكوى';

  @override
  String get complaintSent => 'تم إرسال شكواك';

  @override
  String get myComplaints => 'شكاواي';

  @override
  String get noComplaints => 'لا توجد لديك شكاوى';

  @override
  String get statusNew => 'جديدة';

  @override
  String get statusReceived => 'مستلمة';

  @override
  String get statusInProgress => 'قيد المعالجة';

  @override
  String get statusResolved => 'تم حلها';

  @override
  String get categoryOther => 'أخرى';

  @override
  String get conversation => 'المراسلات';

  @override
  String get writeReply => 'اكتب ردًا';

  @override
  String get reportProblem => 'الإبلاغ عن مشكلة';

  @override
  String get complaintClosed => 'هذه الشكوى مغلقة';

  @override
  String get staffLabel => 'الإدارة';

  @override
  String get you => 'أنت';

  @override
  String fileCount(int n) {
    return '$n ملف';
  }

  @override
  String get openAttachment => 'فتح المرفق';

  @override
  String get errClosed => 'هذه الشكوى مغلقة.';

  @override
  String get errTooMany => 'وصلت إلى الحد اليومي للشكاوى.';

  @override
  String get complaintHelp =>
      'تصل شكواك إلى الفريق المختص، والقرار النهائي دائمًا يتخذه شخص.';

  @override
  String minChars(int n) {
    return '$n أحرف على الأقل';
  }

  @override
  String get add => 'إضافة';

  @override
  String get edit => 'تعديل';

  @override
  String get delete => 'حذف';

  @override
  String get save => 'حفظ';

  @override
  String get cancelAction => 'إلغاء';

  @override
  String get actions => 'إجراءات';

  @override
  String get confirmDeleteTitle => 'حذف هذا العنصر؟';

  @override
  String get confirmDeleteBody => 'لا يمكن التراجع عن هذا الإجراء من التطبيق.';

  @override
  String get savedOk => 'تم الحفظ';

  @override
  String get deletedOk => 'تم الحذف';

  @override
  String pageInfo(int from, int total, int to) {
    return '$from-$to من $total';
  }

  @override
  String get noData => 'لا توجد بيانات';

  @override
  String get refresh => 'تحديث';

  @override
  String get copied => 'تم النسخ';

  @override
  String get fName => 'الاسم';

  @override
  String get fDescription => 'الوصف';

  @override
  String get fTitle => 'العنوان';

  @override
  String get fDate => 'التاريخ';

  @override
  String get fTime => 'الوقت';

  @override
  String get fStart => 'البداية';

  @override
  String get fEnd => 'النهاية';

  @override
  String get fCapacity => 'السعة';

  @override
  String get fImageUrl => 'رابط الصورة (https)';

  @override
  String get fAvailable => 'متاح';

  @override
  String get fPublished => 'منشور';

  @override
  String get fIsOpen => 'مفتوح';

  @override
  String get fRestaurant => 'المطعم';

  @override
  String get fRoute => 'الخط';

  @override
  String get fDriver => 'السائق';

  @override
  String get fPhone => 'الهاتف';

  @override
  String get fLicense => 'رقم الرخصة';

  @override
  String get fLatitude => 'خط العرض';

  @override
  String get fLongitude => 'خط الطول';

  @override
  String get fOrder => 'الترتيب';

  @override
  String get fDeparture => 'الانطلاق';

  @override
  String get fDays => 'الأيام';

  @override
  String get fDeadline => 'آخر موعد للتسجيل';

  @override
  String get fPath => 'المسار (JSON [[lat,lng],...])';

  @override
  String get fSpecialty => 'التخصص';

  @override
  String get fPhotoUrl => 'رابط الصورة (https)';

  @override
  String get fCover => 'رابط الغلاف (https)';

  @override
  String get fQuantity => 'الكمية';

  @override
  String get fRole => 'الدور';

  @override
  String get fActive => 'نشط';

  @override
  String get fType => 'النوع';

  @override
  String get fStatus => 'الحالة';

  @override
  String get fLanguage => 'اللغة';

  @override
  String get fPassword => 'كلمة المرور (اختياري)';

  @override
  String get fPasswordHint => 'فارغ = يُرسل بريد دعوة';

  @override
  String get fResidence => 'الإقامة';

  @override
  String get fBuilding => 'المبنى';

  @override
  String get fHealthCenter => 'المركز الصحي';

  @override
  String get fSchedule => 'الجدول';

  @override
  String get fRoom => 'الغرفة';

  @override
  String get fStudent => 'الطالب';

  @override
  String get fBook => 'الكتاب';

  @override
  String get fCreated => 'أُنشئ';

  @override
  String get fAddItem => 'أضف';

  @override
  String get dStudents => 'الطلاب';

  @override
  String get dActiveAdmins => 'الإداريون النشطون';

  @override
  String get dRestaurants => 'المطاعم';

  @override
  String get dBuses => 'الحافلات';

  @override
  String get dActivities => 'الأنشطة';

  @override
  String get dBooks => 'كتب المكتبة';

  @override
  String get dMedicalDocs => 'الوثائق الطبية';

  @override
  String get dComplaints => 'الشكاوى';

  @override
  String get dPending => 'شكاوى قيد المعالجة';

  @override
  String get dHighPriority => 'أولوية عالية';

  @override
  String get dOverdueMedical => 'مراجعات طبية متأخرة';

  @override
  String get dByStatus => 'الشكاوى حسب الحالة';

  @override
  String get dByCategory => 'الشكاوى حسب القسم';

  @override
  String get dByPriority => 'الشكاوى حسب الأولوية';

  @override
  String get dAvgResolution => 'متوسط وقت الحل';

  @override
  String dHours(int n) {
    return '$n ساعة';
  }

  @override
  String get dTopProblems => 'أكثر المشاكل تكرارًا';

  @override
  String get dAvgRating => 'متوسط تقييم الخدمات';

  @override
  String get dRecurring => 'مشاكل متكررة';

  @override
  String get dLast30 => 'آخر 30 يومًا';

  @override
  String get priLow => 'منخفضة';

  @override
  String get priMedium => 'متوسطة';

  @override
  String get priHigh => 'عالية';

  @override
  String get priCritical => 'حرجة';

  @override
  String get mStudents => 'الطلاب';

  @override
  String get mAdmins => 'الإداريون';

  @override
  String get mMeals => 'الوجبات';

  @override
  String get mReservations => 'الحجوزات';

  @override
  String get mScan => 'تسجيل الحضور QR';

  @override
  String get mRatings => 'التقييمات';

  @override
  String get mRoutes => 'الخطوط';

  @override
  String get mStops => 'المحطات';

  @override
  String get mSchedules => 'الجداول';

  @override
  String get mBuses => 'الحافلات';

  @override
  String get mDrivers => 'السائقون';

  @override
  String get mBuildings => 'المباني';

  @override
  String get mRooms => 'الغرف';

  @override
  String get mBooks => 'الكتب';

  @override
  String get mBookReservations => 'حجوزات الكتب';

  @override
  String get mMedicalReview => 'الوثائق الطبية';

  @override
  String get mBroadcast => 'إرسال إشعار';

  @override
  String get mAudit => 'سجل المراجعة';

  @override
  String get mHealthCheck => 'حالة النظام';

  @override
  String get mResidences => 'الإقامات';

  @override
  String get mHealthCenter => 'المركز الصحي';

  @override
  String get mResidenceMeals => 'وجبات الإقامة';

  @override
  String get mResidenceRestaurants => 'مطاعم الإقامة';

  @override
  String get mResidenceActivities => 'أنشطة الإقامة';

  @override
  String get gServices => 'الخدمات';

  @override
  String get gPeople => 'الأشخاص';

  @override
  String get gSystem => 'النظام';

  @override
  String get rSuper => 'مشرف عام';

  @override
  String get rRestaurant => 'مسؤول المطعم';

  @override
  String get rTransport => 'مسؤول النقل';

  @override
  String get rActivities => 'مسؤول الأنشطة';

  @override
  String get rResidence => 'مسؤول الإقامة';

  @override
  String get rHealth => 'مسؤول الصحة';

  @override
  String get rLibrary => 'مسؤول المكتبة';

  @override
  String get rComplaints => 'مسؤول الشكاوى';

  @override
  String get resetPassword => 'إرسال إعادة تعيين كلمة المرور';

  @override
  String get resetSent => 'تم إرسال بريد إعادة التعيين';

  @override
  String get disable => 'تعطيل';

  @override
  String get enable => 'تفعيل';

  @override
  String get importCsv => 'استيراد CSV';

  @override
  String get importHint =>
      'الأعمدة: email, fullName, registrationNumber, faculty, major, studyYear';

  @override
  String importResult(int created, int failed) {
    return 'تم إنشاء $created، وفشل $failed';
  }

  @override
  String get sendInvites => 'إرسال بريد الدعوة';

  @override
  String get chooseCsv => 'اختر ملف CSV';

  @override
  String rowsReady(int n) {
    return '$n صف جاهز';
  }

  @override
  String get startImport => 'بدء الاستيراد';

  @override
  String rowLabel(int n) {
    return 'الصف $n';
  }

  @override
  String get aAction => 'الإجراء';

  @override
  String get aModule => 'الوحدة';

  @override
  String get aAdmin => 'المسؤول';

  @override
  String get aResource => 'المورد';

  @override
  String get hcUp => 'يعمل';

  @override
  String get hcDown => 'متوقف';

  @override
  String get hcDatabase => 'قاعدة البيانات';

  @override
  String get hcStorage => 'تخزين الملفات';

  @override
  String get hcAuth => 'المصادقة';

  @override
  String get hcPush => 'الإشعارات الفورية';

  @override
  String get hcAi => 'الشكاوى الذكية';

  @override
  String get hcJobs => 'المهام الخلفية';

  @override
  String get hcConfigured => 'مفعّل';

  @override
  String get hcNotConfigured => 'غير مفعّل';

  @override
  String hcLatency(int n) {
    return '$n مللي ثانية';
  }

  @override
  String get bAudience => 'الفئة المستهدفة';

  @override
  String get bStudents => 'كل الطلاب';

  @override
  String get bAdmins => 'كل الإداريين';

  @override
  String get bResidence => 'إقامة محددة';

  @override
  String get bTitle => 'العنوان';

  @override
  String get bBody => 'الرسالة';

  @override
  String get bSend => 'إرسال';

  @override
  String bSent(int n) {
    return 'أُرسل إلى $n شخصًا';
  }

  @override
  String get ciPriority => 'الأولوية';

  @override
  String get ciAssignToMe => 'تعيين لي';

  @override
  String get ciUnassign => 'إلغاء التعيين';

  @override
  String get ciAssigned => 'معيّنة';

  @override
  String get ciInternal => 'ملاحظة داخلية (لا يراها الطالب)';

  @override
  String get ciSendReply => 'إرسال';

  @override
  String get ciAiSuggestion => 'التحليل الذكي (اقتراح فقط)';

  @override
  String get ciSuggestedDept => 'القسم المقترح';

  @override
  String get ciTopic => 'الموضوع';

  @override
  String get ciRecurring => 'مشكلة متكررة';

  @override
  String get ciSimilar => 'شكاوى مشابهة';

  @override
  String get ciSimilarNone => 'لا توجد';

  @override
  String get ciDuplicate => 'مكررة محتملة';

  @override
  String get ciStatus => 'تغيير الحالة';

  @override
  String get ciStudent => 'الطالب';

  @override
  String get ciOnlyRecurring => 'المتكررة فقط';

  @override
  String get ciSortPriority => 'حسب الأولوية';

  @override
  String get ciSortNewest => 'الأحدث';

  @override
  String get ciSortOldest => 'الأقدم';

  @override
  String get ciLocked => 'حدده مسؤول: لن يغيّره الذكاء الاصطناعي';

  @override
  String ciSource(String src) {
    return 'التحليل: $src';
  }

  @override
  String get ciAllAssign => 'الجميع';

  @override
  String get ciUnassigned => 'غير معيّنة';

  @override
  String get ciMine => 'المعيّنة لي';

  @override
  String get mdOpenFile => 'فتح الوثيقة';

  @override
  String get mdStartReview => 'بدء المراجعة';

  @override
  String get mdApprove => 'قبول';

  @override
  String get mdReject => 'رفض';

  @override
  String get mdReason => 'سبب الرفض (إلزامي)';

  @override
  String get mdComment => 'تعليق (اختياري)';

  @override
  String get mdEscalate => 'تصعيد إلى المشرف العام';

  @override
  String get mdEscalated => 'تم التصعيد';

  @override
  String get mdOverdueOnly => 'المتأخرة فقط';

  @override
  String get mdDeadline => 'مهلة المراجعة';

  @override
  String get mdDone => 'تم التحديث';

  @override
  String get mdSensitive =>
      'بيانات طبية حساسة. كل وصول يُسجَّل في سجل المراجعة.';

  @override
  String get scQr => 'رمز QR';

  @override
  String get scCheckIn => 'تسجيل';

  @override
  String get scMeal => 'وجبة';

  @override
  String get scActivity => 'نشاط';

  @override
  String scOk(String name, String item) {
    return '$name · $item';
  }

  @override
  String get scHint => 'امسح بقارئ الباركود أو الصق الرمز ثم اضغط Enter.';

  @override
  String get scErrInvalid => 'رمز QR غير صالح';

  @override
  String get scErrUsed => 'تم استخدامه سابقًا';

  @override
  String get scErrDay => 'هذا الرمز ليوم آخر';

  @override
  String get scErrInactive => 'الحجز غير نشط';

  @override
  String get rtAverage => 'المتوسط';

  @override
  String rtCount(int n) {
    return '$n تقييم';
  }

  @override
  String get acRegistrations => 'التسجيلات';

  @override
  String get acPublish => 'نشر';

  @override
  String get acUnpublish => 'إلغاء النشر';

  @override
  String get bkCollect => 'تسجيل الاستلام';

  @override
  String get bkReturn => 'تسجيل الإرجاع';

  @override
  String get bkRelease => 'إلغاء الحجز';

  @override
  String get adminOnlyWeb => 'الإدارة';

  @override
  String get sortBy => 'ترتيب حسب';

  @override
  String get mDashboardReports => 'لوحة التحكم';

  @override
  String get scResult => 'تم التسجيل';

  @override
  String get ratingsFor => 'تقييمات';

  @override
  String get noRatings => 'لا توجد تقييمات بعد';

  @override
  String get followRoute => 'تتبّع هذا الخط';

  @override
  String get unfollowRoute => 'إلغاء التتبع';

  @override
  String get followHint => 'تتبّع خطًا من قسم النقل لترى حافلته القادمة هنا';

  @override
  String get followingNow => 'أنت تتبّع هذا الخط';

  @override
  String get followStopped => 'تم إلغاء التتبع';

  @override
  String get nextBusNoSchedule => 'لا توجد جداول لهذا الخط';

  @override
  String departsInMin(String time, int n) {
    return '$time (بعد $n د)';
  }

  @override
  String departsDays(String time, int n) {
    return '$time (+$n يوم)';
  }

  @override
  String get changePhoto => 'تغيير الصورة';

  @override
  String get removePhoto => 'حذف الصورة';

  @override
  String get fromGallery => 'اختر من المعرض';

  @override
  String get fromCamera => 'التقاط صورة';

  @override
  String get photoUpdated => 'تم تحديث الصورة';

  @override
  String get offlineActionsOff => 'دون اتصال: الحجز معطّل حتى يعود الاتصال';

  @override
  String get biometricUnlock => 'الدخول بالبصمة';

  @override
  String get biometricReason => 'افتح دليل الطالب';

  @override
  String get unlock => 'فتح';

  @override
  String get biometricUnavailable => 'البصمة غير متاحة على هذا الجهاز';

  @override
  String get usePassword => 'استخدم كلمة المرور';
}
