import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/error_text.dart';
import '../../l10n/app_localizations.dart';
import '../activities/presentation/activity_sheet.dart' show activityTypeLabel;
import 'data/admin_api.dart';
import 'framework/helpers.dart';
import 'framework/resource_config.dart';
import 'pages/students_tools.dart';

typedef R = ResourceConfig;
const _text = FieldType.text;

Future<void> _toast(BuildContext c, Future<dynamic> Function() f, String ok) async {
  final t = AppLocalizations.of(c)!;
  final m = ScaffoldMessenger.of(c);
  try { await f(); m.showSnackBar(SnackBar(content: Text(ok))); } catch (e) { m.showSnackBar(SnackBar(content: Text(errorText(t, e)))); }
}

// ---------------------------------------------------------------- restaurant
final _restaurantFields = <FieldSpec>[
  FieldSpec('name', (t) => t.fName, _text, required: true),
  FieldSpec('location', (t) => t.locationLabel, _text),
  FieldSpec('is_open', (t) => t.fIsOpen, FieldType.boolean, initial: true),
];
final restaurantsConfig = R(
  title: (t) => t.restaurant, endpoint: '/restaurants', defaultSort: 'name', defaultOrder: 'asc',
  filters: [FilterSpec('is_open', (t) => t.fIsOpen, FilterType.select, options: yesNoOptions())],
  columns: [
    ColumnSpec((t) => t.fName, (r, t) => cell(r['name']), sortKey: 'name'),
    ColumnSpec((t) => t.locationLabel, (r, t) => cell(r['location'])),
    ColumnSpec((t) => t.fIsOpen, (r, t) => yesNo(r['is_open'], t)),
  ],
  fields: _restaurantFields,
);
// residence admins create restaurants that belong to a residence
final residenceRestaurantsConfig = R(
  title: (t) => t.mResidenceRestaurants, endpoint: '/restaurants', defaultSort: 'name', defaultOrder: 'asc',
  columns: [
    ColumnSpec((t) => t.fName, (r, t) => cell(r['name']), sortKey: 'name'),
    ColumnSpec((t) => t.fResidence, (r, t) => r['residence_id'] == null ? '—' : '✓'),
    ColumnSpec((t) => t.fIsOpen, (r, t) => yesNo(r['is_open'], t)),
  ],
  fields: [FieldSpec('residence_id', (t) => t.fResidence, FieldType.ref, required: true, refEndpoint: '/residences'), ..._restaurantFields],
);

final mealsConfig = R(
  title: (t) => t.mMeals, endpoint: '/meals', defaultSort: 'meal_date', defaultOrder: 'desc',
  filters: [
    FilterSpec('restaurant_id', (t) => t.fRestaurant, FilterType.ref, refEndpoint: '/restaurants'),
    FilterSpec('meal_date', (t) => t.fDate, FilterType.date),
    FilterSpec('type', (t) => t.fType, FilterType.select, options: [Opt('breakfast', (t) => t.breakfast), Opt('lunch', (t) => t.lunch), Opt('dinner', (t) => t.dinner)]),
  ],
  columns: [
    ColumnSpec((t) => t.fDate, (r, t) => cell(r['meal_date']), sortKey: 'meal_date'),
    ColumnSpec((t) => t.fTime, (r, t) => hm(r['meal_time'])),
    ColumnSpec((t) => t.fName, (r, t) => cell(r['name']), sortKey: 'name'),
    ColumnSpec((t) => t.fRestaurant, (r, t) => cell(dig(r, 'restaurants.name'))),
    ColumnSpec((t) => t.fType, (r, t) => switch (r['type']) { 'breakfast' => t.breakfast, 'dinner' => t.dinner, _ => t.lunch }),
    ColumnSpec((t) => t.fAvailable, (r, t) => yesNo(r['is_available'], t)),
  ],
  fields: [
    FieldSpec('restaurant_id', (t) => t.fRestaurant, FieldType.ref, required: true, refEndpoint: '/restaurants'),
    FieldSpec('meal_date', (t) => t.fDate, FieldType.date, required: true),
    FieldSpec('meal_time', (t) => t.fTime, FieldType.time, required: true, initial: '12:00'),
    FieldSpec('type', (t) => t.fType, FieldType.select, required: true, initial: 'lunch', options: [Opt('breakfast', (t) => t.breakfast), Opt('lunch', (t) => t.lunch), Opt('dinner', (t) => t.dinner)]),
    FieldSpec('name', (t) => t.fName, _text, required: true),
    FieldSpec('description', (t) => t.fDescription, FieldType.multiline),
    FieldSpec('ingredients', (t) => t.ingredients, FieldType.stringList),
    FieldSpec('allergens', (t) => t.allergens, FieldType.stringList),
    FieldSpec('image_url', (t) => t.fImageUrl, _text),
    FieldSpec('capacity', (t) => t.fCapacity, FieldType.integer),
    FieldSpec('is_available', (t) => t.fAvailable, FieldType.boolean, initial: true),
  ],
);

