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

abstract class Fidelite
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Fidelite._({
    this.id,
    required this.utilisateurId,
    int? points,
    String? niveau,
    double? totalDepense,
    this.dateAdhesion,
  }) : points = points ?? 0,
       niveau = niveau ?? 'bronze',
       totalDepense = totalDepense ?? 0.0;

  factory Fidelite({
    int? id,
    required int utilisateurId,
    int? points,
    String? niveau,
    double? totalDepense,
    DateTime? dateAdhesion,
  }) = _FideliteImpl;

  factory Fidelite.fromJson(Map<String, dynamic> jsonSerialization) {
    return Fidelite(
      id: jsonSerialization['id'] as int?,
      utilisateurId: jsonSerialization['utilisateurId'] as int,
      points: jsonSerialization['points'] as int?,
      niveau: jsonSerialization['niveau'] as String?,
      totalDepense: (jsonSerialization['totalDepense'] as num?)?.toDouble(),
      dateAdhesion: jsonSerialization['dateAdhesion'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['dateAdhesion'],
            ),
    );
  }

  static final t = FideliteTable();

  static const db = FideliteRepository._();

  @override
  int? id;

  int utilisateurId;

  int? points;

  String? niveau;

  double? totalDepense;

  DateTime? dateAdhesion;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Fidelite]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Fidelite copyWith({
    int? id,
    int? utilisateurId,
    int? points,
    String? niveau,
    double? totalDepense,
    DateTime? dateAdhesion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Fidelite',
      if (id != null) 'id': id,
      'utilisateurId': utilisateurId,
      if (points != null) 'points': points,
      if (niveau != null) 'niveau': niveau,
      if (totalDepense != null) 'totalDepense': totalDepense,
      if (dateAdhesion != null) 'dateAdhesion': dateAdhesion?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Fidelite',
      if (id != null) 'id': id,
      'utilisateurId': utilisateurId,
      if (points != null) 'points': points,
      if (niveau != null) 'niveau': niveau,
      if (totalDepense != null) 'totalDepense': totalDepense,
      if (dateAdhesion != null) 'dateAdhesion': dateAdhesion?.toJson(),
    };
  }

  static FideliteInclude include() {
    return FideliteInclude._();
  }

  static FideliteIncludeList includeList({
    _i1.WhereExpressionBuilder<FideliteTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FideliteTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FideliteTable>? orderByList,
    FideliteInclude? include,
  }) {
    return FideliteIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Fidelite.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Fidelite.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FideliteImpl extends Fidelite {
  _FideliteImpl({
    int? id,
    required int utilisateurId,
    int? points,
    String? niveau,
    double? totalDepense,
    DateTime? dateAdhesion,
  }) : super._(
         id: id,
         utilisateurId: utilisateurId,
         points: points,
         niveau: niveau,
         totalDepense: totalDepense,
         dateAdhesion: dateAdhesion,
       );

  /// Returns a shallow copy of this [Fidelite]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Fidelite copyWith({
    Object? id = _Undefined,
    int? utilisateurId,
    Object? points = _Undefined,
    Object? niveau = _Undefined,
    Object? totalDepense = _Undefined,
    Object? dateAdhesion = _Undefined,
  }) {
    return Fidelite(
      id: id is int? ? id : this.id,
      utilisateurId: utilisateurId ?? this.utilisateurId,
      points: points is int? ? points : this.points,
      niveau: niveau is String? ? niveau : this.niveau,
      totalDepense: totalDepense is double? ? totalDepense : this.totalDepense,
      dateAdhesion: dateAdhesion is DateTime?
          ? dateAdhesion
          : this.dateAdhesion,
    );
  }
}

class FideliteUpdateTable extends _i1.UpdateTable<FideliteTable> {
  FideliteUpdateTable(super.table);

  _i1.ColumnValue<int, int> utilisateurId(int value) => _i1.ColumnValue(
    table.utilisateurId,
    value,
  );

  _i1.ColumnValue<int, int> points(int? value) => _i1.ColumnValue(
    table.points,
    value,
  );

  _i1.ColumnValue<String, String> niveau(String? value) => _i1.ColumnValue(
    table.niveau,
    value,
  );

