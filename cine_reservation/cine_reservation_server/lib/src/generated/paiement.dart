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

abstract class Paiement
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Paiement._({
    this.id,
    required this.reservationId,
    required this.montant,
    String? methode,
    String? statut,
    this.stripePaymentId,
    this.paypalOrderId,
    this.createdAt,
  }) : methode = methode ?? 'carte',
       statut = statut ?? 'en_attente';

  factory Paiement({
    int? id,
    required int reservationId,
    required double montant,
    String? methode,
    String? statut,
    String? stripePaymentId,
    String? paypalOrderId,
    DateTime? createdAt,
  }) = _PaiementImpl;

  factory Paiement.fromJson(Map<String, dynamic> jsonSerialization) {
    return Paiement(
      id: jsonSerialization['id'] as int?,
      reservationId: jsonSerialization['reservationId'] as int,
      montant: (jsonSerialization['montant'] as num).toDouble(),
      methode: jsonSerialization['methode'] as String?,
      statut: jsonSerialization['statut'] as String?,
      stripePaymentId: jsonSerialization['stripePaymentId'] as String?,
      paypalOrderId: jsonSerialization['paypalOrderId'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = PaiementTable();

  static const db = PaiementRepository._();

  @override
  int? id;

  int reservationId;

  double montant;

  String? methode;

  String? statut;

  String? stripePaymentId;

  String? paypalOrderId;

  DateTime? createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Paiement]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Paiement copyWith({
    int? id,
    int? reservationId,
    double? montant,
    String? methode,
    String? statut,
    String? stripePaymentId,
    String? paypalOrderId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Paiement',
      if (id != null) 'id': id,
      'reservationId': reservationId,
      'montant': montant,
      if (methode != null) 'methode': methode,
      if (statut != null) 'statut': statut,
      if (stripePaymentId != null) 'stripePaymentId': stripePaymentId,
      if (paypalOrderId != null) 'paypalOrderId': paypalOrderId,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Paiement',
      if (id != null) 'id': id,
      'reservationId': reservationId,
      'montant': montant,
      if (methode != null) 'methode': methode,
      if (statut != null) 'statut': statut,
      if (stripePaymentId != null) 'stripePaymentId': stripePaymentId,
      if (paypalOrderId != null) 'paypalOrderId': paypalOrderId,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
    };
  }

  static PaiementInclude include() {
    return PaiementInclude._();
  }

  static PaiementIncludeList includeList({
    _i1.WhereExpressionBuilder<PaiementTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PaiementTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PaiementTable>? orderByList,
    PaiementInclude? include,
  }) {
    return PaiementIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Paiement.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Paiement.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PaiementImpl extends Paiement {
  _PaiementImpl({
    int? id,
    required int reservationId,
    required double montant,
    String? methode,
    String? statut,
    String? stripePaymentId,
    String? paypalOrderId,
    DateTime? createdAt,
  }) : super._(
         id: id,
         reservationId: reservationId,
         montant: montant,
         methode: methode,
         statut: statut,
         stripePaymentId: stripePaymentId,
         paypalOrderId: paypalOrderId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Paiement]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Paiement copyWith({
    Object? id = _Undefined,
    int? reservationId,
    double? montant,
    Object? methode = _Undefined,
    Object? statut = _Undefined,
    Object? stripePaymentId = _Undefined,
    Object? paypalOrderId = _Undefined,
    Object? createdAt = _Undefined,
  }) {
    return Paiement(
      id: id is int? ? id : this.id,
      reservationId: reservationId ?? this.reservationId,
      montant: montant ?? this.montant,
      methode: methode is String? ? methode : this.methode,
      statut: statut is String? ? statut : this.statut,
      stripePaymentId: stripePaymentId is String?
          ? stripePaymentId
          : this.stripePaymentId,
      paypalOrderId: paypalOrderId is String?
          ? paypalOrderId
          : this.paypalOrderId,
      createdAt: createdAt is DateTime? ? createdAt : this.createdAt,
    );
  }
}

class PaiementUpdateTable extends _i1.UpdateTable<PaiementTable> {
  PaiementUpdateTable(super.table);

  _i1.ColumnValue<int, int> reservationId(int value) => _i1.ColumnValue(
    table.reservationId,
    value,
  );

  _i1.ColumnValue<double, double> montant(double value) => _i1.ColumnValue(
    table.montant,
    value,
  );

  _i1.ColumnValue<String, String> methode(String? value) => _i1.ColumnValue(
    table.methode,
    value,
  );

  _i1.ColumnValue<String, String> statut(String? value) => _i1.ColumnValue(
    table.statut,
    value,
  );

  _i1.ColumnValue<String, String> stripePaymentId(String? value) =>
      _i1.ColumnValue(
        table.stripePaymentId,
        value,
      );

  _i1.ColumnValue<String, String> paypalOrderId(String? value) =>
      _i1.ColumnValue(
        table.paypalOrderId,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime? value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class PaiementTable extends _i1.Table<int?> {
  PaiementTable({super.tableRelation}) : super(tableName: 'paiements') {
    updateTable = PaiementUpdateTable(this);
    reservationId = _i1.ColumnInt(
      'reservationId',
      this,
    );
    montant = _i1.ColumnDouble(
      'montant',
      this,
    );
    methode = _i1.ColumnString(
      'methode',
      this,
      hasDefault: true,
    );
    statut = _i1.ColumnString(
      'statut',
      this,
      hasDefault: true,
    );
    stripePaymentId = _i1.ColumnString(
      'stripePaymentId',
      this,
    );
    paypalOrderId = _i1.ColumnString(
      'paypalOrderId',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final PaiementUpdateTable updateTable;

  late final _i1.ColumnInt reservationId;

  late final _i1.ColumnDouble montant;

  late final _i1.ColumnString methode;

  late final _i1.ColumnString statut;

  late final _i1.ColumnString stripePaymentId;

  late final _i1.ColumnString paypalOrderId;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    reservationId,
    montant,
    methode,
    statut,
    stripePaymentId,
    paypalOrderId,
    createdAt,
  ];
}

class PaiementInclude extends _i1.IncludeObject {
  PaiementInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Paiement.t;
}

class PaiementIncludeList extends _i1.IncludeList {
  PaiementIncludeList._({
    _i1.WhereExpressionBuilder<PaiementTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Paiement.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Paiement.t;
}

class PaiementRepository {
  const PaiementRepository._();

  /// Returns a list of [Paiement]s matching the given query parameters.
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
  Future<List<Paiement>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PaiementTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PaiementTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PaiementTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Paiement>(
      where: where?.call(Paiement.t),
      orderBy: orderBy?.call(Paiement.t),
      orderByList: orderByList?.call(Paiement.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Paiement] matching the given query parameters.
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
  Future<Paiement?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PaiementTable>? where,
    int? offset,
    _i1.OrderByBuilder<PaiementTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PaiementTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Paiement>(
      where: where?.call(Paiement.t),
      orderBy: orderBy?.call(Paiement.t),
      orderByList: orderByList?.call(Paiement.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Paiement] by its [id] or null if no such row exists.
  Future<Paiement?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Paiement>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Paiement]s in the list and returns the inserted rows.
  ///
  /// The returned [Paiement]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<Paiement>> insert(
    _i1.DatabaseSession session,
    List<Paiement> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Paiement>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Paiement] and returns the inserted row.
  ///
  /// The returned [Paiement] will have its `id` field set.
  Future<Paiement> insertRow(
    _i1.DatabaseSession session,
    Paiement row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Paiement>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Paiement]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Paiement>> update(
    _i1.DatabaseSession session,
    List<Paiement> rows, {
    _i1.ColumnSelections<PaiementTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Paiement>(
      rows,
      columns: columns?.call(Paiement.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Paiement]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Paiement> updateRow(
    _i1.DatabaseSession session,
    Paiement row, {
    _i1.ColumnSelections<PaiementTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Paiement>(
      row,
      columns: columns?.call(Paiement.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Paiement] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Paiement?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<PaiementUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Paiement>(
      id,
      columnValues: columnValues(Paiement.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Paiement]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Paiement>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<PaiementUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<PaiementTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PaiementTable>? orderBy,
    _i1.OrderByListBuilder<PaiementTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Paiement>(
      columnValues: columnValues(Paiement.t.updateTable),
      where: where(Paiement.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Paiement.t),
      orderByList: orderByList?.call(Paiement.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Paiement]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Paiement>> delete(
    _i1.DatabaseSession session,
    List<Paiement> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Paiement>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Paiement].
  Future<Paiement> deleteRow(
    _i1.DatabaseSession session,
    Paiement row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Paiement>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Paiement>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<PaiementTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Paiement>(
      where: where(Paiement.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PaiementTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Paiement>(
      where: where?.call(Paiement.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Paiement] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<PaiementTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Paiement>(
      where: where(Paiement.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
