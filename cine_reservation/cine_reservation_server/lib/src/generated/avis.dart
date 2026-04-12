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

abstract class Avis implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Avis._({
    this.id,
    required this.utilisateurId,
    required this.filmId,
    required this.note,
    required this.dateAvis,
  });

  factory Avis({
    int? id,
    required int utilisateurId,
    required int filmId,
    required int note,
    required DateTime dateAvis,
  }) = _AvisImpl;

  factory Avis.fromJson(Map<String, dynamic> jsonSerialization) {
    return Avis(
      id: jsonSerialization['id'] as int?,
      utilisateurId: jsonSerialization['utilisateurId'] as int,
      filmId: jsonSerialization['filmId'] as int,
      note: jsonSerialization['note'] as int,
      dateAvis: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['dateAvis'],
      ),
    );
  }

  static final t = AvisTable();

  static const db = AvisRepository._();

  @override
  int? id;

  int utilisateurId;

  int filmId;

  int note;

  DateTime dateAvis;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Avis]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Avis copyWith({
    int? id,
    int? utilisateurId,
    int? filmId,
    int? note,
    DateTime? dateAvis,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Avis',
      if (id != null) 'id': id,
      'utilisateurId': utilisateurId,
      'filmId': filmId,
      'note': note,
      'dateAvis': dateAvis.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Avis',
      if (id != null) 'id': id,
      'utilisateurId': utilisateurId,
      'filmId': filmId,
      'note': note,
      'dateAvis': dateAvis.toJson(),
    };
  }

  static AvisInclude include() {
    return AvisInclude._();
  }

  static AvisIncludeList includeList({
    _i1.WhereExpressionBuilder<AvisTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AvisTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AvisTable>? orderByList,
    AvisInclude? include,
  }) {
    return AvisIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Avis.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Avis.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AvisImpl extends Avis {
  _AvisImpl({
    int? id,
    required int utilisateurId,
    required int filmId,
    required int note,
    required DateTime dateAvis,
  }) : super._(
         id: id,
         utilisateurId: utilisateurId,
         filmId: filmId,
         note: note,
         dateAvis: dateAvis,
       );

  /// Returns a shallow copy of this [Avis]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Avis copyWith({
    Object? id = _Undefined,
    int? utilisateurId,
    int? filmId,
    int? note,
    DateTime? dateAvis,
  }) {
    return Avis(
      id: id is int? ? id : this.id,
      utilisateurId: utilisateurId ?? this.utilisateurId,
      filmId: filmId ?? this.filmId,
      note: note ?? this.note,
      dateAvis: dateAvis ?? this.dateAvis,
    );
  }
}

class AvisUpdateTable extends _i1.UpdateTable<AvisTable> {
  AvisUpdateTable(super.table);

  _i1.ColumnValue<int, int> utilisateurId(int value) => _i1.ColumnValue(
    table.utilisateurId,
    value,
  );

  _i1.ColumnValue<int, int> filmId(int value) => _i1.ColumnValue(
    table.filmId,
    value,
  );

  _i1.ColumnValue<int, int> note(int value) => _i1.ColumnValue(
    table.note,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> dateAvis(DateTime value) =>
      _i1.ColumnValue(
        table.dateAvis,
        value,
      );
}

class AvisTable extends _i1.Table<int?> {
  AvisTable({super.tableRelation}) : super(tableName: 'avis') {
    updateTable = AvisUpdateTable(this);
    utilisateurId = _i1.ColumnInt(
      'utilisateurId',
      this,
    );
    filmId = _i1.ColumnInt(
      'filmId',
      this,
    );
    note = _i1.ColumnInt(
      'note',
      this,
    );
    dateAvis = _i1.ColumnDateTime(
      'dateAvis',
      this,
    );
  }

  late final AvisUpdateTable updateTable;

  late final _i1.ColumnInt utilisateurId;

  late final _i1.ColumnInt filmId;

  late final _i1.ColumnInt note;

  late final _i1.ColumnDateTime dateAvis;

  @override
  List<_i1.Column> get columns => [
    id,
    utilisateurId,
    filmId,
    note,
    dateAvis,
  ];
}

class AvisInclude extends _i1.IncludeObject {
  AvisInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Avis.t;
}

class AvisIncludeList extends _i1.IncludeList {
  AvisIncludeList._({
    _i1.WhereExpressionBuilder<AvisTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Avis.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Avis.t;
}

class AvisRepository {
  const AvisRepository._();

  /// Returns a list of [Avis]s matching the given query parameters.
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
  Future<List<Avis>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AvisTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AvisTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AvisTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Avis>(
      where: where?.call(Avis.t),
      orderBy: orderBy?.call(Avis.t),
      orderByList: orderByList?.call(Avis.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Avis] matching the given query parameters.
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
  Future<Avis?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AvisTable>? where,
    int? offset,
    _i1.OrderByBuilder<AvisTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AvisTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Avis>(
      where: where?.call(Avis.t),
      orderBy: orderBy?.call(Avis.t),
      orderByList: orderByList?.call(Avis.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Avis] by its [id] or null if no such row exists.
  Future<Avis?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Avis>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Avis]s in the list and returns the inserted rows.
  ///
  /// The returned [Avis]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Avis>> insert(
    _i1.Session session,
    List<Avis> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Avis>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Avis] and returns the inserted row.
  ///
  /// The returned [Avis] will have its `id` field set.
  Future<Avis> insertRow(
    _i1.Session session,
    Avis row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Avis>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Avis]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Avis>> update(
    _i1.Session session,
    List<Avis> rows, {
    _i1.ColumnSelections<AvisTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Avis>(
      rows,
      columns: columns?.call(Avis.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Avis]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Avis> updateRow(
    _i1.Session session,
    Avis row, {
    _i1.ColumnSelections<AvisTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Avis>(
      row,
      columns: columns?.call(Avis.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Avis] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Avis?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<AvisUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Avis>(
      id,
      columnValues: columnValues(Avis.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Avis]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Avis>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<AvisUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<AvisTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AvisTable>? orderBy,
    _i1.OrderByListBuilder<AvisTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Avis>(
      columnValues: columnValues(Avis.t.updateTable),
      where: where(Avis.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Avis.t),
      orderByList: orderByList?.call(Avis.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Avis]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Avis>> delete(
    _i1.Session session,
    List<Avis> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Avis>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Avis].
  Future<Avis> deleteRow(
    _i1.Session session,
    Avis row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Avis>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Avis>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AvisTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Avis>(
      where: where(Avis.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AvisTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Avis>(
      where: where?.call(Avis.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