final reservationsConfig = R(
  title: (t) => t.mReservations, endpoint: '/reservations', hasSearch: false, canCreate: false, canEdit: false, canDelete: false,
  filters: [FilterSpec('date', (t) => t.fDate, FilterType.date)],
  columns: [
    ColumnSpec((t) => t.fDate, (r, t) => cell(dig(r, 'meals.meal_date'))),
    ColumnSpec((t) => t.mMeals, (r, t) => cell(dig(r, 'meals.name'))),
    ColumnSpec((t) => t.fStudent, (r, t) => '${cell(dig(r, 'students.users.full_name'))} · ${cell(dig(r, 'students.registration_number'))}'),
    ColumnSpec((t) => t.fStatus, (r, t) => switch (r['status']) { 'RESERVED' => t.statusReserved, 'ATTENDED' => t.attended, _ => t.cancelled }, chip: true),
    ColumnSpec((t) => t.scCheckIn, (r, t) => stamp(r['scanned_at'], null)),
  ],
);

// ---------------------------------------------------------------- transport
final routesConfig = R(
  title: (t) => t.mRoutes, endpoint: '/routes', defaultSort: 'name', defaultOrder: 'asc',
  filters: [FilterSpec('is_active', (t) => t.fActive, FilterType.select, options: yesNoOptions())],
  columns: [
    ColumnSpec((t) => t.fName, (r, t) => cell(r['name']), sortKey: 'name'),
    ColumnSpec((t) => t.fActive, (r, t) => yesNo(r['is_active'], t)),
    ColumnSpec((t) => t.fPath, (r, t) => r['path'] is List ? '${(r['path'] as List).length} pts' : '—'),
  ],
  fields: [
    FieldSpec('name', (t) => t.fName, _text, required: true),
    FieldSpec('path', (t) => t.fPath, FieldType.json),
    FieldSpec('is_active', (t) => t.fActive, FieldType.boolean, initial: true),
  ],
);
final stopsConfig = R(
  title: (t) => t.mStops, endpoint: '/stops', defaultSort: 'stop_order', defaultOrder: 'asc',
  filters: [FilterSpec('route_id', (t) => t.fRoute, FilterType.ref, refEndpoint: '/routes')],
  columns: [
    ColumnSpec((t) => t.fOrder, (r, t) => cell(r['stop_order']), sortKey: 'stop_order'),
    ColumnSpec((t) => t.fName, (r, t) => cell(r['name']), sortKey: 'name'),
    ColumnSpec((t) => t.fLatitude, (r, t) => cell(r['latitude'])),
    ColumnSpec((t) => t.fLongitude, (r, t) => cell(r['longitude'])),
  ],
  fields: [
    FieldSpec('route_id', (t) => t.fRoute, FieldType.ref, required: true, refEndpoint: '/routes'),
    FieldSpec('name', (t) => t.fName, _text, required: true),
    FieldSpec('latitude', (t) => t.fLatitude, FieldType.number, required: true),
    FieldSpec('longitude', (t) => t.fLongitude, FieldType.number, required: true),
    FieldSpec('stop_order', (t) => t.fOrder, FieldType.integer, required: true),
  ],
);
final schedulesConfig = R(
  title: (t) => t.mSchedules, endpoint: '/schedules', hasSearch: false, defaultSort: 'departure_time', defaultOrder: 'asc',
  filters: [FilterSpec('route_id', (t) => t.fRoute, FilterType.ref, refEndpoint: '/routes')],
  columns: [
    ColumnSpec((t) => t.fDeparture, (r, t) => hm(r['departure_time']), sortKey: 'departure_time'),
    ColumnSpec((t) => t.fDays, (r, t) => (r['days_of_week'] as List? ?? const []).join(' ')),
  ],
  fields: [
    FieldSpec('route_id', (t) => t.fRoute, FieldType.ref, required: true, refEndpoint: '/routes'),
    FieldSpec('departure_time', (t) => t.fDeparture, FieldType.time, required: true),
    FieldSpec('days_of_week', (t) => t.fDays, FieldType.weekdays),
    FieldSpec('stop_id', (t) => t.mStops, FieldType.ref, refEndpoint: '/stops'),
  ],
);
final driversConfig = R(
  title: (t) => t.mDrivers, endpoint: '/drivers', defaultSort: 'full_name', defaultOrder: 'asc',
  columns: [
    ColumnSpec((t) => t.fName, (r, t) => cell(r['full_name']), sortKey: 'full_name'),
    ColumnSpec((t) => t.fPhone, (r, t) => cell(r['phone'])),
    ColumnSpec((t) => t.fLicense, (r, t) => cell(r['license_number'])),
  ],
  fields: [
    FieldSpec('full_name', (t) => t.fName, _text, required: true),
    FieldSpec('phone', (t) => t.fPhone, _text),
    FieldSpec('license_number', (t) => t.fLicense, _text),
  ],
);
final busesConfig = R(
  title: (t) => t.mBuses, endpoint: '/buses', defaultSort: 'plate_number', defaultOrder: 'asc',
  filters: [
    FilterSpec('route_id', (t) => t.fRoute, FilterType.ref, refEndpoint: '/routes'),
    FilterSpec('status', (t) => t.fStatus, FilterType.select, options: [Opt('active', (t) => t.fActive), Opt('inactive', (t) => t.disable), Opt('maintenance', (t) => 'Maintenance')]),
  ],
  columns: [
    ColumnSpec((t) => t.plate, (r, t) => cell(r['plate_number']), sortKey: 'plate_number'),
    ColumnSpec((t) => t.fRoute, (r, t) => cell(dig(r, 'routes.name'))),
    ColumnSpec((t) => t.fDriver, (r, t) => cell(dig(r, 'drivers.full_name'))),
    ColumnSpec((t) => t.fStatus, (r, t) => cell(r['status']), chip: true),
    ColumnSpec((t) => t.fCapacity, (r, t) => cell(r['capacity'])),
  ],
  fields: [
    FieldSpec('plate_number', (t) => t.plate, _text, required: true),
    FieldSpec('capacity', (t) => t.fCapacity, FieldType.integer),
    FieldSpec('route_id', (t) => t.fRoute, FieldType.ref, refEndpoint: '/routes'),
    FieldSpec('driver_id', (t) => t.fDriver, FieldType.ref, refEndpoint: '/drivers', refLabel: 'full_name'),
    FieldSpec('status', (t) => t.fStatus, FieldType.select, initial: 'inactive', options: [Opt('active', (t) => t.fActive), Opt('inactive', (t) => t.disable), Opt('maintenance', (t) => 'Maintenance')]),
  ],
);

