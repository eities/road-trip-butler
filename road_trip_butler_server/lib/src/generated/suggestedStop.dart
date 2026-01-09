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

abstract class SuggestedStop
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  SuggestedStop._({
    this.id,
    required this.tripId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.category,
    required this.butlerNote,
    this.rating,
    this.priceLevel,
    required this.status,
    required this.estimatedArrivalTime,
  });

  factory SuggestedStop({
    int? id,
    required int tripId,
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required String category,
    required String butlerNote,
    double? rating,
    int? priceLevel,
    required int status,
    required DateTime estimatedArrivalTime,
  }) = _SuggestedStopImpl;

  factory SuggestedStop.fromJson(Map<String, dynamic> jsonSerialization) {
    return SuggestedStop(
      id: jsonSerialization['id'] as int?,
      tripId: jsonSerialization['tripId'] as int,
      name: jsonSerialization['name'] as String,
      address: jsonSerialization['address'] as String,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      category: jsonSerialization['category'] as String,
      butlerNote: jsonSerialization['butlerNote'] as String,
      rating: (jsonSerialization['rating'] as num?)?.toDouble(),
      priceLevel: jsonSerialization['priceLevel'] as int?,
      status: jsonSerialization['status'] as int,
      estimatedArrivalTime: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['estimatedArrivalTime'],
      ),
    );
  }

  static final t = SuggestedStopTable();

  static const db = SuggestedStopRepository._();

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

  int? priceLevel;

  int status;

  DateTime estimatedArrivalTime;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [SuggestedStop]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SuggestedStop copyWith({
    int? id,
    int? tripId,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    String? category,
    String? butlerNote,
    double? rating,
    int? priceLevel,
    int? status,
    DateTime? estimatedArrivalTime,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SuggestedStop',
      if (id != null) 'id': id,
      'tripId': tripId,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'category': category,
      'butlerNote': butlerNote,
      if (rating != null) 'rating': rating,
      if (priceLevel != null) 'priceLevel': priceLevel,
      'status': status,
      'estimatedArrivalTime': estimatedArrivalTime.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SuggestedStop',
      if (id != null) 'id': id,
      'tripId': tripId,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'category': category,
      'butlerNote': butlerNote,
      if (rating != null) 'rating': rating,
      if (priceLevel != null) 'priceLevel': priceLevel,
      'status': status,
      'estimatedArrivalTime': estimatedArrivalTime.toJson(),
    };
  }

  static SuggestedStopInclude include() {
    return SuggestedStopInclude._();
  }

  static SuggestedStopIncludeList includeList({
    _i1.WhereExpressionBuilder<SuggestedStopTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SuggestedStopTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SuggestedStopTable>? orderByList,
    SuggestedStopInclude? include,
  }) {
    return SuggestedStopIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SuggestedStop.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(SuggestedStop.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SuggestedStopImpl extends SuggestedStop {
  _SuggestedStopImpl({
    int? id,
    required int tripId,
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required String category,
    required String butlerNote,
    double? rating,
    int? priceLevel,
    required int status,
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

  /// Returns a shallow copy of this [SuggestedStop]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SuggestedStop copyWith({
    Object? id = _Undefined,
    int? tripId,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    String? category,
    String? butlerNote,
    Object? rating = _Undefined,
    Object? priceLevel = _Undefined,
    int? status,
    DateTime? estimatedArrivalTime,
  }) {
    return SuggestedStop(
      id: id is int? ? id : this.id,
      tripId: tripId ?? this.tripId,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      category: category ?? this.category,
      butlerNote: butlerNote ?? this.butlerNote,
      rating: rating is double? ? rating : this.rating,
      priceLevel: priceLevel is int? ? priceLevel : this.priceLevel,
      status: status ?? this.status,
      estimatedArrivalTime: estimatedArrivalTime ?? this.estimatedArrivalTime,
    );
  }
}

class SuggestedStopUpdateTable extends _i1.UpdateTable<SuggestedStopTable> {
  SuggestedStopUpdateTable(super.table);

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

  _i1.ColumnValue<int, int> priceLevel(int? value) => _i1.ColumnValue(
    table.priceLevel,
    value,
  );

  _i1.ColumnValue<int, int> status(int value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> estimatedArrivalTime(DateTime value) =>
      _i1.ColumnValue(
        table.estimatedArrivalTime,
        value,
      );
}

class SuggestedStopTable extends _i1.Table<int?> {
  SuggestedStopTable({super.tableRelation})
    : super(tableName: 'suggested_stop') {
    updateTable = SuggestedStopUpdateTable(this);
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
    priceLevel = _i1.ColumnInt(
      'priceLevel',
      this,
    );
    status = _i1.ColumnInt(
      'status',
      this,
    );
    estimatedArrivalTime = _i1.ColumnDateTime(
      'estimatedArrivalTime',
      this,
    );
  }

  late final SuggestedStopUpdateTable updateTable;

  late final _i1.ColumnInt tripId;

  late final _i1.ColumnString name;

  late final _i1.ColumnString address;

  late final _i1.ColumnDouble latitude;

  late final _i1.ColumnDouble longitude;

  late final _i1.ColumnString category;

  late final _i1.ColumnString butlerNote;

  late final _i1.ColumnDouble rating;

  late final _i1.ColumnInt priceLevel;

  late final _i1.ColumnInt status;

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

class SuggestedStopInclude extends _i1.IncludeObject {
  SuggestedStopInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => SuggestedStop.t;
}

class SuggestedStopIncludeList extends _i1.IncludeList {
  SuggestedStopIncludeList._({
    _i1.WhereExpressionBuilder<SuggestedStopTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SuggestedStop.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => SuggestedStop.t;
}

class SuggestedStopRepository {
  const SuggestedStopRepository._();

  /// Returns a list of [SuggestedStop]s matching the given query parameters.
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
  Future<List<SuggestedStop>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SuggestedStopTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SuggestedStopTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SuggestedStopTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<SuggestedStop>(
      where: where?.call(SuggestedStop.t),
      orderBy: orderBy?.call(SuggestedStop.t),
      orderByList: orderByList?.call(SuggestedStop.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [SuggestedStop] matching the given query parameters.
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
  Future<SuggestedStop?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SuggestedStopTable>? where,
    int? offset,
    _i1.OrderByBuilder<SuggestedStopTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SuggestedStopTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<SuggestedStop>(
      where: where?.call(SuggestedStop.t),
      orderBy: orderBy?.call(SuggestedStop.t),
      orderByList: orderByList?.call(SuggestedStop.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [SuggestedStop] by its [id] or null if no such row exists.
  Future<SuggestedStop?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<SuggestedStop>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [SuggestedStop]s in the list and returns the inserted rows.
  ///
  /// The returned [SuggestedStop]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<SuggestedStop>> insert(
    _i1.Session session,
    List<SuggestedStop> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<SuggestedStop>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [SuggestedStop] and returns the inserted row.
  ///
  /// The returned [SuggestedStop] will have its `id` field set.
  Future<SuggestedStop> insertRow(
    _i1.Session session,
    SuggestedStop row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<SuggestedStop>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [SuggestedStop]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<SuggestedStop>> update(
    _i1.Session session,
    List<SuggestedStop> rows, {
    _i1.ColumnSelections<SuggestedStopTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<SuggestedStop>(
      rows,
      columns: columns?.call(SuggestedStop.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SuggestedStop]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SuggestedStop> updateRow(
    _i1.Session session,
    SuggestedStop row, {
    _i1.ColumnSelections<SuggestedStopTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<SuggestedStop>(
      row,
      columns: columns?.call(SuggestedStop.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SuggestedStop] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SuggestedStop?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<SuggestedStopUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<SuggestedStop>(
      id,
      columnValues: columnValues(SuggestedStop.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SuggestedStop]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<SuggestedStop>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<SuggestedStopUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<SuggestedStopTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SuggestedStopTable>? orderBy,
    _i1.OrderByListBuilder<SuggestedStopTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<SuggestedStop>(
      columnValues: columnValues(SuggestedStop.t.updateTable),
      where: where(SuggestedStop.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SuggestedStop.t),
      orderByList: orderByList?.call(SuggestedStop.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [SuggestedStop]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<SuggestedStop>> delete(
    _i1.Session session,
    List<SuggestedStop> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SuggestedStop>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [SuggestedStop].
  Future<SuggestedStop> deleteRow(
    _i1.Session session,
    SuggestedStop row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SuggestedStop>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<SuggestedStop>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SuggestedStopTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<SuggestedStop>(
      where: where(SuggestedStop.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SuggestedStopTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SuggestedStop>(
      where: where?.call(SuggestedStop.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
