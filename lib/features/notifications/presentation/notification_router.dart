import 'package:flutter/material.dart';
import '../../activities/presentation/activities_page.dart';
import '../../complaints/presentation/complaint_detail_page.dart';
import '../../health/presentation/health_page.dart';
import '../../health/presentation/medical_documents_page.dart';
import '../../library/presentation/library_page.dart';
import '../../library/presentation/my_books_page.dart';
import '../../residence/presentation/residence_page.dart';
import '../../restaurant/presentation/reservations_page.dart';
import '../../restaurant/presentation/restaurant_page.dart';
import '../../transport/presentation/transport_page.dart';
import '../data/notification_repository.dart';

/// Opens the screen a notification is about. Unknown / system notifications just stay in the list.
void openNotificationTarget(BuildContext context, AppNotification n) {
  Widget? page;
  switch (n.type) {
    case 'complaints':
      final id = n.data['complaintId'];
      if (id is String) page = ComplaintDetailPage(id: id);
    case 'restaurant':
      page = n.data['reservationId'] != null ? const ReservationsPage() : const RestaurantPage();
    case 'library':
      page = n.data['bookId'] != null ? const MyBooksPage() : const LibraryPage();
    case 'health':
      page = n.data['documentId'] != null ? const MedicalDocumentsPage() : const HealthPage();
    case 'activities':
      page = const ActivitiesPage();
    case 'transport':
      page = const TransportPage();
    case 'residence':
      page = const ResidencePage();
  }
  if (page != null) Navigator.push(context, MaterialPageRoute(builder: (_) => page!));
}
