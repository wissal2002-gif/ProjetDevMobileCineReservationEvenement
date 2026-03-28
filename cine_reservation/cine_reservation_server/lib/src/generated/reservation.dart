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

abstract class Reservation
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Reservation._({
    this.id,
    required this.utilisateurId,
    this.seanceId,
    this.cinemaId,
    this.evenementId,
    String? typeReservation,
    required this.dateReservation,
    required this.montantTotal,
    this.montantApresReduction,
    String? statut,
    this.codePromoId,
  }) : typeReservation = typeReservation ?? 'cinema',
       statut = statut ?? 'en_attente';

  factory Reservation({
    int? id,
    required int utilisateurId,
    int? seanceId,
    int? cinemaId,
    int? evenementId,
    String? typeReservation,
    required DateTime dateReservation,
    required double montantTotal,
    double? montantApresReduction,
    String? statut,
    int? codePromoId,
  }) = _ReservationImpl;

  factory Reservation.fromJson(Map<String, dynamic> jsonSerialization) {
    return Reservation(
      id: jsonSerialization['id'] as int?,
      utilisateurId: jsonSerialization['utilisateurId'] as int,
      seanceId: jsonSerialization['seanceId'] as int?,
      cinemaId: jsonSerialization['cinemaId'] as int?,
      evenementId: jsonSerialization['evenementId'] as int?,
      typeReservation: jsonSerialization['typeReservation'] as String?,
      dateReservation: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['dateReservation'],
      ),
      montantTotal: (jsonSerialization['montantTotal'] as num).toDouble(),
      montantApresReduction:
          (jsonSerialization['montantApresReduction'] as num?)?.toDouble(),
      statut: jsonSerialization['statut'] as String?,
      codePromoId: jsonSerialization['codePromoId'] as int?,
    );
  }

  static final t = ReservationTable();

  static const db = ReservationRepository._();

  @override
  int? id;

  int utilisateurId;

  int? seanceId;

  int? cinemaId;

  int? evenementId;

  String? typeReservation;

  DateTime dateReservation;

  double montantTotal;

  double? montantApresReduction;

  String? statut;

  int? codePromoId;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Reservation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Reservation copyWith({
    int? id,
    int? utilisateurId,
    int? seanceId,
    int? cinemaId,
    int? evenementId,
    String? typeReservation,
    DateTime? dateReservation,
    double? montantTotal,
    double? montantApresReduction,
    String? statut,
    int? codePromoId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Reservation',
      if (id != null) 'id': id,
      'utilisateurId': utilisateurId,
      if (seanceId != null) 'seanceId': seanceId,
      if (cinemaId != null) 'cinemaId': cinemaId,
      if (evenementId != null) 'evenementId': evenementId,
      if (typeReservation != null) 'typeReservation': typeReservation,
      'dateReservation': dateReservation.toJson(),
      'montantTotal': montantTotal,
      if (montantApresReduction != null)
        'montantApresReduction': montantApresReduction,
      if (statut != null) 'statut': statut,
      if (codePromoId != null) 'codePromoId': codePromoId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Reservation',
      if (id != null) 'id': id,
      'utilisateurId': utilisateurId,
      if (seanceId != null) 'seanceId': seanceId,
      if (cinemaId != null) 'cinemaId': cinemaId,
      if (evenementId != null) 'evenementId': evenementId,
      if (typeReservation != null) 'typeReservation': typeReservation,
      'dateReservation': dateReservation.toJson(),
      'montantTotal': montantTotal,
      if (montantApresReduction != null)
        'montantApresReduction': montantApresReduction,
      if (statut != null) 'statut': statut,
      if (codePromoId != null) 'codePromoId': codePromoId,
    };
  }

  static ReservationInclude include() {
    return ReservationInclude._();
  }

  static ReservationIncludeList includeList({
    _i1.WhereExpressionBuilder<ReservationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReservationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReservationTable>? orderByList,
    ReservationInclude? include,
  }) {
    return ReservationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Reservation.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Reservation.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReservationImpl extends Reservation {
  _ReservationImpl({
    int? id,
    required int utilisateurId,
    int? seanceId,
    int? cinemaId,
    int? evenementId,
    String? typeReservation,
    required DateTime dateReservation,
    required double montantTotal,
    double? montantApresReduction,
    String? statut,
    int? codePromoId,
  }) : super._(
         id: id,
         utilisateurId: utilisateurId,
         seanceId: seanceId,
         cinemaId: cinemaId,
         evenementId: evenementId,
         typeReservation: typeReservation,
         dateReservation: dateReservation,
         montantTotal: montantTotal,
         montantApresReduction: montantApresReduction,
         statut: statut,
         codePromoId: codePromoId,
       );

  /// Returns a shallow copy of this [Reservation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Reservation copyWith({
    Object? id = _Undefined,
    int? utilisateurId,
    Object? seanceId = _Undefined,
    Object? cinemaId = _Undefined,
    Object? evenementId = _Undefined,
    Object? typeReservation = _Undefined,
    DateTime? dateReservation,
    double? montantTotal,
    Object? montantApresReduction = _Undefined,
    Object? statut = _Undefined,
    Object? codePromoId = _Undefined,
  }) {
    return Reservation(
      id: id is int? ? id : this.id,
      utilisateurId: utilisateurId ?? this.utilisateurId,
      seanceId: seanceId is int? ? seanceId : this.seanceId,
      cinemaId: cinemaId is int? ? cinemaId : this.cinemaId,
      evenementId: evenementId is int? ? evenementId : this.evenementId,
      typeReservation: typeReservation is String?
          ? typeReservation
          : this.typeReservation,
      dateReservation: dateReservation ?? this.dateReservation,
      montantTotal: montantTotal ?? this.montantTotal,
      montantApresReduction: montantApresReduction is double?
          ? montantApresReduction
          : this.montantApresReduction,
      statut: statut is String? ? statut : this.statut,
      codePromoId: codePromoId is int? ? codePromoId : this.codePromoId,
    );
  }
}

