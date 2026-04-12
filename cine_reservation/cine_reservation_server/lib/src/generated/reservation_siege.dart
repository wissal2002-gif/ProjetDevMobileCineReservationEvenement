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

abstract class ReservationSiege
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ReservationSiege._({
    this.id,
    required this.reservationId,
    required this.siegeId,
    String? typeTarif,
    this.prix,
  }) : typeTarif = typeTarif ?? 'normal';

  factory ReservationSiege({
    int? id,
    required int reservationId,
    required int siegeId,
    String? typeTarif,
    double? prix,
  }) = _ReservationSiegeImpl;

  factory ReservationSiege.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReservationSiege(
      id: jsonSerialization['id'] as int?,
      reservationId: jsonSerialization['reservationId'] as int,
      siegeId: jsonSerialization['siegeId'] as int,
      typeTarif: jsonSerialization['typeTarif'] as String?,
      prix: (jsonSerialization['prix'] as num?)?.toDouble(),
    );
  }

  static final t = ReservationSiegeTable();

  static const db = ReservationSiegeRepository._();

  @override
  int? id;

  int reservationId;

  int siegeId;

  String? typeTarif;

  double? prix;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ReservationSiege]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ReservationSiege copyWith({
    int? id,
    int? reservationId,
    int? siegeId,
    String? typeTarif,
    double? prix,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReservationSiege',
      if (id != null) 'id': id,
      'reservationId': reservationId,
      'siegeId': siegeId,
      if (typeTarif != null) 'typeTarif': typeTarif,
      if (prix != null) 'prix': prix,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReservationSiege',
      if (id != null) 'id': id,
      'reservationId': reservationId,
      'siegeId': siegeId,
      if (typeTarif != null) 'typeTarif': typeTarif,
      if (prix != null) 'prix': prix,
    };
  }

  static ReservationSiegeInclude include() {
    return ReservationSiegeInclude._();
  }

  static ReservationSiegeIncludeList includeList({
    _i1.WhereExpressionBuilder<ReservationSiegeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReservationSiegeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReservationSiegeTable>? orderByList,
    ReservationSiegeInclude? include,
  }) {
    return ReservationSiegeIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReservationSiege.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ReservationSiege.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReservationSiegeImpl extends ReservationSiege {
  _ReservationSiegeImpl({
    int? id,
    required int reservationId,
    required int siegeId,
    String? typeTarif,
    double? prix,
  }) : super._(
         id: id,
         reservationId: reservationId,
         siegeId: siegeId,
         typeTarif: typeTarif,
         prix: prix,
       );

  /// Returns a shallow copy of this [ReservationSiege]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ReservationSiege copyWith({
    Object? id = _Undefined,
    int? reservationId,
    int? siegeId,
    Object? typeTarif = _Undefined,
    Object? prix = _Undefined,
  }) {
    return ReservationSiege(
      id: id is int? ? id : this.id,
      reservationId: reservationId ?? this.reservationId,
      siegeId: siegeId ?? this.siegeId,
      typeTarif: typeTarif is String? ? typeTarif : this.typeTarif,
      prix: prix is double? ? prix : this.prix,
    );
  }
}

class ReservationSiegeUpdateTable
    extends _i1.UpdateTable<ReservationSiegeTable> {
  ReservationSiegeUpdateTable(super.table);

  _i1.ColumnValue<int, int> reservationId(int value) => _i1.ColumnValue(
    table.reservationId,
    value,
  );

  _i1.ColumnValue<int, int> siegeId(int value) => _i1.ColumnValue(
    table.siegeId,
    value,
  );

  _i1.ColumnValue<String, String> typeTarif(String? value) => _i1.ColumnValue(
    table.typeTarif,
    value,
  );

  _i1.ColumnValue<double, double> prix(double? value) => _i1.ColumnValue(
    table.prix,
    value,
  );
}

class ReservationSiegeTable extends _i1.Table<int?> {
  ReservationSiegeTable({super.tableRelation})
    : super(tableName: 'reservation_sieges') {
    updateTable = ReservationSiegeUpdateTable(this);
    reservationId = _i1.ColumnInt(
      'reservationId',
      this,
    );
    siegeId = _i1.ColumnInt(
      'siegeId',
      this,
    );
    typeTarif = _i1.ColumnString(
      'typeTarif',
      this,
      hasDefault: true,
    );
    prix = _i1.ColumnDouble(
      'prix',
      this,
    );
  }

