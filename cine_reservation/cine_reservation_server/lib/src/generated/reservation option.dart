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

abstract class ReservationOption
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ReservationOption._({
    this.id,
    required this.reservationId,
    required this.optionId,
    int? quantite,
    this.prixUnitaire,
  }) : quantite = quantite ?? 1;

  factory ReservationOption({
    int? id,
    required int reservationId,
    required int optionId,
    int? quantite,
    double? prixUnitaire,
  }) = _ReservationOptionImpl;

  factory ReservationOption.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReservationOption(
      id: jsonSerialization['id'] as int?,
      reservationId: jsonSerialization['reservationId'] as int,
      optionId: jsonSerialization['optionId'] as int,
      quantite: jsonSerialization['quantite'] as int?,
      prixUnitaire: (jsonSerialization['prixUnitaire'] as num?)?.toDouble(),
    );
  }

  static final t = ReservationOptionTable();

  static const db = ReservationOptionRepository._();

  @override
  int? id;

  int reservationId;

  int optionId;

  int? quantite;

  double? prixUnitaire;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ReservationOption]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ReservationOption copyWith({
    int? id,
    int? reservationId,
    int? optionId,
    int? quantite,
    double? prixUnitaire,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReservationOption',
      if (id != null) 'id': id,
      'reservationId': reservationId,
      'optionId': optionId,
      if (quantite != null) 'quantite': quantite,
      if (prixUnitaire != null) 'prixUnitaire': prixUnitaire,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReservationOption',
      if (id != null) 'id': id,
      'reservationId': reservationId,
      'optionId': optionId,
      if (quantite != null) 'quantite': quantite,
      if (prixUnitaire != null) 'prixUnitaire': prixUnitaire,
    };
  }

  static ReservationOptionInclude include() {
    return ReservationOptionInclude._();
  }

  static ReservationOptionIncludeList includeList({
    _i1.WhereExpressionBuilder<ReservationOptionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReservationOptionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReservationOptionTable>? orderByList,
    ReservationOptionInclude? include,
  }) {
    return ReservationOptionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReservationOption.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ReservationOption.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReservationOptionImpl extends ReservationOption {
  _ReservationOptionImpl({
    int? id,
    required int reservationId,
    required int optionId,
    int? quantite,
    double? prixUnitaire,
  }) : super._(
         id: id,
         reservationId: reservationId,
         optionId: optionId,
         quantite: quantite,
         prixUnitaire: prixUnitaire,
       );

  /// Returns a shallow copy of this [ReservationOption]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ReservationOption copyWith({
    Object? id = _Undefined,
    int? reservationId,
    int? optionId,
    Object? quantite = _Undefined,
    Object? prixUnitaire = _Undefined,
  }) {
    return ReservationOption(
      id: id is int? ? id : this.id,
      reservationId: reservationId ?? this.reservationId,
      optionId: optionId ?? this.optionId,
      quantite: quantite is int? ? quantite : this.quantite,
      prixUnitaire: prixUnitaire is double? ? prixUnitaire : this.prixUnitaire,
    );
  }
}

class ReservationOptionUpdateTable
    extends _i1.UpdateTable<ReservationOptionTable> {
  ReservationOptionUpdateTable(super.table);

  _i1.ColumnValue<int, int> reservationId(int value) => _i1.ColumnValue(
    table.reservationId,
    value,
  );

  _i1.ColumnValue<int, int> optionId(int value) => _i1.ColumnValue(
    table.optionId,
    value,
  );

  _i1.ColumnValue<int, int> quantite(int? value) => _i1.ColumnValue(
    table.quantite,
    value,
  );

  _i1.ColumnValue<double, double> prixUnitaire(double? value) =>
      _i1.ColumnValue(
        table.prixUnitaire,
        value,
      );
}

