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

abstract class Billet implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Billet._({
    this.id,
    required this.reservationId,
    required this.siegeId,
    required this.dateEmission,
    bool? estValide,
    String? typeBillet,
    this.qrCode,
  }) : estValide = estValide ?? true,
       typeBillet = typeBillet ?? 'standard';

  factory Billet({
    int? id,
    required int reservationId,
    required int siegeId,
    required DateTime dateEmission,
    bool? estValide,
    String? typeBillet,
    String? qrCode,
  }) = _BilletImpl;

  factory Billet.fromJson(Map<String, dynamic> jsonSerialization) {
    return Billet(
      id: jsonSerialization['id'] as int?,
      reservationId: jsonSerialization['reservationId'] as int,
      siegeId: jsonSerialization['siegeId'] as int,
      dateEmission: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['dateEmission'],
      ),
      estValide: jsonSerialization['estValide'] as bool?,
      typeBillet: jsonSerialization['typeBillet'] as String?,
      qrCode: jsonSerialization['qrCode'] as String?,
    );
  }

  static final t = BilletTable();

  static const db = BilletRepository._();

  @override
  int? id;

  int reservationId;

  int siegeId;

  DateTime dateEmission;

  bool? estValide;

  String? typeBillet;

  String? qrCode;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Billet]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Billet copyWith({
    int? id,
    int? reservationId,
    int? siegeId,
    DateTime? dateEmission,
    bool? estValide,
    String? typeBillet,
    String? qrCode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Billet',
      if (id != null) 'id': id,
      'reservationId': reservationId,
      'siegeId': siegeId,
      'dateEmission': dateEmission.toJson(),
      if (estValide != null) 'estValide': estValide,
      if (typeBillet != null) 'typeBillet': typeBillet,
      if (qrCode != null) 'qrCode': qrCode,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Billet',
      if (id != null) 'id': id,
      'reservationId': reservationId,
      'siegeId': siegeId,
      'dateEmission': dateEmission.toJson(),
      if (estValide != null) 'estValide': estValide,
      if (typeBillet != null) 'typeBillet': typeBillet,
      if (qrCode != null) 'qrCode': qrCode,
    };
  }

  static BilletInclude include() {
    return BilletInclude._();
  }

  static BilletIncludeList includeList({
    _i1.WhereExpressionBuilder<BilletTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BilletTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BilletTable>? orderByList,
    BilletInclude? include,
  }) {
    return BilletIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Billet.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Billet.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BilletImpl extends Billet {
  _BilletImpl({
    int? id,
    required int reservationId,
    required int siegeId,
    required DateTime dateEmission,
    bool? estValide,
    String? typeBillet,
    String? qrCode,
  }) : super._(
         id: id,
         reservationId: reservationId,
         siegeId: siegeId,
         dateEmission: dateEmission,
         estValide: estValide,
         typeBillet: typeBillet,
         qrCode: qrCode,
       );

  /// Returns a shallow copy of this [Billet]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Billet copyWith({
    Object? id = _Undefined,
    int? reservationId,
    int? siegeId,
    DateTime? dateEmission,
    Object? estValide = _Undefined,
    Object? typeBillet = _Undefined,
    Object? qrCode = _Undefined,
  }) {
    return Billet(
      id: id is int? ? id : this.id,
      reservationId: reservationId ?? this.reservationId,
      siegeId: siegeId ?? this.siegeId,
      dateEmission: dateEmission ?? this.dateEmission,
      estValide: estValide is bool? ? estValide : this.estValide,
      typeBillet: typeBillet is String? ? typeBillet : this.typeBillet,
      qrCode: qrCode is String? ? qrCode : this.qrCode,
    );
  }
}

class BilletUpdateTable extends _i1.UpdateTable<BilletTable> {
  BilletUpdateTable(super.table);

  _i1.ColumnValue<int, int> reservationId(int value) => _i1.ColumnValue(
    table.reservationId,
    value,
  );

