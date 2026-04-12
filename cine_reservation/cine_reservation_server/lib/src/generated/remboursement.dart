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

abstract class Remboursement
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Remboursement._({
    this.id,
    required this.paiementId,
    required this.reservationId,
    required this.utilisateurId,
    required this.montant,
    this.raison,
    String? statut,
    this.stripeRefundId,
    required this.dateDemandeRemboursement,
    this.dateRemboursement,
    this.traitePar,
  }) : statut = statut ?? 'en_attente';

  factory Remboursement({
    int? id,
    required int paiementId,
    required int reservationId,
    required int utilisateurId,
    required double montant,
    String? raison,
    String? statut,
    String? stripeRefundId,
    required DateTime dateDemandeRemboursement,
    DateTime? dateRemboursement,
    int? traitePar,
  }) = _RemboursementImpl;

  factory Remboursement.fromJson(Map<String, dynamic> jsonSerialization) {
    return Remboursement(
      id: jsonSerialization['id'] as int?,
      paiementId: jsonSerialization['paiementId'] as int,
      reservationId: jsonSerialization['reservationId'] as int,
      utilisateurId: jsonSerialization['utilisateurId'] as int,
      montant: (jsonSerialization['montant'] as num).toDouble(),
      raison: jsonSerialization['raison'] as String?,
      statut: jsonSerialization['statut'] as String?,
      stripeRefundId: jsonSerialization['stripeRefundId'] as String?,
      dateDemandeRemboursement: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['dateDemandeRemboursement'],
      ),
      dateRemboursement: jsonSerialization['dateRemboursement'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['dateRemboursement'],
            ),
      traitePar: jsonSerialization['traitePar'] as int?,
    );
  }

  static final t = RemboursementTable();

  static const db = RemboursementRepository._();

  @override
  int? id;

  int paiementId;

  int reservationId;

  int utilisateurId;

  double montant;

  String? raison;

  String? statut;

  String? stripeRefundId;

  DateTime dateDemandeRemboursement;

  DateTime? dateRemboursement;

  int? traitePar;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Remboursement]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Remboursement copyWith({
    int? id,
    int? paiementId,
    int? reservationId,
    int? utilisateurId,
    double? montant,
    String? raison,
    String? statut,
    String? stripeRefundId,
    DateTime? dateDemandeRemboursement,
    DateTime? dateRemboursement,
    int? traitePar,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Remboursement',
      if (id != null) 'id': id,
      'paiementId': paiementId,
      'reservationId': reservationId,
      'utilisateurId': utilisateurId,
      'montant': montant,
      if (raison != null) 'raison': raison,
      if (statut != null) 'statut': statut,
      if (stripeRefundId != null) 'stripeRefundId': stripeRefundId,
      'dateDemandeRemboursement': dateDemandeRemboursement.toJson(),
      if (dateRemboursement != null)
        'dateRemboursement': dateRemboursement?.toJson(),
      if (traitePar != null) 'traitePar': traitePar,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Remboursement',
      if (id != null) 'id': id,
      'paiementId': paiementId,
      'reservationId': reservationId,
      'utilisateurId': utilisateurId,
      'montant': montant,
      if (raison != null) 'raison': raison,
      if (statut != null) 'statut': statut,
      if (stripeRefundId != null) 'stripeRefundId': stripeRefundId,
      'dateDemandeRemboursement': dateDemandeRemboursement.toJson(),
      if (dateRemboursement != null)
        'dateRemboursement': dateRemboursement?.toJson(),
      if (traitePar != null) 'traitePar': traitePar,
    };
  }

  static RemboursementInclude include() {
    return RemboursementInclude._();
  }

  static RemboursementIncludeList includeList({
    _i1.WhereExpressionBuilder<RemboursementTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RemboursementTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RemboursementTable>? orderByList,
    RemboursementInclude? include,
  }) {
    return RemboursementIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Remboursement.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Remboursement.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RemboursementImpl extends Remboursement {
  _RemboursementImpl({
    int? id,
    required int paiementId,
    required int reservationId,
    required int utilisateurId,
    required double montant,
    String? raison,
    String? statut,
    String? stripeRefundId,
    required DateTime dateDemandeRemboursement,
    DateTime? dateRemboursement,
    int? traitePar,
  }) : super._(
         id: id,
         paiementId: paiementId,
         reservationId: reservationId,
         utilisateurId: utilisateurId,
         montant: montant,
         raison: raison,
         statut: statut,
         stripeRefundId: stripeRefundId,
         dateDemandeRemboursement: dateDemandeRemboursement,
         dateRemboursement: dateRemboursement,
         traitePar: traitePar,
       );

  /// Returns a shallow copy of this [Remboursement]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Remboursement copyWith({
    Object? id = _Undefined,
    int? paiementId,
    int? reservationId,
    int? utilisateurId,
    double? montant,
    Object? raison = _Undefined,
    Object? statut = _Undefined,
    Object? stripeRefundId = _Undefined,
    DateTime? dateDemandeRemboursement,
    Object? dateRemboursement = _Undefined,
    Object? traitePar = _Undefined,
  }) {
    return Remboursement(
      id: id is int? ? id : this.id,
      paiementId: paiementId ?? this.paiementId,
      reservationId: reservationId ?? this.reservationId,
      utilisateurId: utilisateurId ?? this.utilisateurId,
      montant: montant ?? this.montant,
      raison: raison is String? ? raison : this.raison,
      statut: statut is String? ? statut : this.statut,
      stripeRefundId: stripeRefundId is String?
          ? stripeRefundId
          : this.stripeRefundId,
      dateDemandeRemboursement:
          dateDemandeRemboursement ?? this.dateDemandeRemboursement,
      dateRemboursement: dateRemboursement is DateTime?
          ? dateRemboursement
          : this.dateRemboursement,
      traitePar: traitePar is int? ? traitePar : this.traitePar,
    );
  }
}