// ---------------------------------------------------------------- activities
const _activityTypes = ['cultural', 'sports', 'workshop', 'conference', 'competition', 'other'];
List<FieldSpec> _activityFields({bool residence = false}) => [
      if (residence) FieldSpec('residence_id', (t) => t.fResidence, FieldType.ref, required: true, refEndpoint: '/residences'),
      FieldSpec('title', (t) => t.fTitle, _text, required: true),
      FieldSpec('description', (t) => t.fDescription, FieldType.multiline),
      FieldSpec('type', (t) => t.fType, FieldType.select, required: true, initial: 'other', options: [for (final x in _activityTypes) Opt(x, (t) => activityTypeLabel(t, x))]),
      FieldSpec('image_url', (t) => t.fImageUrl, _text),
      FieldSpec('activity_date', (t) => t.fDate, FieldType.date, required: true),
      FieldSpec('start_time', (t) => t.fStart, FieldType.time, required: true),
      FieldSpec('end_time', (t) => t.fEnd, FieldType.time),
      FieldSpec('location', (t) => t.locationLabel, _text),
      FieldSpec('capacity', (t) => t.fCapacity, FieldType.integer),
      FieldSpec('registration_deadline', (t) => t.fDeadline, FieldType.datetime),
      FieldSpec('is_published', (t) => t.fPublished, FieldType.boolean),
    ];