  _i1.ColumnValue<int, int> siegeId(int value) => _i1.ColumnValue(
    table.siegeId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> dateEmission(DateTime value) =>
      _i1.ColumnValue(
        table.dateEmission,
        value,
      );

  _i1.ColumnValue<bool, bool> estValide(bool? value) => _i1.ColumnValue(
    table.estValide,
    value,
  );

  _i1.ColumnValue<String, String> typeBillet(String? value) => _i1.ColumnValue(
    table.typeBillet,
    value,
  );

  _i1.ColumnValue<String, String> qrCode(String? value) => _i1.ColumnValue(
    table.qrCode,
    value,
  );
}

class BilletTable extends _i1.Table<int?> {
  BilletTable({super.tableRelation}) : super(tableName: 'billets') {
    updateTable = BilletUpdateTable(this);
    reservationId = _i1.ColumnInt(
      'reservationId',
      this,
    );
    siegeId = _i1.ColumnInt(
      'siegeId',
      this,
    );
    dateEmission = _i1.ColumnDateTime(
      'dateEmission',
      this,
    );
    estValide = _i1.ColumnBool(
      'estValide',
      this,
      hasDefault: true,
    );
    typeBillet = _i1.ColumnString(
      'typeBillet',
      this,
      hasDefault: true,
    );
    qrCode = _i1.ColumnString(
      'qrCode',
      this,
    );
  }

  late final BilletUpdateTable updateTable;

  late final _i1.ColumnInt reservationId;

  late final _i1.ColumnInt siegeId;

  late final _i1.ColumnDateTime dateEmission;

  late final _i1.ColumnBool estValide;

  late final _i1.ColumnString typeBillet;

  late final _i1.ColumnString qrCode;

  @override
  List<_i1.Column> get columns => [
    id,
    reservationId,
    siegeId,
    dateEmission,
    estValide,
    typeBillet,
    qrCode,
  ];
}

class BilletInclude extends _i1.IncludeObject {
  BilletInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Billet.t;
}

class BilletIncludeList extends _i1.IncludeList {
  BilletIncludeList._({
    _i1.WhereExpressionBuilder<BilletTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Billet.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Billet.t;
}

class BilletRepository {
  const BilletRepository._();

  /// Returns a list of [Billet]s matching the given query parameters.
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
  Future<List<Billet>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BilletTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BilletTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BilletTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Billet>(
      where: where?.call(Billet.t),
      orderBy: orderBy?.call(Billet.t),
      orderByList: orderByList?.call(Billet.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Billet] matching the given query parameters.
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
  Future<Billet?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BilletTable>? where,
    int? offset,
    _i1.OrderByBuilder<BilletTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BilletTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Billet>(
      where: where?.call(Billet.t),
      orderBy: orderBy?.call(Billet.t),
      orderByList: orderByList?.call(Billet.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Billet] by its [id] or null if no such row exists.
  Future<Billet?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Billet>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Billet]s in the list and returns the inserted rows.
  ///
  /// The returned [Billet]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Billet>> insert(
    _i1.Session session,
    List<Billet> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Billet>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Billet] and returns the inserted row.
  ///
  /// The returned [Billet] will have its `id` field set.
  Future<Billet> insertRow(
    _i1.Session session,
    Billet row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Billet>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Billet]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Billet>> update(
    _i1.Session session,
    List<Billet> rows, {
    _i1.ColumnSelections<BilletTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Billet>(
      rows,
      columns: columns?.call(Billet.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Billet]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Billet> updateRow(
    _i1.Session session,
    Billet row, {
    _i1.ColumnSelections<BilletTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Billet>(
      row,
      columns: columns?.call(Billet.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Billet] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Billet?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<BilletUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Billet>(
      id,
      columnValues: columnValues(Billet.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Billet]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Billet>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<BilletUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<BilletTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BilletTable>? orderBy,
    _i1.OrderByListBuilder<BilletTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Billet>(
      columnValues: columnValues(Billet.t.updateTable),
      where: where(Billet.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Billet.t),
      orderByList: orderByList?.call(Billet.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Billet]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Billet>> delete(
    _i1.Session session,
    List<Billet> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Billet>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Billet].
  Future<Billet> deleteRow(
    _i1.Session session,
    Billet row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Billet>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Billet>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<BilletTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Billet>(
      where: where(Billet.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BilletTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Billet>(
      where: where?.call(Billet.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
