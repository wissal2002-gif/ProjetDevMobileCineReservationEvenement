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

abstract class DemandeSupport
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  DemandeSupport._({
    this.id,
    required this.utilisateurId,
    this.cinemaId,
    required this.sujet,
    required this.message,
    String? statut,
    this.reponse,
    this.createdAt,
    this.updatedAt,
  }) : statut = statut ?? 'ouvert';

  factory DemandeSupport({
    int? id,
    required int utilisateurId,
    int? cinemaId,
    required String sujet,
    required String message,
    String? statut,
    String? reponse,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _DemandeSupportImpl;

  factory DemandeSupport.fromJson(Map<String, dynamic> jsonSerialization) {
    return DemandeSupport(
      id: jsonSerialization['id'] as int?,
      utilisateurId: jsonSerialization['utilisateurId'] as int,
      cinemaId: jsonSerialization['cinemaId'] as int?,
      sujet: jsonSerialization['sujet'] as String,
      message: jsonSerialization['message'] as String,
      statut: jsonSerialization['statut'] as String?,
      reponse: jsonSerialization['reponse'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = DemandeSupportTable();

  static const db = DemandeSupportRepository._();

  @override
  int? id;

  int utilisateurId;

  int? cinemaId;

  String sujet;

  String message;

  String? statut;

  String? reponse;

  DateTime? createdAt;

  DateTime? updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [DemandeSupport]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DemandeSupport copyWith({
    int? id,
    int? utilisateurId,
    int? cinemaId,
    String? sujet,
    String? message,
    String? statut,
    String? reponse,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DemandeSupport',
      if (id != null) 'id': id,
      'utilisateurId': utilisateurId,
      if (cinemaId != null) 'cinemaId': cinemaId,
      'sujet': sujet,
      'message': message,
      if (statut != null) 'statut': statut,
      if (reponse != null) 'reponse': reponse,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DemandeSupport',
      if (id != null) 'id': id,
      'utilisateurId': utilisateurId,
      if (cinemaId != null) 'cinemaId': cinemaId,
      'sujet': sujet,
      'message': message,
      if (statut != null) 'statut': statut,
      if (reponse != null) 'reponse': reponse,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  static DemandeSupportInclude include() {
    return DemandeSupportInclude._();
  }

  static DemandeSupportIncludeList includeList({
    _i1.WhereExpressionBuilder<DemandeSupportTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DemandeSupportTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DemandeSupportTable>? orderByList,
    DemandeSupportInclude? include,
  }) {
    return DemandeSupportIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DemandeSupport.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DemandeSupport.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DemandeSupportImpl extends DemandeSupport {
  _DemandeSupportImpl({
    int? id,
    required int utilisateurId,
    int? cinemaId,
    required String sujet,
    required String message,
    String? statut,
    String? reponse,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         utilisateurId: utilisateurId,
         cinemaId: cinemaId,
         sujet: sujet,
         message: message,
         statut: statut,
         reponse: reponse,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [DemandeSupport]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DemandeSupport copyWith({
    Object? id = _Undefined,
    int? utilisateurId,
    Object? cinemaId = _Undefined,
    String? sujet,
    String? message,
    Object? statut = _Undefined,
    Object? reponse = _Undefined,
    Object? createdAt = _Undefined,
    Object? updatedAt = _Undefined,
  }) {
    return DemandeSupport(
      id: id is int? ? id : this.id,
      utilisateurId: utilisateurId ?? this.utilisateurId,
      cinemaId: cinemaId is int? ? cinemaId : this.cinemaId,
      sujet: sujet ?? this.sujet,
      message: message ?? this.message,
      statut: statut is String? ? statut : this.statut,
      reponse: reponse is String? ? reponse : this.reponse,
      createdAt: createdAt is DateTime? ? createdAt : this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}

class DemandeSupportUpdateTable extends _i1.UpdateTable<DemandeSupportTable> {
  DemandeSupportUpdateTable(super.table);

  _i1.ColumnValue<int, int> utilisateurId(int value) => _i1.ColumnValue(
    table.utilisateurId,
    value,
  );

  _i1.ColumnValue<int, int> cinemaId(int? value) => _i1.ColumnValue(
    table.cinemaId,
    value,
  );

  _i1.ColumnValue<String, String> sujet(String value) => _i1.ColumnValue(
    table.sujet,
    value,
  );

  _i1.ColumnValue<String, String> message(String value) => _i1.ColumnValue(
    table.message,
    value,
  );

  _i1.ColumnValue<String, String> statut(String? value) => _i1.ColumnValue(
    table.statut,
    value,
  );

  _i1.ColumnValue<String, String> reponse(String? value) => _i1.ColumnValue(
    table.reponse,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime? value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class DemandeSupportTable extends _i1.Table<int?> {
  DemandeSupportTable({super.tableRelation})
    : super(tableName: 'demandes_support') {
    updateTable = DemandeSupportUpdateTable(this);
    utilisateurId = _i1.ColumnInt(
      'utilisateurId',
      this,
    );
    cinemaId = _i1.ColumnInt(
      'cinemaId',
      this,
    );
    sujet = _i1.ColumnString(
      'sujet',
      this,
    );
    message = _i1.ColumnString(
      'message',
      this,
    );
    statut = _i1.ColumnString(
      'statut',
      this,
      hasDefault: true,
    );
    reponse = _i1.ColumnString(
      'reponse',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final DemandeSupportUpdateTable updateTable;

  late final _i1.ColumnInt utilisateurId;

  late final _i1.ColumnInt cinemaId;

  late final _i1.ColumnString sujet;

  late final _i1.ColumnString message;

  late final _i1.ColumnString statut;

  late final _i1.ColumnString reponse;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    utilisateurId,
    cinemaId,
    sujet,
    message,
    statut,
    reponse,
    createdAt,
    updatedAt,
  ];
}

class DemandeSupportInclude extends _i1.IncludeObject {
  DemandeSupportInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => DemandeSupport.t;
}

class DemandeSupportIncludeList extends _i1.IncludeList {
  DemandeSupportIncludeList._({
    _i1.WhereExpressionBuilder<DemandeSupportTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DemandeSupport.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => DemandeSupport.t;
}

class DemandeSupportRepository {
  const DemandeSupportRepository._();

  /// Returns a list of [DemandeSupport]s matching the given query parameters.
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
  Future<List<DemandeSupport>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DemandeSupportTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DemandeSupportTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DemandeSupportTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<DemandeSupport>(
      where: where?.call(DemandeSupport.t),
      orderBy: orderBy?.call(DemandeSupport.t),
      orderByList: orderByList?.call(DemandeSupport.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [DemandeSupport] matching the given query parameters.
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
  Future<DemandeSupport?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DemandeSupportTable>? where,
    int? offset,
    _i1.OrderByBuilder<DemandeSupportTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DemandeSupportTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<DemandeSupport>(
      where: where?.call(DemandeSupport.t),
      orderBy: orderBy?.call(DemandeSupport.t),
      orderByList: orderByList?.call(DemandeSupport.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [DemandeSupport] by its [id] or null if no such row exists.
  Future<DemandeSupport?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<DemandeSupport>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [DemandeSupport]s in the list and returns the inserted rows.
  ///
  /// The returned [DemandeSupport]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<DemandeSupport>> insert(
    _i1.Session session,
    List<DemandeSupport> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<DemandeSupport>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [DemandeSupport] and returns the inserted row.
  ///
  /// The returned [DemandeSupport] will have its `id` field set.
  Future<DemandeSupport> insertRow(
    _i1.Session session,
    DemandeSupport row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DemandeSupport>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [DemandeSupport]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<DemandeSupport>> update(
    _i1.Session session,
    List<DemandeSupport> rows, {
    _i1.ColumnSelections<DemandeSupportTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DemandeSupport>(
      rows,
      columns: columns?.call(DemandeSupport.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DemandeSupport]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DemandeSupport> updateRow(
    _i1.Session session,
    DemandeSupport row, {
    _i1.ColumnSelections<DemandeSupportTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DemandeSupport>(
      row,
      columns: columns?.call(DemandeSupport.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DemandeSupport] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DemandeSupport?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<DemandeSupportUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<DemandeSupport>(
      id,
      columnValues: columnValues(DemandeSupport.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DemandeSupport]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<DemandeSupport>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<DemandeSupportUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<DemandeSupportTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DemandeSupportTable>? orderBy,
    _i1.OrderByListBuilder<DemandeSupportTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<DemandeSupport>(
      columnValues: columnValues(DemandeSupport.t.updateTable),
      where: where(DemandeSupport.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DemandeSupport.t),
      orderByList: orderByList?.call(DemandeSupport.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [DemandeSupport]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<DemandeSupport>> delete(
    _i1.Session session,
    List<DemandeSupport> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DemandeSupport>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [DemandeSupport].
  Future<DemandeSupport> deleteRow(
    _i1.Session session,
    DemandeSupport row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DemandeSupport>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<DemandeSupport>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<DemandeSupportTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DemandeSupport>(
      where: where(DemandeSupport.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DemandeSupportTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DemandeSupport>(
      where: where?.call(DemandeSupport.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