R _activities(String title(AppLocalizations t), {required bool residence}) => R(
      title: title, endpoint: '/activities', hasSearch: true, canDelete: true,
      extraQuery: const {},
      filters: [
        FilterSpec('type', (t) => t.fType, FilterType.select, options: [for (final x in _activityTypes) Opt(x, (t) => activityTypeLabel(t, x))]),
        FilterSpec('past', (t) => t.past, FilterType.select, options: [Opt('true', (t) => t.past)]),
      ],
      columns: [
        ColumnSpec((t) => t.fDate, (r, t) => cell(r['activity_date'])),
        ColumnSpec((t) => t.fTime, (r, t) => hm(r['start_time'])),
        ColumnSpec((t) => t.fTitle, (r, t) => cell(r['title'])),
        ColumnSpec((t) => t.fType, (r, t) => activityTypeLabel(t, '${r['type']}')),
        ColumnSpec((t) => t.fCapacity, (r, t) => '${cell(r['registeredCount'])}/${cell(r['capacity'])}'),
        ColumnSpec((t) => t.fPublished, (r, t) => yesNo(r['is_published'], t)),
      ],
      fields: _activityFields(residence: residence),
      toInitial: (r) => r,
      rowActions: [
        RowAction(Icons.publish, (t) => t.acPublish, (c, ref, row) => _toast(c, () => ref.read(adminApiProvider).patch('/activities/${row['id']}/publish', body: {'published': true}), '✓'), visible: (r) => r['is_published'] != true),
        RowAction(Icons.unpublished_outlined, (t) => t.acUnpublish, (c, ref, row) => _toast(c, () => ref.read(adminApiProvider).patch('/activities/${row['id']}/publish', body: {'published': false}), '✓'), visible: (r) => r['is_published'] == true),
        RowAction(Icons.groups_outlined, (t) => t.acRegistrations, (c, ref, row) => showDialog(context: c, builder: (_) => _RegistrationsDialog(activityId: '${row['id']}', title: '${row['title']}'))),
      ],
    );
final activitiesConfig = _activities((t) => t.activities, residence: false);
final residenceActivitiesConfig = _activities((t) => t.mResidenceActivities, residence: true);

class _RegistrationsDialog extends ConsumerWidget {
  const _RegistrationsDialog({required this.activityId, required this.title});
  final String activityId, title;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: 520, height: 420,
        child: FutureBuilder<PageData>(
          future: ref.read(adminApiProvider).list('/activities/$activityId/registrations', {'pageSize': 50}),
          builder: (_, s) {
            if (!s.hasData) return const Center(child: CircularProgressIndicator());
            if (s.data!.items.isEmpty) return Center(child: Text(t.noData));
            return ListView(children: [
              for (final r in s.data!.items)
                ListTile(dense: true, title: Text(cell(dig(r, 'students.users.full_name'))), subtitle: Text(cell(dig(r, 'students.registration_number'))),
                    trailing: Text(switch (r['status']) { 'ATTENDED' => t.attended, 'CANCELLED' => t.cancelled, _ => t.statusRegistered })),
            ]);
          },
        ),
      ),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(t.close))],
    );
  }
}

