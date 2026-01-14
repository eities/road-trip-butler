/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'stop.dart' as _i2;
import 'package:road_trip_butler_server/src/generated/protocol.dart' as _i3;

abstract class Trip implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Trip._({
    this.id,
    required this.description,
    required this.startAddress,
    required this.endAddress,
    required this.departureTime,
    required this.personality,
    required this.polyline,
    this.preferences,
    this.totalDurationSeconds,
    this.stops,
  });

  factory Trip({
    int? id,
    required String description,
    required String startAddress,
    required String endAddress,
    required DateTime departureTime,
    required String personality,
    required String polyline,
    String? preferences,
    int? totalDurationSeconds,
    List<_i2.Stop>? stops,
  }) = _TripImpl;

  factory Trip.fromJson(Map<String, dynamic> jsonSerialization) {
    return Trip(
      id: jsonSerialization['id'] as int?,
      description: jsonSerialization['description'] as String,
      startAddress: jsonSerialization['startAddress'] as String,
      endAddress: jsonSerialization['endAddress'] as String,
      departureTime: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['departureTime'],
      ),
      personality: jsonSerialization['personality'] as String,
      polyline: jsonSerialization['polyline'] as String,
      preferences: jsonSerialization['preferences'] as String?,
      totalDurationSeconds: jsonSerialization['totalDurationSeconds'] as int?,
      stops: jsonSerialization['stops'] == null
          ? null
          : _i3.Protocol().deserialize<List<_i2.Stop>>(
              jsonSerialization['stops'],
            ),
    );
  }

  static final t = TripTable();

  static const db = TripRepository._();

  @override
  int? id;

  String description;

  String startAddress;

  String endAddress;

  DateTime departureTime;

  String personality;

  String polyline;

  String? preferences;

  int? totalDurationSeconds;

  List<_i2.Stop>? stops;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Trip]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Trip copyWith({
    int? id,
    String? description,
    String? startAddress,
    String? endAddress,
    DateTime? departureTime,
    String? personality,
    String? polyline,
    String? preferences,
    int? totalDurationSeconds,
    List<_i2.Stop>? stops,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Trip',
      if (id != null) 'id': id,
      'description': description,
      'startAddress': startAddress,
      'endAddress': endAddress,
      'departureTime': departureTime.toJson(),
      'personality': personality,
      'polyline': polyline,
      if (preferences != null) 'preferences': preferences,
      if (totalDurationSeconds != null)
        'totalDurationSeconds': totalDurationSeconds,
      if (stops != null) 'stops': stops?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Trip',
      if (id != null) 'id': id,
      'description': description,
      'startAddress': startAddress,
      'endAddress': endAddress,
      'departureTime': departureTime.toJson(),
      'personality': personality,
      'polyline': polyline,
      if (preferences != null) 'preferences': preferences,
      if (totalDurationSeconds != null)
        'totalDurationSeconds': totalDurationSeconds,
      if (stops != null)
        'stops': stops?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static TripInclude include({_i2.StopIncludeList? stops}) {
    return TripInclude._(stops: stops);
  }

  static TripIncludeList includeList({
    _i1.WhereExpressionBuilder<TripTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TripTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TripTable>? orderByList,
    TripInclude? include,
  }) {
    return TripIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Trip.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Trip.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TripImpl extends Trip {
  _TripImpl({
    int? id,
    required String description,
    required String startAddress,
    required String endAddress,
    required DateTime departureTime,
    required String personality,
    required String polyline,
    String? preferences,
    int? totalDurationSeconds,
    List<_i2.Stop>? stops,
  }) : super._(
         id: id,
         description: description,
         startAddress: startAddress,
         endAddress: endAddress,
         departureTime: departureTime,
         personality: personality,
         polyline: polyline,
         preferences: preferences,
         totalDurationSeconds: totalDurationSeconds,
         stops: stops,
       );

  /// Returns a shallow copy of this [Trip]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Trip copyWith({
    Object? id = _Undefined,
    String? description,
    String? startAddress,
    String? endAddress,
    DateTime? departureTime,
    String? personality,
    String? polyline,
    Object? preferences = _Undefined,
    Object? totalDurationSeconds = _Undefined,
    Object? stops = _Undefined,
  }) {
    return Trip(
      id: id is int? ? id : this.id,
      description: description ?? this.description,
      startAddress: startAddress ?? this.startAddress,
      endAddress: endAddress ?? this.endAddress,
      departureTime: departureTime ?? this.departureTime,
      personality: personality ?? this.personality,
      polyline: polyline ?? this.polyline,
      preferences: preferences is String? ? preferences : this.preferences,
      totalDurationSeconds: totalDurationSeconds is int?
          ? totalDurationSeconds
          : this.totalDurationSeconds,
      stops: stops is List<_i2.Stop>?
          ? stops
          : this.stops?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class TripUpdateTable extends _i1.UpdateTable<TripTable> {
  TripUpdateTable(super.table);

  _i1.ColumnValue<String, String> description(String value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> startAddress(String value) => _i1.ColumnValue(
    table.startAddress,
    value,
  );

  _i1.ColumnValue<String, String> endAddress(String value) => _i1.ColumnValue(
    table.endAddress,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> departureTime(DateTime value) =>
      _i1.ColumnValue(
        table.departureTime,
        value,
      );

  _i1.ColumnValue<String, String> personality(String value) => _i1.ColumnValue(
    table.personality,
    value,
  );

  _i1.ColumnValue<String, String> polyline(String value) => _i1.ColumnValue(
    table.polyline,
    value,
  );

  _i1.ColumnValue<String, String> preferences(String? value) => _i1.ColumnValue(
    table.preferences,
    value,
  );

  _i1.ColumnValue<int, int> totalDurationSeconds(int? value) => _i1.ColumnValue(
    table.totalDurationSeconds,
    value,
  );
}

class TripTable extends _i1.Table<int?> {
  TripTable({super.tableRelation}) : super(tableName: 'trip') {
    updateTable = TripUpdateTable(this);
    description = _i1.ColumnString(
      'description',
      this,
    );
    startAddress = _i1.ColumnString(
      'startAddress',
      this,
    );
    endAddress = _i1.ColumnString(
      'endAddress',
      this,
    );
    departureTime = _i1.ColumnDateTime(
      'departureTime',
      this,
    );
    personality = _i1.ColumnString(
      'personality',
      this,
    );
    polyline = _i1.ColumnString(
      'polyline',
      this,
    );
    preferences = _i1.ColumnString(
      'preferences',
      this,
    );
    totalDurationSeconds = _i1.ColumnInt(
      'totalDurationSeconds',
      this,
    );
  }

  late final TripUpdateTable updateTable;

  late final _i1.ColumnString description;

  late final _i1.ColumnString startAddress;

  late final _i1.ColumnString endAddress;

  late final _i1.ColumnDateTime departureTime;

  late final _i1.ColumnString personality;

  late final _i1.ColumnString polyline;

  late final _i1.ColumnString preferences;

  late final _i1.ColumnInt totalDurationSeconds;

  _i2.StopTable? ___stops;

  _i1.ManyRelation<_i2.StopTable>? _stops;

  _i2.StopTable get __stops {
    if (___stops != null) return ___stops!;
    ___stops = _i1.createRelationTable(
      relationFieldName: '__stops',
      field: Trip.t.id,
      foreignField: _i2.Stop.t.tripId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.StopTable(tableRelation: foreignTableRelation),
    );
    return ___stops!;
  }

  _i1.ManyRelation<_i2.StopTable> get stops {
    if (_stops != null) return _stops!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'stops',
      field: Trip.t.id,
      foreignField: _i2.Stop.t.tripId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.StopTable(tableRelation: foreignTableRelation),
    );
    _stops = _i1.ManyRelation<_i2.StopTable>(
      tableWithRelations: relationTable,
      table: _i2.StopTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _stops!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    description,
    startAddress,
    endAddress,
    departureTime,
    personality,
    polyline,
    preferences,
    totalDurationSeconds,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'stops') {
      return __stops;
    }
    return null;
  }
}

class TripInclude extends _i1.IncludeObject {
  TripInclude._({_i2.StopIncludeList? stops}) {
    _stops = stops;
  }

  _i2.StopIncludeList? _stops;

  @override
  Map<String, _i1.Include?> get includes => {'stops': _stops};

  @override
  _i1.Table<int?> get table => Trip.t;
}

class TripIncludeList extends _i1.IncludeList {
  TripIncludeList._({
    _i1.WhereExpressionBuilder<TripTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Trip.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Trip.t;
}

class TripRepository {
  const TripRepository._();

  final attach = const TripAttachRepository._();

  final attachRow = const TripAttachRowRepository._();

  /// Returns a list of [Trip]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Trip>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TripTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TripTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TripTable>? orderByList,
    _i1.Transaction? transaction,
    TripInclude? include,
  }) async {
    return session.db.find<Trip>(
      where: where?.call(Trip.t),
      orderBy: orderBy?.call(Trip.t),
      orderByList: orderByList?.call(Trip.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [Trip] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Trip?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TripTable>? where,
    int? offset,
    _i1.OrderByBuilder<TripTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TripTable>? orderByList,
    _i1.Transaction? transaction,
    TripInclude? include,
  }) async {
    return session.db.findFirstRow<Trip>(
      where: where?.call(Trip.t),
      orderBy: orderBy?.call(Trip.t),
      orderByList: orderByList?.call(Trip.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Trip] by its [id] or null if no such row exists.
  Future<Trip?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    TripInclude? include,
  }) async {
    return session.db.findById<Trip>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [Trip]s in the list and returns the inserted rows.
  ///
  /// The returned [Trip]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Trip>> insert(
    _i1.Session session,
    List<Trip> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Trip>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Trip] and returns the inserted row.
  ///
  /// The returned [Trip] will have its `id` field set.
  Future<Trip> insertRow(
    _i1.Session session,
    Trip row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Trip>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Trip]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Trip>> update(
    _i1.Session session,
    List<Trip> rows, {
    _i1.ColumnSelections<TripTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Trip>(
      rows,
      columns: columns?.call(Trip.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Trip]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Trip> updateRow(
    _i1.Session session,
    Trip row, {
    _i1.ColumnSelections<TripTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Trip>(
      row,
      columns: columns?.call(Trip.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Trip] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Trip?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<TripUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Trip>(
      id,
      columnValues: columnValues(Trip.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Trip]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Trip>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<TripUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<TripTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TripTable>? orderBy,
    _i1.OrderByListBuilder<TripTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Trip>(
      columnValues: columnValues(Trip.t.updateTable),
      where: where(Trip.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Trip.t),
      orderByList: orderByList?.call(Trip.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Trip]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Trip>> delete(
    _i1.Session session,
    List<Trip> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Trip>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Trip].
  Future<Trip> deleteRow(
    _i1.Session session,
    Trip row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Trip>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Trip>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TripTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Trip>(
      where: where(Trip.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TripTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Trip>(
      where: where?.call(Trip.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class TripAttachRepository {
  const TripAttachRepository._();

  /// Creates a relation between this [Trip] and the given [Stop]s
  /// by setting each [Stop]'s foreign key `tripId` to refer to this [Trip].
  Future<void> stops(
    _i1.Session session,
    Trip trip,
    List<_i2.Stop> stop, {
    _i1.Transaction? transaction,
  }) async {
    if (stop.any((e) => e.id == null)) {
      throw ArgumentError.notNull('stop.id');
    }
    if (trip.id == null) {
      throw ArgumentError.notNull('trip.id');
    }

    var $stop = stop.map((e) => e.copyWith(tripId: trip.id)).toList();
    await session.db.update<_i2.Stop>(
      $stop,
      columns: [_i2.Stop.t.tripId],
      transaction: transaction,
    );
  }
}

class TripAttachRowRepository {
  const TripAttachRowRepository._();

  /// Creates a relation between this [Trip] and the given [Stop]
  /// by setting the [Stop]'s foreign key `tripId` to refer to this [Trip].
  Future<void> stops(
    _i1.Session session,
    Trip trip,
    _i2.Stop stop, {
    _i1.Transaction? transaction,
  }) async {
    if (stop.id == null) {
      throw ArgumentError.notNull('stop.id');
    }
    if (trip.id == null) {
      throw ArgumentError.notNull('trip.id');
    }

    var $stop = stop.copyWith(tripId: trip.id);
    await session.db.updateRow<_i2.Stop>(
      $stop,
      columns: [_i2.Stop.t.tripId],
      transaction: transaction,
    );
  }
}