class ReservationUpdateTable extends _i1.UpdateTable<ReservationTable> {
  ReservationUpdateTable(super.table);

  _i1.ColumnValue<int, int> utilisateurId(int value) => _i1.ColumnValue(
    table.utilisateurId,
    value,
  );

  _i1.ColumnValue<int, int> seanceId(int? value) => _i1.ColumnValue(
    table.seanceId,
    value,
  );

  _i1.ColumnValue<int, int> cinemaId(int? value) => _i1.ColumnValue(
    table.cinemaId,
    value,
  );

  _i1.ColumnValue<int, int> evenementId(int? value) => _i1.ColumnValue(
    table.evenementId,
    value,
  );

  _i1.ColumnValue<String, String> typeReservation(String? value) =>
      _i1.ColumnValue(
        table.typeReservation,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> dateReservation(DateTime value) =>
      _i1.ColumnValue(
        table.dateReservation,
        value,
      );

  _i1.ColumnValue<double, double> montantTotal(double value) => _i1.ColumnValue(
    table.montantTotal,
    value,
  );

  _i1.ColumnValue<double, double> montantApresReduction(double? value) =>
      _i1.ColumnValue(
        table.montantApresReduction,
        value,
      );

  _i1.ColumnValue<String, String> statut(String? value) => _i1.ColumnValue(
    table.statut,
    value,
  );

  _i1.ColumnValue<int, int> codePromoId(int? value) => _i1.ColumnValue(
    table.codePromoId,
    value,
  );
}

class ReservationTable extends _i1.Table<int?> {
  ReservationTable({super.tableRelation}) : super(tableName: 'reservations') {
    updateTable = ReservationUpdateTable(this);
    utilisateurId = _i1.ColumnInt(
      'utilisateurId',
      this,
    );
    seanceId = _i1.ColumnInt(
      'seanceId',
      this,
    );
    cinemaId = _i1.ColumnInt(
      'cinemaId',
      this,
    );
    evenementId = _i1.ColumnInt(
      'evenementId',
      this,
    );
    typeReservation = _i1.ColumnString(
      'typeReservation',
      this,
      hasDefault: true,
    );
    dateReservation = _i1.ColumnDateTime(
      'dateReservation',
      this,
    );
    montantTotal = _i1.ColumnDouble(
      'montantTotal',
      this,
    );
    montantApresReduction = _i1.ColumnDouble(
      'montantApresReduction',
      this,
    );
    statut = _i1.ColumnString(
      'statut',
      this,
      hasDefault: true,
    );
    codePromoId = _i1.ColumnInt(
      'codePromoId',
      this,
    );
  }

