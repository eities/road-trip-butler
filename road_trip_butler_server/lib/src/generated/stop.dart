/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'price_level.dart' as _i2;
import 'stop_status.dart' as _i3;

abstract class Stop implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Stop._({
    this.id,
    required this.tripId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.category,
    required this.butlerNote,
    this.rating,
    required this.priceLevel,
    required this.status,
    required this.estimatedArrivalTime,
  });

  factory Stop({
    int? id,
    required int tripId,
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required String category,
    required String butlerNote,
    double? rating,
    required _i2.PriceLevel priceLevel,
    required _i3.StopStatus status,
    required DateTime estimatedArrivalTime,
  }) = _StopImpl;

  factory Stop.fromJson(Map<String, dynamic> jsonSerialization) {
    return Stop(
      id: jsonSerialization['id'] as int?,
      tripId: jsonSerialization['tripId'] as int,
      name: jsonSerialization['name'] as String,
      address: jsonSerialization['address'] as String,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      category: jsonSerialization['category'] as String,
      butlerNote: jsonSerialization['butlerNote'] as String,
      rating: (jsonSerialization['rating'] as num?)?.toDouble(),
      priceLevel: _i2.PriceLevel.fromJson(
        (jsonSerialization['priceLevel'] as String),
      ),
      status: _i3.StopStatus.fromJson((jsonSerialization['status'] as String)),
      estimatedArrivalTime: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['estimatedArrivalTime'],
      ),
    );
  }

  static final t = StopTable();

  static const db = StopRepository._();

  @override
  int? id;

  int tripId;

  String name;

  String address;

  double latitude;

  double longitude;

  String category;

  String butlerNote;

  double? rating;

  _i2.PriceLevel priceLevel;

  _i3.StopStatus status;

  DateTime estimatedArrivalTime;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Stop]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Stop copyWith({
    int? id,
    int? tripId,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    String? category,
    String? butlerNote,
    double? rating,
    _i2.PriceLevel? priceLevel,
    _i3.StopStatus? status,
    DateTime? estimatedArrivalTime,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Stop',
      if (id != null) 'id': id,
      'tripId': tripId,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'category': category,
      'butlerNote': butlerNote,
      if (rating != null) 'rating': rating,
      'priceLevel': priceLevel.toJson(),
      'status': status.toJson(),
      'estimatedArrivalTime': estimatedArrivalTime.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Stop',
      if (id != null) 'id': id,
      'tripId': tripId,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'category': category,
      'butlerNote': butlerNote,
      if (rating != null) 'rating': rating,
      'priceLevel': priceLevel.toJson(),
      'status': status.toJson(),
      'estimatedArrivalTime': estimatedArrivalTime.toJson(),
    };
  }

  static StopInclude include() {
    return StopInclude._();
  }

  static StopIncludeList includeList({
    _i1.WhereExpressionBuilder<StopTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<StopTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StopTable>? orderByList,
    StopInclude? include,
  }) {
    return StopIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Stop.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Stop.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StopImpl extends Stop {
  _StopImpl({
    int? id,
    required int tripId,
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required String category,
    required String butlerNote,
    double? rating,
    required _i2.PriceLevel priceLevel,
    required _i3.StopStatus status,
    required DateTime estimatedArrivalTime,
  }) : super._(
         id: id,
         tripId: tripId,
         name: name,
         address: address,
         latitude: latitude,
         longitude: longitude,
         category: category,
         butlerNote: butlerNote,
         rating: rating,
         priceLevel: priceLevel,
         status: status,
         estimatedArrivalTime: estimatedArrivalTime,
       );

  /// Returns a shallow copy of this [Stop]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Stop copyWith({
    Object? id = _Undefined,
    int? tripId,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    String? category,
    String? butlerNote,
    Object? rating = _Undefined,
    _i2.PriceLevel? priceLevel,
    _i3.StopStatus? status,
    DateTime? estimatedArrivalTime,
  }) {
    return Stop(
      id: id is int? ? id : this.id,
      tripId: tripId ?? this.tripId,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      category: category ?? this.category,
      butlerNote: butlerNote ?? this.butlerNote,
      rating: rating is double? ? rating : this.rating,
      priceLevel: priceLevel ?? this.priceLevel,
      status: status ?? this.status,
      estimatedArrivalTime: estimatedArrivalTime ?? this.estimatedArrivalTime,
    );
  }
}

class StopUpdateTable extends _i1.UpdateTable<StopTable> {
  StopUpdateTable(super.table);

  _i1.ColumnValue<int, int> tripId(int value) => _i1.ColumnValue(
    table.tripId,
    value,
  );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> address(String value) => _i1.ColumnValue(
    table.address,
    value,
  );

  _i1.ColumnValue<double, double> latitude(double value) => _i1.ColumnValue(
    table.latitude,
    value,
  );

  _i1.ColumnValue<double, double> longitude(double value) => _i1.ColumnValue(
    table.longitude,
    value,
  );

  _i1.ColumnValue<String, String> category(String value) => _i1.ColumnValue(
    table.category,
    value,
  );