// ---------------------------------------------------------------- residence
final residencesConfig = R(
  title: (t) => t.mResidences, endpoint: '/residences', defaultSort: 'name', defaultOrder: 'asc',
  columns: [
    ColumnSpec((t) => t.fName, (r, t) => cell(r['name']), sortKey: 'name'),
    ColumnSpec((t) => t.locationLabel, (r, t) => cell(r['address'])),
    ColumnSpec((t) => t.servicesLabel, (r, t) => (r['services'] as List? ?? const []).join(', ')),
  ],
  fields: [
    FieldSpec('name', (t) => t.fName, _text, required: true),
    FieldSpec('address', (t) => t.locationLabel, _text),
    FieldSpec('services', (t) => t.servicesLabel, FieldType.stringList),
  ],
);
final buildingsConfig = R(
  title: (t) => t.mBuildings, endpoint: '/residences/buildings', hasSearch: false, defaultSort: 'name', defaultOrder: 'asc',
  filters: [FilterSpec('residence_id', (t) => t.fResidence, FilterType.ref, refEndpoint: '/residences')],
  columns: [ColumnSpec((t) => t.fName, (r, t) => cell(r['name']), sortKey: 'name')],
  fields: [
    FieldSpec('residence_id', (t) => t.fResidence, FieldType.ref, required: true, refEndpoint: '/residences'),
    FieldSpec('name', (t) => t.fName, _text, required: true),
  ],
);
final roomsConfig = R(
  title: (t) => t.mRooms, endpoint: '/residences/rooms', hasSearch: false, defaultSort: 'room_number', defaultOrder: 'asc',
  filters: [FilterSpec('building_id', (t) => t.fBuilding, FilterType.ref, refEndpoint: '/residences/buildings')],
  columns: [
    ColumnSpec((t) => t.roomLabel, (r, t) => cell(r['room_number']), sortKey: 'room_number'),
    ColumnSpec((t) => t.fCapacity, (r, t) => cell(r['capacity'])),
  ],
  fields: [
    FieldSpec('building_id', (t) => t.fBuilding, FieldType.ref, required: true, refEndpoint: '/residences/buildings'),
    FieldSpec('room_number', (t) => t.roomLabel, _text, required: true),
    FieldSpec('capacity', (t) => t.fCapacity, FieldType.integer, initial: 2),
  ],
);

// ---------------------------------------------------------------- health
final _hours = FieldSpec('opening_hours', (t) => t.openingHours, FieldType.hours);
final healthCenterConfig = R(
  title: (t) => t.mHealthCenter, endpoint: '/health', defaultSort: 'name', defaultOrder: 'asc',
  columns: [
    ColumnSpec((t) => t.fName, (r, t) => cell(r['name']), sortKey: 'name'),
    ColumnSpec((t) => t.locationLabel, (r, t) => cell(r['location'])),
    ColumnSpec((t) => t.fIsOpen, (r, t) => yesNo(r['is_open'], t)),
  ],
  fields: [
    FieldSpec('name', (t) => t.fName, _text, required: true),
    FieldSpec('location', (t) => t.locationLabel, _text),
    _hours,
    FieldSpec('is_open', (t) => t.fIsOpen, FieldType.boolean, initial: true),
  ],
);
final doctorsConfig = R(
  title: (t) => t.doctors, endpoint: '/doctors', defaultSort: 'full_name', defaultOrder: 'asc',
  filters: [FilterSpec('health_center_id', (t) => t.fHealthCenter, FilterType.ref, refEndpoint: '/health')],
  columns: [
    ColumnSpec((t) => t.fName, (r, t) => cell(r['full_name']), sortKey: 'full_name'),
    ColumnSpec((t) => t.fSpecialty, (r, t) => cell(r['specialty'])),
    ColumnSpec((t) => t.office, (r, t) => cell(r['office'])),
    ColumnSpec((t) => t.fAvailable, (r, t) => yesNo(r['is_available'], t)),
  ],
  fields: [
    FieldSpec('health_center_id', (t) => t.fHealthCenter, FieldType.ref, required: true, refEndpoint: '/health'),
    FieldSpec('full_name', (t) => t.fName, _text, required: true),
    FieldSpec('specialty', (t) => t.fSpecialty, _text),
    FieldSpec('photo_url', (t) => t.fPhotoUrl, _text),
    FieldSpec('office', (t) => t.office, _text),
    FieldSpec('schedule', (t) => t.fSchedule, FieldType.hours),
    FieldSpec('is_available', (t) => t.fAvailable, FieldType.boolean, initial: true),
  ],
);