  late final ReservationUpdateTable updateTable;

  late final _i1.ColumnInt utilisateurId;

  late final _i1.ColumnInt seanceId;

  late final _i1.ColumnInt cinemaId;

  late final _i1.ColumnInt evenementId;

  late final _i1.ColumnString typeReservation;

  late final _i1.ColumnDateTime dateReservation;

  late final _i1.ColumnDouble montantTotal;

  late final _i1.ColumnDouble montantApresReduction;

  late final _i1.ColumnString statut;

  late final _i1.ColumnInt codePromoId;

  @override
  List<_i1.Column> get columns => [
    id,
    utilisateurId,
    seanceId,
    cinemaId,
    evenementId,
    typeReservation,
    dateReservation,
    montantTotal,
    montantApresReduction,
    statut,
    codePromoId,
  ];
}

class ReservationInclude extends _i1.IncludeObject {
  ReservationInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Reservation.t;
}

class ReservationIncludeList extends _i1.IncludeList {
  ReservationIncludeList._({
    _i1.WhereExpressionBuilder<ReservationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Reservation.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Reservation.t;
}

class ReservationRepository {
  const ReservationRepository._();

  /// Returns a list of [Reservation]s matching the given query parameters.
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
  Future<List<Reservation>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReservationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReservationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReservationTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Reservation>(
      where: where?.call(Reservation.t),
      orderBy: orderBy?.call(Reservation.t),
      orderByList: orderByList?.call(Reservation.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Reservation] matching the given query parameters.
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
  Future<Reservation?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReservationTable>? where,
    int? offset,
    _i1.OrderByBuilder<ReservationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReservationTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Reservation>(
      where: where?.call(Reservation.t),
      orderBy: orderBy?.call(Reservation.t),
      orderByList: orderByList?.call(Reservation.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Reservation] by its [id] or null if no such row exists.
  Future<Reservation?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Reservation>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Reservation]s in the list and returns the inserted rows.
  ///
  /// The returned [Reservation]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Reservation>> insert(
    _i1.Session session,
    List<Reservation> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Reservation>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Reservation] and returns the inserted row.
  ///
  /// The returned [Reservation] will have its `id` field set.
  Future<Reservation> insertRow(
    _i1.Session session,
    Reservation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Reservation>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Reservation]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Reservation>> update(
    _i1.Session session,
    List<Reservation> rows, {
    _i1.ColumnSelections<ReservationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Reservation>(
      rows,
      columns: columns?.call(Reservation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Reservation]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Reservation> updateRow(
    _i1.Session session,
    Reservation row, {
    _i1.ColumnSelections<ReservationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Reservation>(
      row,
      columns: columns?.call(Reservation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Reservation] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Reservation?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ReservationUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Reservation>(
      id,
      columnValues: columnValues(Reservation.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Reservation]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Reservation>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ReservationUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ReservationTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReservationTable>? orderBy,
    _i1.OrderByListBuilder<ReservationTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Reservation>(
      columnValues: columnValues(Reservation.t.updateTable),
      where: where(Reservation.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Reservation.t),
      orderByList: orderByList?.call(Reservation.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Reservation]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Reservation>> delete(
    _i1.Session session,
    List<Reservation> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Reservation>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Reservation].
  Future<Reservation> deleteRow(
    _i1.Session session,
    Reservation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Reservation>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Reservation>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ReservationTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Reservation>(
      where: where(Reservation.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReservationTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Reservation>(
      where: where?.call(Reservation.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
