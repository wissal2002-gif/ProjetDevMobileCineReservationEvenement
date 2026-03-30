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

abstract class Favori implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Favori._({
    this.id,
    required this.utilisateurId,
    this.filmId,
    this.cinemaId,
  });

  factory Favori({
    int? id,
    required int utilisateurId,
    int? filmId,
    int? cinemaId,
  }) = _FavoriImpl;

  factory Favori.fromJson(Map<String, dynamic> jsonSerialization) {
    return Favori(
      id: jsonSerialization['id'] as int?,
      utilisateurId: jsonSerialization['utilisateurId'] as int,
      filmId: jsonSerialization['filmId'] as int?,
      cinemaId: jsonSerialization['cinemaId'] as int?,
    );
  }

  static final t = FavoriTable();

  static const db = FavoriRepository._();

  @override
  int? id;

  int utilisateurId;

  int? filmId;

  int? cinemaId;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Favori]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Favori copyWith({
    int? id,
    int? utilisateurId,
    int? filmId,
    int? cinemaId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Favori',
      if (id != null) 'id': id,
      'utilisateurId': utilisateurId,
      if (filmId != null) 'filmId': filmId,
      if (cinemaId != null) 'cinemaId': cinemaId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Favori',
      if (id != null) 'id': id,
      'utilisateurId': utilisateurId,
      if (filmId != null) 'filmId': filmId,
      if (cinemaId != null) 'cinemaId': cinemaId,
    };
  }

  static FavoriInclude include() {
    return FavoriInclude._();
  }

  static FavoriIncludeList includeList({
    _i1.WhereExpressionBuilder<FavoriTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FavoriTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FavoriTable>? orderByList,
    FavoriInclude? include,
  }) {
    return FavoriIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Favori.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Favori.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FavoriImpl extends Favori {
  _FavoriImpl({
    int? id,
    required int utilisateurId,
    int? filmId,
    int? cinemaId,
  }) : super._(
         id: id,
         utilisateurId: utilisateurId,
         filmId: filmId,
         cinemaId: cinemaId,
       );

  /// Returns a shallow copy of this [Favori]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Favori copyWith({
    Object? id = _Undefined,
    int? utilisateurId,
    Object? filmId = _Undefined,
    Object? cinemaId = _Undefined,
  }) {
    return Favori(
      id: id is int? ? id : this.id,
      utilisateurId: utilisateurId ?? this.utilisateurId,
      filmId: filmId is int? ? filmId : this.filmId,
      cinemaId: cinemaId is int? ? cinemaId : this.cinemaId,
    );
  }
}

class FavoriUpdateTable extends _i1.UpdateTable<FavoriTable> {
  FavoriUpdateTable(super.table);

  _i1.ColumnValue<int, int> utilisateurId(int value) => _i1.ColumnValue(
    table.utilisateurId,
    value,
  );

  _i1.ColumnValue<int, int> filmId(int? value) => _i1.ColumnValue(
    table.filmId,
    value,
  );

  _i1.ColumnValue<int, int> cinemaId(int? value) => _i1.ColumnValue(
    table.cinemaId,
    value,
  );
}

class FavoriTable extends _i1.Table<int?> {
  FavoriTable({super.tableRelation}) : super(tableName: 'favoris') {
    updateTable = FavoriUpdateTable(this);
    utilisateurId = _i1.ColumnInt(
      'utilisateurId',
      this,
    );
    filmId = _i1.ColumnInt(
      'filmId',
      this,
    );
    cinemaId = _i1.ColumnInt(
      'cinemaId',
      this,
    );
  }

  late final FavoriUpdateTable updateTable;

  late final _i1.ColumnInt utilisateurId;

  late final _i1.ColumnInt filmId;

  late final _i1.ColumnInt cinemaId;

  @override
  List<_i1.Column> get columns => [
    id,
    utilisateurId,
    filmId,
    cinemaId,
  ];
}

class FavoriInclude extends _i1.IncludeObject {
  FavoriInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Favori.t;
}

class FavoriIncludeList extends _i1.IncludeList {
  FavoriIncludeList._({
    _i1.WhereExpressionBuilder<FavoriTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Favori.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Favori.t;
}

class FavoriRepository {
  const FavoriRepository._();

  /// Returns a list of [Favori]s matching the given query parameters.
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
  Future<List<Favori>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FavoriTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FavoriTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FavoriTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Favori>(
      where: where?.call(Favori.t),
      orderBy: orderBy?.call(Favori.t),
      orderByList: orderByList?.call(Favori.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Favori] matching the given query parameters.
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
  Future<Favori?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FavoriTable>? where,
    int? offset,
    _i1.OrderByBuilder<FavoriTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FavoriTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Favori>(
      where: where?.call(Favori.t),
      orderBy: orderBy?.call(Favori.t),
      orderByList: orderByList?.call(Favori.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Favori] by its [id] or null if no such row exists.
  Future<Favori?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Favori>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Favori]s in the list and returns the inserted rows.
  ///
  /// The returned [Favori]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<Favori>> insert(
    _i1.DatabaseSession session,
    List<Favori> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Favori>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Favori] and returns the inserted row.
  ///
  /// The returned [Favori] will have its `id` field set.
  Future<Favori> insertRow(
    _i1.DatabaseSession session,
    Favori row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Favori>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Favori]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Favori>> update(
    _i1.DatabaseSession session,
    List<Favori> rows, {
    _i1.ColumnSelections<FavoriTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Favori>(
      rows,
      columns: columns?.call(Favori.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Favori]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Favori> updateRow(
    _i1.DatabaseSession session,
    Favori row, {
    _i1.ColumnSelections<FavoriTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Favori>(
      row,
      columns: columns?.call(Favori.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Favori] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Favori?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<FavoriUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Favori>(
      id,
      columnValues: columnValues(Favori.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Favori]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Favori>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<FavoriUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<FavoriTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FavoriTable>? orderBy,
    _i1.OrderByListBuilder<FavoriTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Favori>(
      columnValues: columnValues(Favori.t.updateTable),
      where: where(Favori.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Favori.t),
      orderByList: orderByList?.call(Favori.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Favori]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Favori>> delete(
    _i1.DatabaseSession session,
    List<Favori> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Favori>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Favori].
  Future<Favori> deleteRow(
    _i1.DatabaseSession session,
    Favori row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Favori>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Favori>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<FavoriTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Favori>(
      where: where(Favori.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FavoriTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Favori>(
      where: where?.call(Favori.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Favori] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<FavoriTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Favori>(
      where: where(Favori.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