class RemboursementUpdateTable extends _i1.UpdateTable<RemboursementTable> {
  RemboursementUpdateTable(super.table);

  _i1.ColumnValue<int, int> paiementId(int value) => _i1.ColumnValue(
    table.paiementId,
    value,
  );

  _i1.ColumnValue<int, int> reservationId(int value) => _i1.ColumnValue(
    table.reservationId,
    value,
  );

  _i1.ColumnValue<int, int> utilisateurId(int value) => _i1.ColumnValue(
    table.utilisateurId,
    value,
  );

  _i1.ColumnValue<double, double> montant(double value) => _i1.ColumnValue(
    table.montant,
    value,
  );

  _i1.ColumnValue<String, String> raison(String? value) => _i1.ColumnValue(
    table.raison,
    value,
  );

  _i1.ColumnValue<String, String> statut(String? value) => _i1.ColumnValue(
    table.statut,
    value,
  );

  _i1.ColumnValue<String, String> stripeRefundId(String? value) =>
      _i1.ColumnValue(
        table.stripeRefundId,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> dateDemandeRemboursement(
    DateTime value,
  ) => _i1.ColumnValue(
    table.dateDemandeRemboursement,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> dateRemboursement(DateTime? value) =>
      _i1.ColumnValue(
        table.dateRemboursement,
        value,
      );

  _i1.ColumnValue<int, int> traitePar(int? value) => _i1.ColumnValue(
    table.traitePar,
    value,
  );
}

class RemboursementTable extends _i1.Table<int?> {
  RemboursementTable({super.tableRelation})
    : super(tableName: 'remboursements') {
    updateTable = RemboursementUpdateTable(this);
    paiementId = _i1.ColumnInt(
      'paiementId',
      this,
    );
    reservationId = _i1.ColumnInt(
      'reservationId',
      this,
    );
    utilisateurId = _i1.ColumnInt(
      'utilisateurId',
      this,
    );
    montant = _i1.ColumnDouble(
      'montant',
      this,
    );
    raison = _i1.ColumnString(
      'raison',
      this,
    );
    statut = _i1.ColumnString(
      'statut',
      this,
      hasDefault: true,
    );
    stripeRefundId = _i1.ColumnString(
      'stripeRefundId',
      this,
    );
    dateDemandeRemboursement = _i1.ColumnDateTime(
      'dateDemandeRemboursement',
      this,
    );
    dateRemboursement = _i1.ColumnDateTime(
      'dateRemboursement',
      this,
    );
    traitePar = _i1.ColumnInt(
      'traitePar',
      this,
    );
  }

  late final RemboursementUpdateTable updateTable;

  late final _i1.ColumnInt paiementId;

  late final _i1.ColumnInt reservationId;

  late final _i1.ColumnInt utilisateurId;

  late final _i1.ColumnDouble montant;

  late final _i1.ColumnString raison;

  late final _i1.ColumnString statut;

  late final _i1.ColumnString stripeRefundId;

  late final _i1.ColumnDateTime dateDemandeRemboursement;

  late final _i1.ColumnDateTime dateRemboursement;

  late final _i1.ColumnInt traitePar;

  @override
  List<_i1.Column> get columns => [
    id,
    paiementId,
    reservationId,
    utilisateurId,
    montant,
    raison,
    statut,
    stripeRefundId,
    dateDemandeRemboursement,
    dateRemboursement,
    traitePar,
  ];
}

class RemboursementInclude extends _i1.IncludeObject {
  RemboursementInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Remboursement.t;
}

class RemboursementIncludeList extends _i1.IncludeList {
  RemboursementIncludeList._({
    _i1.WhereExpressionBuilder<RemboursementTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Remboursement.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Remboursement.t;
}

class RemboursementRepository {
  const RemboursementRepository._();

  /// Returns a list of [Remboursement]s matching the given query parameters.
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
  Future<List<Remboursement>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RemboursementTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RemboursementTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RemboursementTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Remboursement>(
      where: where?.call(Remboursement.t),
      orderBy: orderBy?.call(Remboursement.t),
      orderByList: orderByList?.call(Remboursement.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Remboursement] matching the given query parameters.
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
  Future<Remboursement?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RemboursementTable>? where,
    int? offset,
    _i1.OrderByBuilder<RemboursementTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RemboursementTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Remboursement>(
      where: where?.call(Remboursement.t),
      orderBy: orderBy?.call(Remboursement.t),
      orderByList: orderByList?.call(Remboursement.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Remboursement] by its [id] or null if no such row exists.
  Future<Remboursement?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Remboursement>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Remboursement]s in the list and returns the inserted rows.
  ///
  /// The returned [Remboursement]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Remboursement>> insert(
    _i1.Session session,
    List<Remboursement> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Remboursement>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Remboursement] and returns the inserted row.
  ///
  /// The returned [Remboursement] will have its `id` field set.
  Future<Remboursement> insertRow(
    _i1.Session session,
    Remboursement row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Remboursement>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Remboursement]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Remboursement>> update(
    _i1.Session session,
    List<Remboursement> rows, {
    _i1.ColumnSelections<RemboursementTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Remboursement>(
      rows,
      columns: columns?.call(Remboursement.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Remboursement]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Remboursement> updateRow(
    _i1.Session session,
    Remboursement row, {
    _i1.ColumnSelections<RemboursementTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Remboursement>(
      row,
      columns: columns?.call(Remboursement.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Remboursement] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Remboursement?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<RemboursementUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Remboursement>(
      id,
      columnValues: columnValues(Remboursement.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Remboursement]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Remboursement>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<RemboursementUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<RemboursementTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RemboursementTable>? orderBy,
    _i1.OrderByListBuilder<RemboursementTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Remboursement>(
      columnValues: columnValues(Remboursement.t.updateTable),
      where: where(Remboursement.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Remboursement.t),
      orderByList: orderByList?.call(Remboursement.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Remboursement]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Remboursement>> delete(
    _i1.Session session,
    List<Remboursement> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Remboursement>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Remboursement].
  Future<Remboursement> deleteRow(
    _i1.Session session,
    Remboursement row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Remboursement>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Remboursement>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<RemboursementTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Remboursement>(
      where: where(Remboursement.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RemboursementTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Remboursement>(
      where: where?.call(Remboursement.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