class ReservationOptionTable extends _i1.Table<int?> {
  ReservationOptionTable({super.tableRelation})
    : super(tableName: 'reservation_options') {
    updateTable = ReservationOptionUpdateTable(this);
    reservationId = _i1.ColumnInt(
      'reservationId',
      this,
    );
    optionId = _i1.ColumnInt(
      'optionId',
      this,
    );
    quantite = _i1.ColumnInt(
      'quantite',
      this,
      hasDefault: true,
    );
    prixUnitaire = _i1.ColumnDouble(
      'prixUnitaire',
      this,
    );
  }

  late final ReservationOptionUpdateTable updateTable;

  late final _i1.ColumnInt reservationId;

  late final _i1.ColumnInt optionId;

  late final _i1.ColumnInt quantite;

  late final _i1.ColumnDouble prixUnitaire;

  @override
  List<_i1.Column> get columns => [
    id,
    reservationId,
    optionId,
    quantite,
    prixUnitaire,
  ];
}

class ReservationOptionInclude extends _i1.IncludeObject {
  ReservationOptionInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ReservationOption.t;
}

class ReservationOptionIncludeList extends _i1.IncludeList {
  ReservationOptionIncludeList._({
    _i1.WhereExpressionBuilder<ReservationOptionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ReservationOption.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ReservationOption.t;
}

class ReservationOptionRepository {
  const ReservationOptionRepository._();

  /// Returns a list of [ReservationOption]s matching the given query parameters.
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
  Future<List<ReservationOption>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReservationOptionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReservationOptionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReservationOptionTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ReservationOption>(
      where: where?.call(ReservationOption.t),
      orderBy: orderBy?.call(ReservationOption.t),
      orderByList: orderByList?.call(ReservationOption.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ReservationOption] matching the given query parameters.
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
  Future<ReservationOption?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReservationOptionTable>? where,
    int? offset,
    _i1.OrderByBuilder<ReservationOptionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReservationOptionTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ReservationOption>(
      where: where?.call(ReservationOption.t),
      orderBy: orderBy?.call(ReservationOption.t),
      orderByList: orderByList?.call(ReservationOption.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ReservationOption] by its [id] or null if no such row exists.
  Future<ReservationOption?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ReservationOption>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ReservationOption]s in the list and returns the inserted rows.
  ///
  /// The returned [ReservationOption]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ReservationOption>> insert(
    _i1.Session session,
    List<ReservationOption> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ReservationOption>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ReservationOption] and returns the inserted row.
  ///
  /// The returned [ReservationOption] will have its `id` field set.
  Future<ReservationOption> insertRow(
    _i1.Session session,
    ReservationOption row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ReservationOption>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ReservationOption]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ReservationOption>> update(
    _i1.Session session,
    List<ReservationOption> rows, {
    _i1.ColumnSelections<ReservationOptionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ReservationOption>(
      rows,
      columns: columns?.call(ReservationOption.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ReservationOption]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ReservationOption> updateRow(
    _i1.Session session,
    ReservationOption row, {
    _i1.ColumnSelections<ReservationOptionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ReservationOption>(
      row,
      columns: columns?.call(ReservationOption.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ReservationOption] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ReservationOption?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ReservationOptionUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ReservationOption>(
      id,
      columnValues: columnValues(ReservationOption.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ReservationOption]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ReservationOption>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ReservationOptionUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ReservationOptionTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReservationOptionTable>? orderBy,
    _i1.OrderByListBuilder<ReservationOptionTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ReservationOption>(
      columnValues: columnValues(ReservationOption.t.updateTable),
      where: where(ReservationOption.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReservationOption.t),
      orderByList: orderByList?.call(ReservationOption.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ReservationOption]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ReservationOption>> delete(
    _i1.Session session,
    List<ReservationOption> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ReservationOption>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ReservationOption].
  Future<ReservationOption> deleteRow(
    _i1.Session session,
    ReservationOption row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ReservationOption>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ReservationOption>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ReservationOptionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ReservationOption>(
      where: where(ReservationOption.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReservationOptionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ReservationOption>(
      where: where?.call(ReservationOption.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