// ---------------------------------------------------------------- library
final booksConfig = R(
  title: (t) => t.mBooks, endpoint: '/books', defaultSort: null,
  filters: [FilterSpec('available', (t) => t.availableOnly, FilterType.select, options: [Opt('true', (t) => t.yes)])],
  columns: [
    ColumnSpec((t) => t.fTitle, (r, t) => cell(r['title'])),
    ColumnSpec((t) => t.author, (r, t) => cell(r['author'])),
    ColumnSpec((t) => t.isbn, (r, t) => cell(r['isbn'])),
    ColumnSpec((t) => t.category, (r, t) => cell(r['category'])),
    ColumnSpec((t) => t.fQuantity, (r, t) => '${cell(r['available_quantity'])}/${cell(r['quantity'])}'),
  ],
  fields: [
    FieldSpec('title', (t) => t.fTitle, _text, required: true),
    FieldSpec('author', (t) => t.author, _text, required: true),
    FieldSpec('isbn', (t) => t.isbn, _text),
    FieldSpec('category', (t) => t.category, _text),
    FieldSpec('description', (t) => t.fDescription, FieldType.multiline),
    FieldSpec('cover_url', (t) => t.fCover, _text),
    FieldSpec('quantity', (t) => t.fQuantity, FieldType.integer, required: true, initial: 1),
    FieldSpec('location', (t) => t.locationLabel, _text),
  ],
);
Future<void> _transition(BuildContext c, WidgetRef ref, Json row, String action) =>
    _toast(c, () => ref.read(adminApiProvider).patch('/books/reservations/${row['id']}', body: {'action': action}), '✓');
final bookReservationsConfig = R(
  title: (t) => t.mBookReservations, endpoint: '/books/reservations', hasSearch: false, canCreate: false, canEdit: false, canDelete: false,
  filters: [FilterSpec('status', (t) => t.fStatus, FilterType.select, options: [
    Opt('RESERVED', (t) => t.statusReserved), Opt('ATTENDED', (t) => t.statusCollected), Opt('RETURNED', (t) => t.statusReturned), Opt('CANCELLED', (t) => t.cancelled)])],
  columns: [
    ColumnSpec((t) => t.fBook, (r, t) => cell(dig(r, 'books.title'))),
    ColumnSpec((t) => t.fStudent, (r, t) => '${cell(dig(r, 'students.users.full_name'))} · ${cell(dig(r, 'students.registration_number'))}'),
    ColumnSpec((t) => t.fStatus, (r, t) => switch (r['status']) { 'RESERVED' => t.statusReserved, 'ATTENDED' => t.statusCollected, 'RETURNED' => t.statusReturned, _ => t.cancelled }, chip: true),
    ColumnSpec((t) => t.fCreated, (r, t) => stamp(r['created_at'], null)),
  ],
  rowActions: [
    RowAction(Icons.outbox, (t) => t.bkCollect, (c, ref, row) => _transition(c, ref, row, 'collect'), visible: (r) => r['status'] == 'RESERVED'),
    RowAction(Icons.move_to_inbox, (t) => t.bkReturn, (c, ref, row) => _transition(c, ref, row, 'return'), visible: (r) => r['status'] == 'ATTENDED'),
    RowAction(Icons.cancel_outlined, (t) => t.bkRelease, (c, ref, row) => _transition(c, ref, row, 'cancel'), visible: (r) => r['status'] == 'RESERVED'),
  ],
);

// ---------------------------------------------------------------- super admin
final adminsConfig = R(
  title: (t) => t.mAdmins, endpoint: '/admin/admins', patchUpdate: true,
  filters: [
    FilterSpec('role', (t) => t.fRole, FilterType.select, options: roleOptions()),
    FilterSpec('active', (t) => t.fActive, FilterType.select, options: yesNoOptions()),
  ],
  columns: [
    ColumnSpec((t) => t.fName, (r, t) => cell(r['full_name'])),
    ColumnSpec((t) => 'E-mail', (r, t) => cell(r['email'])),
    ColumnSpec((t) => t.fRole, (r, t) => roleLabel(t, r['role'] as String?), chip: true),
    ColumnSpec((t) => t.fActive, (r, t) => yesNo(r['is_active'], t)),
    ColumnSpec((t) => t.fCreated, (r, t) => stamp(r['created_at'], null)),
  ],
  fields: [
    FieldSpec('email', (t) => 'E-mail', _text, required: true, createOnly: true),
    FieldSpec('fullName', (t) => t.fName, _text, required: true),
    FieldSpec('role', (t) => t.fRole, FieldType.select, required: true, options: roleOptions()),
    FieldSpec('language', (t) => t.fLanguage, FieldType.select, createOnly: true, initial: 'ar', options: languageOptions()),
    FieldSpec('password', (t) => t.fPassword, _text, createOnly: true, hint: (t) => t.fPasswordHint),
    FieldSpec('isActive', (t) => t.fActive, FieldType.boolean, editOnly: true),
  ],
  toInitial: (r) => {'fullName': r['full_name'], 'role': r['role'], 'isActive': r['is_active']},
  rowActions: [
    RowAction(Icons.mail_lock_outlined, (t) => t.resetPassword, (c, ref, row) => _toast(c, () => ref.read(adminApiProvider).post('/admin/admins/${row['id']}/reset-password'), AppLocalizations.of(c)!.resetSent)),
  ],
);