  _i1.ColumnValue<double, double> totalDepense(double? value) =>
      _i1.ColumnValue(
        table.totalDepense,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> dateAdhesion(DateTime? value) =>
      _i1.ColumnValue(
        table.dateAdhesion,
        value,
      );
}

class FideliteTable extends _i1.Table<int?> {
  FideliteTable({super.tableRelation}) : super(tableName: 'fidelite') {
    updateTable = FideliteUpdateTable(this);
    utilisateurId = _i1.ColumnInt(
      'utilisateurId',
      this,
    );
    points = _i1.ColumnInt(
      'points',
      this,
      hasDefault: true,
    );
    niveau = _i1.ColumnString(
      'niveau',
      this,
      hasDefault: true,
    );
    totalDepense = _i1.ColumnDouble(
      'totalDepense',
      this,
      hasDefault: true,
    );
    dateAdhesion = _i1.ColumnDateTime(
      'dateAdhesion',
      this,
    );
  }

  late final FideliteUpdateTable updateTable;

  late final _i1.ColumnInt utilisateurId;

  late final _i1.ColumnInt points;

  late final _i1.ColumnString niveau;

  late final _i1.ColumnDouble totalDepense;

  late final _i1.ColumnDateTime dateAdhesion;

  @override
  List<_i1.Column> get columns => [
    id,
    utilisateurId,
    points,
    niveau,
    totalDepense,
    dateAdhesion,
  ];
}

class FideliteInclude extends _i1.IncludeObject {
  FideliteInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Fidelite.t;
}

class FideliteIncludeList extends _i1.IncludeList {
  FideliteIncludeList._({
    _i1.WhereExpressionBuilder<FideliteTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Fidelite.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Fidelite.t;
}

class FideliteRepository {
  const FideliteRepository._();

  /// Returns a list of [Fidelite]s matching the given query parameters.
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
  Future<List<Fidelite>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FideliteTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FideliteTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FideliteTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Fidelite>(
      where: where?.call(Fidelite.t),
      orderBy: orderBy?.call(Fidelite.t),
      orderByList: orderByList?.call(Fidelite.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Fidelite] matching the given query parameters.
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
  Future<Fidelite?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FideliteTable>? where,
    int? offset,
    _i1.OrderByBuilder<FideliteTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FideliteTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Fidelite>(
      where: where?.call(Fidelite.t),
      orderBy: orderBy?.call(Fidelite.t),
      orderByList: orderByList?.call(Fidelite.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Fidelite] by its [id] or null if no such row exists.
  Future<Fidelite?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Fidelite>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Fidelite]s in the list and returns the inserted rows.
  ///
  /// The returned [Fidelite]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<Fidelite>> insert(
    _i1.DatabaseSession session,
    List<Fidelite> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Fidelite>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Fidelite] and returns the inserted row.
  ///
  /// The returned [Fidelite] will have its `id` field set.
  Future<Fidelite> insertRow(
    _i1.DatabaseSession session,
    Fidelite row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Fidelite>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Fidelite]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Fidelite>> update(
    _i1.DatabaseSession session,
    List<Fidelite> rows, {
    _i1.ColumnSelections<FideliteTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Fidelite>(
      rows,
      columns: columns?.call(Fidelite.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Fidelite]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Fidelite> updateRow(
    _i1.DatabaseSession session,
    Fidelite row, {
    _i1.ColumnSelections<FideliteTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Fidelite>(
      row,
      columns: columns?.call(Fidelite.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Fidelite] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Fidelite?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<FideliteUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Fidelite>(
      id,
      columnValues: columnValues(Fidelite.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Fidelite]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Fidelite>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<FideliteUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<FideliteTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FideliteTable>? orderBy,
    _i1.OrderByListBuilder<FideliteTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Fidelite>(
      columnValues: columnValues(Fidelite.t.updateTable),
      where: where(Fidelite.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Fidelite.t),
      orderByList: orderByList?.call(Fidelite.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Fidelite]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Fidelite>> delete(
    _i1.DatabaseSession session,
    List<Fidelite> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Fidelite>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Fidelite].
  Future<Fidelite> deleteRow(
    _i1.DatabaseSession session,
    Fidelite row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Fidelite>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Fidelite>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<FideliteTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Fidelite>(
      where: where(Fidelite.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FideliteTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Fidelite>(
      where: where?.call(Fidelite.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Fidelite] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<FideliteTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Fidelite>(
      where: where(Fidelite.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