  late final ReservationSiegeUpdateTable updateTable;

  late final _i1.ColumnInt reservationId;

  late final _i1.ColumnInt siegeId;

  late final _i1.ColumnString typeTarif;

  late final _i1.ColumnDouble prix;

  @override
  List<_i1.Column> get columns => [
    id,
    reservationId,
    siegeId,
    typeTarif,
    prix,
  ];
}

class ReservationSiegeInclude extends _i1.IncludeObject {
  ReservationSiegeInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ReservationSiege.t;
}

class ReservationSiegeIncludeList extends _i1.IncludeList {
  ReservationSiegeIncludeList._({
    _i1.WhereExpressionBuilder<ReservationSiegeTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ReservationSiege.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ReservationSiege.t;
}

class ReservationSiegeRepository {
  const ReservationSiegeRepository._();

  /// Returns a list of [ReservationSiege]s matching the given query parameters.
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
  Future<List<ReservationSiege>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ReservationSiegeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReservationSiegeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReservationSiegeTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ReservationSiege>(
      where: where?.call(ReservationSiege.t),
      orderBy: orderBy?.call(ReservationSiege.t),
      orderByList: orderByList?.call(ReservationSiege.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ReservationSiege] matching the given query parameters.
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
  Future<ReservationSiege?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ReservationSiegeTable>? where,
    int? offset,
    _i1.OrderByBuilder<ReservationSiegeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReservationSiegeTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ReservationSiege>(
      where: where?.call(ReservationSiege.t),
      orderBy: orderBy?.call(ReservationSiege.t),
      orderByList: orderByList?.call(ReservationSiege.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ReservationSiege] by its [id] or null if no such row exists.
  Future<ReservationSiege?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ReservationSiege>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ReservationSiege]s in the list and returns the inserted rows.
  ///
  /// The returned [ReservationSiege]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<ReservationSiege>> insert(
    _i1.DatabaseSession session,
    List<ReservationSiege> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<ReservationSiege>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [ReservationSiege] and returns the inserted row.
  ///
  /// The returned [ReservationSiege] will have its `id` field set.
  Future<ReservationSiege> insertRow(
    _i1.DatabaseSession session,
    ReservationSiege row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ReservationSiege>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ReservationSiege]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ReservationSiege>> update(
    _i1.DatabaseSession session,
    List<ReservationSiege> rows, {
    _i1.ColumnSelections<ReservationSiegeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ReservationSiege>(
      rows,
      columns: columns?.call(ReservationSiege.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ReservationSiege]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ReservationSiege> updateRow(
    _i1.DatabaseSession session,
    ReservationSiege row, {
    _i1.ColumnSelections<ReservationSiegeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ReservationSiege>(
      row,
      columns: columns?.call(ReservationSiege.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ReservationSiege] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ReservationSiege?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<ReservationSiegeUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ReservationSiege>(
      id,
      columnValues: columnValues(ReservationSiege.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ReservationSiege]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ReservationSiege>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ReservationSiegeUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ReservationSiegeTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReservationSiegeTable>? orderBy,
    _i1.OrderByListBuilder<ReservationSiegeTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ReservationSiege>(
      columnValues: columnValues(ReservationSiege.t.updateTable),
      where: where(ReservationSiege.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReservationSiege.t),
      orderByList: orderByList?.call(ReservationSiege.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ReservationSiege]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ReservationSiege>> delete(
    _i1.DatabaseSession session,
    List<ReservationSiege> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ReservationSiege>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ReservationSiege].
  Future<ReservationSiege> deleteRow(
    _i1.DatabaseSession session,
    ReservationSiege row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ReservationSiege>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ReservationSiege>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ReservationSiegeTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ReservationSiege>(
      where: where(ReservationSiege.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ReservationSiegeTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ReservationSiege>(
      where: where?.call(ReservationSiege.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ReservationSiege] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ReservationSiegeTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ReservationSiege>(
      where: where(ReservationSiege.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