R _studentsConfig() => R(
      title: (t) => t.mStudents, endpoint: '/admin/students', patchUpdate: true, canDelete: false,
      filters: [FilterSpec('active', (t) => t.fActive, FilterType.select, options: yesNoOptions()), FilterSpec('residenceId', (t) => t.fResidence, FilterType.ref, refEndpoint: '/residences')],
      headerActions: [HeaderAction(Icons.upload_file, (t) => t.importCsv, importStudentsAction)],
      columns: [
        ColumnSpec((t) => t.fName, (r, t) => cell(r['full_name'])),
        ColumnSpec((t) => t.registrationNumber, (r, t) => cell(dig(r, 'students.registration_number'))),
        ColumnSpec((t) => 'E-mail', (r, t) => cell(r['email'])),
        ColumnSpec((t) => t.faculty, (r, t) => cell(dig(r, 'students.faculty'))),
        ColumnSpec((t) => t.studyYear, (r, t) => cell(dig(r, 'students.study_year'))),
        ColumnSpec((t) => t.fActive, (r, t) => yesNo(r['is_active'], t)),
      ],
      fields: [
        FieldSpec('email', (t) => 'E-mail', _text, required: true, createOnly: true),
        FieldSpec('fullName', (t) => t.fName, _text, required: true),
        FieldSpec('registrationNumber', (t) => t.registrationNumber, _text, required: true, createOnly: true),
        FieldSpec('faculty', (t) => t.faculty, _text),
        FieldSpec('major', (t) => t.major, _text),
        FieldSpec('studyYear', (t) => t.studyYear, FieldType.integer),
        FieldSpec('language', (t) => t.fLanguage, FieldType.select, createOnly: true, initial: 'ar', options: languageOptions()),
        FieldSpec('isActive', (t) => t.fActive, FieldType.boolean, editOnly: true),
      ],
      toInitial: (r) => {'fullName': r['full_name'], 'faculty': dig(r, 'students.faculty'), 'major': dig(r, 'students.major'), 'studyYear': dig(r, 'students.study_year'), 'isActive': r['is_active']},
    );
final studentsConfig = _studentsConfig();

final auditConfig = R(
  title: (t) => t.mAudit, endpoint: '/audit-logs', searchParam: 'action', canCreate: false, canEdit: false, canDelete: false,
  filters: [
    FilterSpec('module', (t) => t.aModule, FilterType.select, options: [for (final m in ['restaurant', 'transport', 'activities', 'residence', 'health', 'library', 'complaints', 'admin']) Opt(m, (t) => m)]),
    FilterSpec('from', (t) => '≥ ${t.fDate}', FilterType.date, transform: (d) => '${d}T00:00:00Z'),
    FilterSpec('to', (t) => '≤ ${t.fDate}', FilterType.date, transform: (d) => '${d}T23:59:59Z'),
  ],
  columns: [
    ColumnSpec((t) => t.fDate, (r, t) => stamp(r['created_at'], null)),
    ColumnSpec((t) => t.aAdmin, (r, t) => cell(dig(r, 'users.full_name'))),
    ColumnSpec((t) => t.fRole, (r, t) => roleLabel(t, dig(r, 'users.role') as String?)),
    ColumnSpec((t) => t.aAction, (r, t) => cell(r['action'])),
    ColumnSpec((t) => t.aModule, (r, t) => cell(r['module']), chip: true),
    ColumnSpec((t) => t.aResource, (r, t) => cell(r['resource_id'])),
  ],
);
