// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Student Guide';

  @override
  String get signIn => 'Se connecter';

  @override
  String get adminSignIn => 'Connexion administration';

  @override
  String get universityEmail => 'E-mail universitaire';

  @override
  String get registrationNumber => 'Numéro d\'inscription';

  @override
  String get password => 'Mot de passe';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get rememberMe => 'Se souvenir de moi';

  @override
  String get logout => 'Se déconnecter';

  @override
  String welcomeUser(String name) {
    return 'Bienvenue, $name';
  }

  @override
  String get services => 'Services';

  @override
  String get restaurant => 'Restaurant';

  @override
  String get transport => 'Transport';

  @override
  String get activities => 'Activités';

  @override
  String get residence => 'Résidence';

  @override
  String get health => 'Santé';

  @override
  String get library => 'Bibliothèque';

  @override
  String get complaints => 'Réclamations';

  @override
  String get notifications => 'Notifications';

  @override
  String get profile => 'Profil';

  @override
  String get home => 'Accueil';

  @override
  String get dashboard => 'Tableau de bord';

  @override
  String get settings => 'Paramètres';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get language => 'Langue';

  @override
  String get retry => 'Réessayer';

  @override
  String get genericError => 'Une erreur est survenue. Veuillez réessayer.';

  @override
  String get networkError => 'Pas de connexion au serveur.';

  @override
  String get emptyTitle => 'Rien pour le moment';

  @override
  String get requiredField => 'Ce champ est obligatoire';

  @override
  String get invalidEmail => 'Saisissez un e-mail valide';

  @override
  String get passwordTooShort => 'Au moins 8 caractères';

  @override
  String get resetEmailSent =>
      'Si le compte existe, un e-mail de réinitialisation a été envoyé';

  @override
  String get markAllRead => 'Tout marquer comme lu';

  @override
  String get pendingComplaints => 'Réclamations en cours';

  @override
  String get libraryReservations => 'Réservations bibliothèque';

  @override
  String get mealReservation => 'Prochain repas';

  @override
  String get upcomingEvents => 'Événements à venir';

  @override
  String get nextBus => 'Prochain bus';

  @override
  String get noneYet => 'Aucun';

  @override
  String get university => 'Université';

  @override
  String get faculty => 'Faculté';

  @override
  String get major => 'Spécialité';

  @override
  String get studyYear => 'Année d\'études';

  @override
  String get residenceLabel => 'Résidence';

  @override
  String get fullName => 'Nom complet';

  @override
  String get unreadNotifications => 'Notifications non lues';

  @override
  String get offlineData => 'Données enregistrées affichées';

  @override
  String get reserve => 'Réserver';

  @override
  String get cancelReservation => 'Annuler la réservation';

  @override
  String get cancelConfirmTitle => 'Annuler cette réservation ?';

  @override
  String get cancelConfirmBody =>
      'L\'annulation n\'est possible que jusqu\'à la date limite.';

  @override
  String get reserveSuccess => 'Repas réservé';

  @override
  String get cancelSuccess => 'Réservation annulée';

  @override
  String deadlineLabel(String date) {
    return 'Réserver avant le $date';
  }

  @override
  String get statusReserved => 'Réservé';

  @override
  String get statusFull => 'Complet';

  @override
  String get statusClosed => 'Clôturée';

  @override
  String get statusDeadline => 'Réservation close';

  @override
  String get statusUnavailable => 'Indisponible';

  @override
  String get myReservations => 'Mes réservations';

  @override
  String get showQr => 'Afficher le QR code';

  @override
  String get qrHint => 'Présentez ce code au restaurant';

  @override
  String get ingredients => 'Ingrédients';

  @override
  String get allergens => 'Allergènes';

  @override
  String get weeklyMenu => 'Menu de la semaine';

  @override
  String get rateMeal => 'Noter ce repas';

  @override
  String get comment => 'Commentaire (facultatif)';

  @override
  String get send => 'Envoyer';

  @override
  String get thanksRating => 'Merci pour votre avis';

  @override
  String get close => 'Fermer';

  @override
  String get no => 'Non';

  @override
  String get yes => 'Oui';

  @override
  String get attended => 'Consommé';

  @override
  String get cancelled => 'Annulé';

  @override
  String get errDeadline => 'Le délai est dépassé.';

  @override
  String get errFull => 'Complet.';

  @override
  String get errAlready => 'Vous avez déjà une réservation active.';

  @override
  String get errUnavailable => 'Indisponible.';

  @override
  String get errNotEligible =>
      'Vous ne pouvez noter que les services utilisés.';

  @override
  String get errTooEarly => 'Vous pourrez noter après l\'événement.';

  @override
  String get loadMore => 'Charger plus';

  @override
  String get noMeals => 'Aucun repas programmé';

  @override
  String get breakfast => 'Petit-déjeuner';

  @override
  String get lunch => 'Déjeuner';

  @override
  String get dinner => 'Dîner';

  @override
  String remainingPlaces(int n) {
    return '$n restant(s)';
  }

  @override
  String get transportLines => 'Lignes de bus';

  @override
  String get liveBuses => 'Bus en direct';

  @override
  String get todaysDepartures => 'Départs d\'aujourd\'hui';

  @override
  String get stops => 'Arrêts';

  @override
  String get etaTitle => 'Arrivée estimée';

  @override
  String etaMinutes(int n) {
    return '$n min';
  }

  @override
  String get etaApprox => 'Approximatif, selon la position actuelle du bus.';

  @override
  String get noBusLive => 'Aucun bus ne transmet sa position pour le moment.';

  @override
  String lastUpdate(String ago) {
    return 'Mis à jour il y a $ago';
  }

  @override
  String speedKmh(int n) {
    return '$n km/h';
  }

  @override
  String get plate => 'Immatriculation';

  @override
  String get statusStale => 'Signal perdu';

  @override
  String get rateService => 'Noter ce service';

  @override
  String get noDepartures => 'Aucun départ aujourd\'hui';

  @override
  String busesLive(int n) {
    return '$n en direct';
  }

  @override
  String get noRoutes => 'Aucune ligne pour le moment';

  @override
  String get searchHint => 'Rechercher';

  @override
  String get filterAll => 'Tout';

  @override
  String get upcoming => 'À venir';

  @override
  String get past => 'Passées';

  @override
  String get registerAction => 'S\'inscrire';

  @override
  String get cancelRegistration => 'Annuler l\'inscription';

  @override
  String get registerSuccess => 'Inscription confirmée';

  @override
  String get registrationCancelled => 'Inscription annulée';

  @override
  String registerBefore(String date) {
    return 'S\'inscrire avant le $date';
  }

  @override
  String get statusRegistered => 'Inscrit';

  @override
  String get statusRegClosed => 'Inscriptions closes';

  @override
  String get noActivities => 'Aucune activité trouvée';

  @override
  String get myActivities => 'Mes activités';

  @override
  String get rateActivity => 'Noter cette activité';

  @override
  String get locationLabel => 'Lieu';

  @override
  String get typeCultural => 'Culturel';

  @override
  String get typeSports => 'Sport';

  @override
  String get typeWorkshop => 'Atelier';

  @override
  String get typeConference => 'Conférence';

  @override
  String get typeCompetition => 'Compétition';

  @override
  String get typeOther => 'Autre';

  @override
  String get searchBooks => 'Titre, auteur ou ISBN';

  @override
  String get availableOnly => 'Disponibles seulement';

  @override
  String copiesAvailable(int n) {
    return '$n disponible(s)';
  }

  @override
  String get outOfStock => 'Indisponible';

  @override
  String get reserveBook => 'Réserver ce livre';

  @override
  String get bookReserved => 'Livre réservé';

  @override
  String get notifyMe => 'Me prévenir dès qu\'il est disponible';

  @override
  String get notifyMeOn => 'Nous vous préviendrons';

  @override
  String get notifyMeOff => 'Alerte supprimée';

  @override
  String get myBooks => 'Mes réservations de livres';

  @override
  String get author => 'Auteur';

  @override
  String get isbn => 'ISBN';

  @override
  String get category => 'Catégorie';

  @override
  String get statusCollected => 'Retiré';

  @override
  String get statusReturned => 'Rendu';

  @override
  String get errLimit => 'Vous avez atteint la limite de 5 livres actifs.';

  @override
  String get errAvailableNow =>
      'Le livre est disponible : vous pouvez le réserver.';

  @override
  String get noBooks => 'Aucun livre trouvé';

  @override
  String get pickUpAt => 'À retirer à la bibliothèque';

  @override
  String get healthCenter => 'Centre de santé';

  @override
  String get doctors => 'Médecins';

  @override
  String get medicalDocuments => 'Documents médicaux';

  @override
  String get uploadDocument => 'Envoyer un document';

  @override
  String get docMedicalCertificate => 'Certificat médical';

  @override
  String get docSickLeave => 'Arrêt maladie';

  @override
  String get docPending => 'En attente';

  @override
  String get docUnderReview => 'En cours d\'examen';

  @override
  String get docApproved => 'Approuvé';

  @override
  String get docRejected => 'Refusé';

  @override
  String get docOverdue => 'En retard';

  @override
  String get reviewWithin72 => 'Le document doit être examiné sous 72 heures.';

  @override
  String hoursLeft(int n) {
    return '$n h restantes';
  }

  @override
  String rejectionReason(String reason) {
    return 'Motif : $reason';
  }

  @override
  String reviewerComment(String comment) {
    return 'Commentaire : $comment';
  }

  @override
  String get chooseFile => 'Choisir un fichier (PDF, JPG, PNG, 5 Mo max)';

  @override
  String get uploadSuccess => 'Document envoyé';

  @override
  String get noDocuments => 'Aucun document';

  @override
  String get openNow => 'Ouvert';

  @override
  String get closedNow => 'Fermé';

  @override
  String get noDoctors => 'Aucun médecin';

  @override
  String get office => 'Bureau';

  @override
  String get sensitiveNote =>
      'Les documents médicaux sont privés : seuls vous et le centre de santé y avez accès.';

  @override
  String get errFileTooLarge => 'Le fichier dépasse 5 Mo.';

  @override
  String get errFileType => 'Seuls les fichiers PDF, JPG ou PNG sont acceptés.';

  @override
  String get selectType => 'Type de document';

  @override
  String get openingHours => 'Horaires d\'ouverture';

  @override
  String get noCenter => 'Informations du centre de santé indisponibles';

  @override
  String get upload => 'Envoyer';

  @override
  String get myResidence => 'Ma résidence';

  @override
  String get roomLabel => 'Chambre';

  @override
  String get buildingLabel => 'Bâtiment';

  @override
  String get servicesLabel => 'Services';

  @override
  String get noResidence => 'Vous n\'êtes pas encore affecté à une résidence';

  @override
  String get residenceMeals => 'Repas de la résidence';

  @override
  String get newComplaint => 'Nouvelle réclamation';

  @override
  String get complaintCategory => 'Catégorie';

  @override
  String get complaintSubject => 'Objet';

  @override
  String get complaintDescription => 'Décrivez le problème';

  @override
  String get attachments => 'Pièces jointes';

  @override
  String get addAttachment => 'Ajouter un fichier (3 max)';

  @override
  String get submitComplaint => 'Envoyer la réclamation';

  @override
  String get complaintSent => 'Votre réclamation a été envoyée';

  @override
  String get myComplaints => 'Mes réclamations';

  @override
  String get noComplaints => 'Vous n\'avez aucune réclamation';

  @override
  String get statusNew => 'Nouvelle';

  @override
  String get statusReceived => 'Reçue';

  @override
  String get statusInProgress => 'En cours';

  @override
  String get statusResolved => 'Résolue';

  @override
  String get categoryOther => 'Autre';

  @override
  String get conversation => 'Échanges';

  @override
  String get writeReply => 'Écrire une réponse';

  @override
  String get reportProblem => 'Signaler un problème';

  @override
  String get complaintClosed => 'Cette réclamation est clôturée';

  @override
  String get staffLabel => 'Administration';

  @override
  String get you => 'Vous';

  @override
  String fileCount(int n) {
    return '$n fichier(s)';
  }

  @override
  String get openAttachment => 'Ouvrir la pièce jointe';

  @override
  String get errClosed => 'Cette réclamation est clôturée.';

  @override
  String get errTooMany =>
      'Vous avez atteint la limite de réclamations du jour.';

  @override
  String get complaintHelp =>
      'Votre réclamation est transmise à l\'équipe concernée. Une personne prend toujours la décision finale.';

  @override
  String minChars(int n) {
    return 'Au moins $n caractères';
  }

  @override
  String get add => 'Ajouter';

  @override
  String get edit => 'Modifier';

  @override
  String get delete => 'Supprimer';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancelAction => 'Annuler';

  @override
  String get actions => 'Actions';

  @override
  String get confirmDeleteTitle => 'Supprimer cet élément ?';

  @override
  String get confirmDeleteBody =>
      'Cette action est irréversible depuis l\'application.';

  @override
  String get savedOk => 'Enregistré';

  @override
  String get deletedOk => 'Supprimé';

  @override
  String pageInfo(int from, int total, int to) {
    return '$from-$to sur $total';
  }

  @override
  String get noData => 'Aucune donnée';

  @override
  String get refresh => 'Actualiser';

  @override
  String get copied => 'Copié';

  @override
  String get fName => 'Nom';

  @override
  String get fDescription => 'Description';

  @override
  String get fTitle => 'Titre';

  @override
  String get fDate => 'Date';

  @override
  String get fTime => 'Heure';

  @override
  String get fStart => 'Début';

  @override
  String get fEnd => 'Fin';

  @override
  String get fCapacity => 'Capacité';

  @override
  String get fImageUrl => 'URL de l\'image (https)';

  @override
  String get fAvailable => 'Disponible';

  @override
  String get fPublished => 'Publié';

  @override
  String get fIsOpen => 'Ouvert';

  @override
  String get fRestaurant => 'Restaurant';

  @override
  String get fRoute => 'Ligne';

  @override
  String get fDriver => 'Chauffeur';

  @override
  String get fPhone => 'Téléphone';

  @override
  String get fLicense => 'N° de permis';

  @override
  String get fLatitude => 'Latitude';

  @override
  String get fLongitude => 'Longitude';

  @override
  String get fOrder => 'Ordre';

  @override
  String get fDeparture => 'Départ';

  @override
  String get fDays => 'Jours';

  @override
  String get fDeadline => 'Date limite d\'inscription';

  @override
  String get fPath => 'Tracé (JSON [[lat,lng],...])';

  @override
  String get fSpecialty => 'Spécialité';

  @override
  String get fPhotoUrl => 'URL de la photo (https)';

  @override
  String get fCover => 'URL de la couverture (https)';

  @override
  String get fQuantity => 'Quantité';

  @override
  String get fRole => 'Rôle';

  @override
  String get fActive => 'Actif';

  @override
  String get fType => 'Type';

  @override
  String get fStatus => 'Statut';

  @override
  String get fLanguage => 'Langue';

  @override
  String get fPassword => 'Mot de passe (facultatif)';

  @override
  String get fPasswordHint => 'Vide = un e-mail d\'invitation est envoyé';

  @override
  String get fResidence => 'Résidence';

  @override
  String get fBuilding => 'Bâtiment';

  @override
  String get fHealthCenter => 'Centre de santé';

  @override
  String get fSchedule => 'Horaires';

  @override
  String get fRoom => 'Chambre';

  @override
  String get fStudent => 'Étudiant';

  @override
  String get fBook => 'Livre';

  @override
  String get fCreated => 'Créé';

  @override
  String get fAddItem => 'Ajouter';

  @override
  String get dStudents => 'Étudiants';

  @override
  String get dActiveAdmins => 'Admins actifs';

  @override
  String get dRestaurants => 'Restaurants';

  @override
  String get dBuses => 'Bus';

  @override
  String get dActivities => 'Activités';

  @override
  String get dBooks => 'Livres';

  @override
  String get dMedicalDocs => 'Documents médicaux';

  @override
  String get dComplaints => 'Réclamations';

  @override
  String get dPending => 'Réclamations en cours';

  @override
  String get dHighPriority => 'Haute priorité';

  @override
  String get dOverdueMedical => 'Révisions médicales en retard';

  @override
  String get dByStatus => 'Réclamations par statut';

  @override
  String get dByCategory => 'Réclamations par service';

  @override
  String get dByPriority => 'Réclamations par priorité';

  @override
  String get dAvgResolution => 'Temps moyen de résolution';

  @override
  String dHours(int n) {
    return '$n h';
  }

  @override
  String get dTopProblems => 'Problèmes les plus fréquents';

  @override
  String get dAvgRating => 'Note moyenne des services';

  @override
  String get dRecurring => 'Problèmes récurrents';

  @override
  String get dLast30 => '30 derniers jours';

  @override
  String get priLow => 'Faible';

  @override
  String get priMedium => 'Moyenne';

  @override
  String get priHigh => 'Haute';

  @override
  String get priCritical => 'Critique';

  @override
  String get mStudents => 'Étudiants';

  @override
  String get mAdmins => 'Administrateurs';

  @override
  String get mMeals => 'Repas';

  @override
  String get mReservations => 'Réservations';

  @override
  String get mScan => 'Contrôle QR';

  @override
  String get mRatings => 'Évaluations';

  @override
  String get mRoutes => 'Lignes';

  @override
  String get mStops => 'Arrêts';

  @override
  String get mSchedules => 'Horaires';

  @override
  String get mBuses => 'Bus';

  @override
  String get mDrivers => 'Chauffeurs';

  @override
  String get mBuildings => 'Bâtiments';

  @override
  String get mRooms => 'Chambres';

  @override
  String get mBooks => 'Livres';

  @override
  String get mBookReservations => 'Réservations de livres';

  @override
  String get mMedicalReview => 'Documents médicaux';

  @override
  String get mBroadcast => 'Envoyer une notification';

  @override
  String get mAudit => 'Journal d\'audit';

  @override
  String get mHealthCheck => 'État du système';

  @override
  String get mResidences => 'Résidences';

  @override
  String get mHealthCenter => 'Centre de santé';

  @override
  String get mResidenceMeals => 'Repas de résidence';

  @override
  String get mResidenceRestaurants => 'Restaurants de résidence';

  @override
  String get mResidenceActivities => 'Activités de résidence';

  @override
  String get gServices => 'Services';

  @override
  String get gPeople => 'Personnes';

  @override
  String get gSystem => 'Système';

  @override
  String get rSuper => 'Super admin';

  @override
  String get rRestaurant => 'Admin restaurant';

  @override
  String get rTransport => 'Admin transport';

  @override
  String get rActivities => 'Admin activités';

  @override
  String get rResidence => 'Admin résidence';

  @override
  String get rHealth => 'Admin santé';

  @override
  String get rLibrary => 'Admin bibliothèque';

  @override
  String get rComplaints => 'Admin réclamations';

  @override
  String get resetPassword => 'Envoyer la réinitialisation';

  @override
  String get resetSent => 'E-mail de réinitialisation envoyé';

  @override
  String get disable => 'Désactiver';

  @override
  String get enable => 'Activer';

  @override
  String get importCsv => 'Importer un CSV';

  @override
  String get importHint =>
      'Colonnes : email, fullName, registrationNumber, faculty, major, studyYear';

  @override
  String importResult(int created, int failed) {
    return '$created créés, $failed en échec';
  }

  @override
  String get sendInvites => 'Envoyer les e-mails d\'invitation';

  @override
  String get chooseCsv => 'Choisir un fichier CSV';

  @override
  String rowsReady(int n) {
    return '$n lignes prêtes';
  }

  @override
  String get startImport => 'Lancer l\'import';

  @override
  String rowLabel(int n) {
    return 'Ligne $n';
  }

  @override
  String get aAction => 'Action';

  @override
  String get aModule => 'Module';

  @override
  String get aAdmin => 'Admin';

  @override
  String get aResource => 'Ressource';

  @override
  String get hcUp => 'Opérationnel';

  @override
  String get hcDown => 'Hors service';

  @override
  String get hcDatabase => 'Base de données';

  @override
  String get hcStorage => 'Stockage de fichiers';

  @override
  String get hcAuth => 'Authentification';

  @override
  String get hcPush => 'Notifications push';

  @override
  String get hcAi => 'Réclamations intelligentes (IA)';

  @override
  String get hcJobs => 'Tâches de fond';

  @override
  String get hcConfigured => 'Configuré';

  @override
  String get hcNotConfigured => 'Non configuré';

  @override
  String hcLatency(int n) {
    return '$n ms';
  }

  @override
  String get bAudience => 'Destinataires';

  @override
  String get bStudents => 'Tous les étudiants';

  @override
  String get bAdmins => 'Tous les administrateurs';

  @override
  String get bResidence => 'Une résidence';

  @override
  String get bTitle => 'Titre';

  @override
  String get bBody => 'Message';

  @override
  String get bSend => 'Envoyer';

  @override
  String bSent(int n) {
    return 'Envoyé à $n personnes';
  }

  @override
  String get ciPriority => 'Priorité';

  @override
  String get ciAssignToMe => 'M\'assigner';

  @override
  String get ciUnassign => 'Retirer l\'assignation';

  @override
  String get ciAssigned => 'Assigné';

  @override
  String get ciInternal => 'Note interne (invisible pour l\'étudiant)';

  @override
  String get ciSendReply => 'Envoyer';

  @override
  String get ciAiSuggestion => 'Analyse intelligente (suggestion)';

  @override
  String get ciSuggestedDept => 'Service suggéré';

  @override
  String get ciTopic => 'Sujet';

  @override
  String get ciRecurring => 'Problème récurrent';

  @override
  String get ciSimilar => 'Réclamations similaires';

  @override
  String get ciSimilarNone => 'Aucune';

  @override
  String get ciDuplicate => 'Doublon possible';

  @override
  String get ciStatus => 'Changer le statut';

  @override
  String get ciStudent => 'Étudiant';

  @override
  String get ciOnlyRecurring => 'Récurrentes seulement';

  @override
  String get ciSortPriority => 'Par priorité';

  @override
  String get ciSortNewest => 'Plus récentes';

  @override
  String get ciSortOldest => 'Plus anciennes';

  @override
  String get ciLocked => 'Défini par un admin : l\'IA ne le modifie plus';

  @override
  String ciSource(String src) {
    return 'Analyse : $src';
  }

  @override
  String get ciAllAssign => 'Tous';

  @override
  String get ciUnassigned => 'Non assignées';

  @override
  String get ciMine => 'Assignées à moi';

  @override
  String get mdOpenFile => 'Ouvrir le document';

  @override
  String get mdStartReview => 'Commencer l\'examen';

  @override
  String get mdApprove => 'Approuver';

  @override
  String get mdReject => 'Refuser';

  @override
  String get mdReason => 'Motif du refus (obligatoire)';

  @override
  String get mdComment => 'Commentaire (facultatif)';

  @override
  String get mdEscalate => 'Escalader au super admin';

  @override
  String get mdEscalated => 'Escaladé';

  @override
  String get mdOverdueOnly => 'En retard seulement';

  @override
  String get mdDeadline => 'Délai d\'examen';

  @override
  String get mdDone => 'Mis à jour';

  @override
  String get mdSensitive =>
      'Données médicales sensibles. Chaque accès est journalisé.';

  @override
  String get scQr => 'Code QR';

  @override
  String get scCheckIn => 'Valider';

  @override
  String get scMeal => 'Repas';

  @override
  String get scActivity => 'Activité';

  @override
  String scOk(String name, String item) {
    return '$name · $item';
  }

  @override
  String get scHint =>
      'Scannez avec un lecteur ou collez le code, puis Entrée.';

  @override
  String get scErrInvalid => 'Code QR invalide';

  @override
  String get scErrUsed => 'Déjà utilisé';

  @override
  String get scErrDay => 'Ce code est pour un autre jour';

  @override
  String get scErrInactive => 'Réservation inactive';

  @override
  String get rtAverage => 'Moyenne';

  @override
  String rtCount(int n) {
    return '$n évaluations';
  }

  @override
  String get acRegistrations => 'Inscriptions';

  @override
  String get acPublish => 'Publier';

  @override
  String get acUnpublish => 'Dépublier';

  @override
  String get bkCollect => 'Marquer comme retiré';

  @override
  String get bkReturn => 'Marquer comme rendu';

  @override
  String get bkRelease => 'Annuler la réservation';

  @override
  String get adminOnlyWeb => 'Administration';

  @override
  String get sortBy => 'Trier par';

  @override
  String get mDashboardReports => 'Tableau de bord';

  @override
  String get scResult => 'Validé';

  @override
  String get ratingsFor => 'Évaluations pour';

  @override
  String get noRatings => 'Aucune évaluation';

  @override
  String get followRoute => 'Suivre cette ligne';

  @override
  String get unfollowRoute => 'Ne plus suivre';

  @override
  String get followHint =>
      'Suivez une ligne dans Transport pour voir son prochain bus ici';

  @override
  String get followingNow => 'Vous suivez cette ligne';

  @override
  String get followStopped => 'Vous ne suivez plus cette ligne';

  @override
  String get nextBusNoSchedule => 'Aucun horaire pour cette ligne';

  @override
  String departsInMin(String time, int n) {
    return '$time (dans $n min)';
  }

  @override
  String departsDays(String time, int n) {
    return '$time (+$n j)';
  }

  @override
  String get changePhoto => 'Changer la photo';

  @override
  String get removePhoto => 'Supprimer la photo';

  @override
  String get fromGallery => 'Choisir dans la galerie';

  @override
  String get fromCamera => 'Prendre une photo';

  @override
  String get photoUpdated => 'Photo mise à jour';

  @override
  String get offlineActionsOff =>
      'Hors ligne : les réservations sont désactivées jusqu\'à la reconnexion';

  @override
  String get biometricUnlock => 'Déverrouillage biométrique';

  @override
  String get biometricReason => 'Déverrouiller Student Guide';

  @override
  String get unlock => 'Déverrouiller';

  @override
  String get biometricUnavailable =>
      'La biométrie n\'est pas disponible sur cet appareil';

  @override
  String get usePassword => 'Utiliser le mot de passe';
}
