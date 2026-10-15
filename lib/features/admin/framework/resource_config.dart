import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';
import '../data/admin_api.dart';

typedef L = String Function(AppLocalizations t);

enum FieldType { text, multiline, integer, number, boolean, date, time, datetime, select, ref, stringList, hours, weekdays, json }

class Opt {
  const Opt(this.value, this.label);
  final String value;
  final L label;
}

class FieldSpec {
  const FieldSpec(this.key, this.label, this.type,
      {this.required = false, this.options = const [], this.refEndpoint, this.refLabel = 'name', this.createOnly = false, this.editOnly = false, this.initial, this.hint});
  final String key;
  final L label;
  final FieldType type;
  final bool required, createOnly, editOnly;
  final List<Opt> options;
  final String? refEndpoint, refLabel;
  final dynamic initial;
  final L? hint;
}

class ColumnSpec {
  const ColumnSpec(this.label, this.value, {this.sortKey, this.chip = false});
  final L label;
  final String Function(Json row, AppLocalizations t) value;
  final String? sortKey;
  final bool chip;
}

enum FilterType { select, ref, date }

class FilterSpec {
  const FilterSpec(this.key, this.label, this.type, {this.options = const [], this.refEndpoint, this.refLabel = 'name', this.transform});
  final String key;
  final L label;
  final FilterType type;
  final List<Opt> options;
  final String? refEndpoint, refLabel;
  final String Function(String value)? transform;   // e.g. date -> ISO datetime for the API
}

class RowAction {
  const RowAction(this.icon, this.label, this.run, {this.visible});
  final IconData icon;
  final L label;
  final Future<void> Function(BuildContext context, WidgetRef ref, Json row) run;
  final bool Function(Json row)? visible;
}

class HeaderAction {
  const HeaderAction(this.icon, this.label, this.run);
  final IconData icon;
  final L label;
  final Future<void> Function(BuildContext context, WidgetRef ref) run;
}

/// Describes one admin-managed resource: table columns, filters, create/edit form and extra actions.
/// The backend decides what each role may do; the UI only hides what would be refused anyway.
class ResourceConfig {
  const ResourceConfig({
    required this.title, required this.endpoint, required this.columns,
    this.fields = const [], this.filters = const [], this.searchParam = 'search', this.hasSearch = true,
    this.canCreate = true, this.canEdit = true, this.canDelete = true, this.patchUpdate = false,
    this.rowActions = const [], this.headerActions = const [], this.toInitial, this.onRowTap,
    this.extraQuery = const {}, this.defaultSort, this.defaultOrder = 'desc', this.banner,
  });
  final L title;
  final String endpoint;
  final List<ColumnSpec> columns;
  final List<FieldSpec> fields;
  final List<FilterSpec> filters;
  final String searchParam;
  final bool hasSearch, canCreate, canEdit, canDelete, patchUpdate;
  final List<RowAction> rowActions;
  final List<HeaderAction> headerActions;
  final Json Function(Json row)? toInitial;
  final Future<void> Function(BuildContext context, WidgetRef ref, Json row)? onRowTap;
  final Json extraQuery;
  final String? defaultSort;
  final String defaultOrder;
  final L? banner;
}