  _i1.ColumnValue<String, String> butlerNote(String value) => _i1.ColumnValue(
    table.butlerNote,
    value,
  );

  _i1.ColumnValue<double, double> rating(double? value) => _i1.ColumnValue(
    table.rating,
    value,
  );

  _i1.ColumnValue<_i2.PriceLevel, _i2.PriceLevel> priceLevel(
    _i2.PriceLevel value,
  ) => _i1.ColumnValue(
    table.priceLevel,
    value,
  );

  _i1.ColumnValue<_i3.StopStatus, _i3.StopStatus> status(
    _i3.StopStatus value,
  ) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> estimatedArrivalTime(DateTime value) =>
      _i1.ColumnValue(
        table.estimatedArrivalTime,
        value,
      );
}

class StopTable extends _i1.Table<int?> {
  StopTable({super.tableRelation}) : super(tableName: 'stop') {
    updateTable = StopUpdateTable(this);
    tripId = _i1.ColumnInt(
      'tripId',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    address = _i1.ColumnString(
      'address',
      this,
    );
    latitude = _i1.ColumnDouble(
      'latitude',
      this,
    );
    longitude = _i1.ColumnDouble(
      'longitude',
      this,
    );
    category = _i1.ColumnString(
      'category',
      this,
    );
    butlerNote = _i1.ColumnString(
      'butlerNote',
      this,
    );
    rating = _i1.ColumnDouble(
      'rating',
      this,
    );
    priceLevel = _i1.ColumnEnum(
      'priceLevel',
      this,
      _i1.EnumSerialization.byName,
    );
    status = _i1.ColumnEnum(
      'status',
      this,
      _i1.EnumSerialization.byName,
    );
    estimatedArrivalTime = _i1.ColumnDateTime(
      'estimatedArrivalTime',
      this,
    );
  }

  late final StopUpdateTable updateTable;

  late final _i1.ColumnInt tripId;

  late final _i1.ColumnString name;

  late final _i1.ColumnString address;

  late final _i1.ColumnDouble latitude;

  late final _i1.ColumnDouble longitude;

  late final _i1.ColumnString category;

  late final _i1.ColumnString butlerNote;

  late final _i1.ColumnDouble rating;

  late final _i1.ColumnEnum<_i2.PriceLevel> priceLevel;

  late final _i1.ColumnEnum<_i3.StopStatus> status;

  late final _i1.ColumnDateTime estimatedArrivalTime;

  @override
  List<_i1.Column> get columns => [
    id,
    tripId,
    name,
    address,
    latitude,
    longitude,
    category,
    butlerNote,
    rating,
    priceLevel,
    status,
    estimatedArrivalTime,
  ];
}

class StopInclude extends _i1.IncludeObject {
  StopInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Stop.t;
}

class StopIncludeList extends _i1.IncludeList {
  StopIncludeList._({
    _i1.WhereExpressionBuilder<StopTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Stop.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Stop.t;
}

class StopRepository {
  const StopRepository._();

  /// Returns a list of [Stop]s matching the given query parameters.
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
  Future<List<Stop>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StopTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<StopTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StopTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Stop>(
      where: where?.call(Stop.t),
      orderBy: orderBy?.call(Stop.t),
      orderByList: orderByList?.call(Stop.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Stop] matching the given query parameters.
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
  Future<Stop?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StopTable>? where,
    int? offset,
    _i1.OrderByBuilder<StopTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StopTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Stop>(
      where: where?.call(Stop.t),
      orderBy: orderBy?.call(Stop.t),
      orderByList: orderByList?.call(Stop.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Stop] by its [id] or null if no such row exists.
  Future<Stop?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Stop>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Stop]s in the list and returns the inserted rows.
  ///
  /// The returned [Stop]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Stop>> insert(
    _i1.Session session,
    List<Stop> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Stop>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Stop] and returns the inserted row.
  ///
  /// The returned [Stop] will have its `id` field set.
  Future<Stop> insertRow(
    _i1.Session session,
    Stop row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Stop>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Stop]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Stop>> update(
    _i1.Session session,
    List<Stop> rows, {
    _i1.ColumnSelections<StopTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Stop>(
      rows,
      columns: columns?.call(Stop.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Stop]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Stop> updateRow(
    _i1.Session session,
    Stop row, {
    _i1.ColumnSelections<StopTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Stop>(
      row,
      columns: columns?.call(Stop.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Stop] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Stop?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<StopUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Stop>(
      id,
      columnValues: columnValues(Stop.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Stop]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Stop>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<StopUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<StopTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<StopTable>? orderBy,
    _i1.OrderByListBuilder<StopTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Stop>(
      columnValues: columnValues(Stop.t.updateTable),
      where: where(Stop.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Stop.t),
      orderByList: orderByList?.call(Stop.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Stop]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Stop>> delete(
    _i1.Session session,
    List<Stop> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Stop>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Stop].
  Future<Stop> deleteRow(
    _i1.Session session,
    Stop row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Stop>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Stop>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<StopTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Stop>(
      where: where(Stop.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StopTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Stop>(
      where: where?.call(Stop.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
