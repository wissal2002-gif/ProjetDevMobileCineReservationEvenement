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

abstract class Faq implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Faq._({
    this.id,
    required this.question,
    required this.reponse,
    String? categorie,
    int? ordre,
  }) : categorie = categorie ?? 'general',
       ordre = ordre ?? 0;

  factory Faq({
    int? id,
    required String question,
    required String reponse,
    String? categorie,
    int? ordre,
  }) = _FaqImpl;

  factory Faq.fromJson(Map<String, dynamic> jsonSerialization) {
    return Faq(
      id: jsonSerialization['id'] as int?,
      question: jsonSerialization['question'] as String,
      reponse: jsonSerialization['reponse'] as String,
      categorie: jsonSerialization['categorie'] as String?,
      ordre: jsonSerialization['ordre'] as int?,
    );
  }

  static final t = FaqTable();

  static const db = FaqRepository._();

  @override
  int? id;

  String question;

  String reponse;

  String? categorie;

  int? ordre;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Faq]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Faq copyWith({
    int? id,
    String? question,
    String? reponse,
    String? categorie,
    int? ordre,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Faq',
      if (id != null) 'id': id,
      'question': question,
      'reponse': reponse,
      if (categorie != null) 'categorie': categorie,
      if (ordre != null) 'ordre': ordre,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Faq',
      if (id != null) 'id': id,
      'question': question,
      'reponse': reponse,
      if (categorie != null) 'categorie': categorie,
      if (ordre != null) 'ordre': ordre,
    };
  }

  static FaqInclude include() {
    return FaqInclude._();
  }

  static FaqIncludeList includeList({
    _i1.WhereExpressionBuilder<FaqTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FaqTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FaqTable>? orderByList,
    FaqInclude? include,
  }) {
    return FaqIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Faq.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Faq.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FaqImpl extends Faq {
  _FaqImpl({
    int? id,
    required String question,
    required String reponse,
    String? categorie,
    int? ordre,
  }) : super._(
         id: id,
         question: question,
         reponse: reponse,
         categorie: categorie,
         ordre: ordre,
       );

  /// Returns a shallow copy of this [Faq]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Faq copyWith({
    Object? id = _Undefined,
    String? question,
    String? reponse,
    Object? categorie = _Undefined,
    Object? ordre = _Undefined,
  }) {
    return Faq(
      id: id is int? ? id : this.id,
      question: question ?? this.question,
      reponse: reponse ?? this.reponse,
      categorie: categorie is String? ? categorie : this.categorie,
      ordre: ordre is int? ? ordre : this.ordre,
    );
  }
}

class FaqUpdateTable extends _i1.UpdateTable<FaqTable> {
  FaqUpdateTable(super.table);

  _i1.ColumnValue<String, String> question(String value) => _i1.ColumnValue(
    table.question,
    value,
  );

  _i1.ColumnValue<String, String> reponse(String value) => _i1.ColumnValue(
    table.reponse,
    value,
  );

  _i1.ColumnValue<String, String> categorie(String? value) => _i1.ColumnValue(
    table.categorie,
    value,
  );

  _i1.ColumnValue<int, int> ordre(int? value) => _i1.ColumnValue(
    table.ordre,
    value,
  );
}

class FaqTable extends _i1.Table<int?> {
  FaqTable({super.tableRelation}) : super(tableName: 'faqs') {
    updateTable = FaqUpdateTable(this);
    question = _i1.ColumnString(
      'question',
      this,
    );
    reponse = _i1.ColumnString(
      'reponse',
      this,
    );
    categorie = _i1.ColumnString(
      'categorie',
      this,
      hasDefault: true,
    );
    ordre = _i1.ColumnInt(
      'ordre',
      this,
      hasDefault: true,
    );
  }

  late final FaqUpdateTable updateTable;

  late final _i1.ColumnString question;

  late final _i1.ColumnString reponse;

  late final _i1.ColumnString categorie;

  late final _i1.ColumnInt ordre;

  @override
  List<_i1.Column> get columns => [
    id,
    question,
    reponse,
    categorie,
    ordre,
  ];
}

class FaqInclude extends _i1.IncludeObject {
  FaqInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Faq.t;
}

class FaqIncludeList extends _i1.IncludeList {
  FaqIncludeList._({
    _i1.WhereExpressionBuilder<FaqTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Faq.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Faq.t;
}

class FaqRepository {
  const FaqRepository._();

  /// Returns a list of [Faq]s matching the given query parameters.
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
  Future<List<Faq>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FaqTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FaqTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FaqTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Faq>(
      where: where?.call(Faq.t),
      orderBy: orderBy?.call(Faq.t),
      orderByList: orderByList?.call(Faq.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Faq] matching the given query parameters.
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
  Future<Faq?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FaqTable>? where,
    int? offset,
    _i1.OrderByBuilder<FaqTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FaqTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Faq>(
      where: where?.call(Faq.t),
      orderBy: orderBy?.call(Faq.t),
      orderByList: orderByList?.call(Faq.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Faq] by its [id] or null if no such row exists.
  Future<Faq?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Faq>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Faq]s in the list and returns the inserted rows.
  ///
  /// The returned [Faq]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Faq>> insert(
    _i1.Session session,
    List<Faq> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Faq>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Faq] and returns the inserted row.
  ///
  /// The returned [Faq] will have its `id` field set.
  Future<Faq> insertRow(
    _i1.Session session,
    Faq row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Faq>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Faq]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Faq>> update(
    _i1.Session session,
    List<Faq> rows, {
    _i1.ColumnSelections<FaqTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Faq>(
      rows,
      columns: columns?.call(Faq.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Faq]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Faq> updateRow(
    _i1.Session session,
    Faq row, {
    _i1.ColumnSelections<FaqTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Faq>(
      row,
      columns: columns?.call(Faq.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Faq] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Faq?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<FaqUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Faq>(
      id,
      columnValues: columnValues(Faq.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Faq]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Faq>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<FaqUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<FaqTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FaqTable>? orderBy,
    _i1.OrderByListBuilder<FaqTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Faq>(
      columnValues: columnValues(Faq.t.updateTable),
      where: where(Faq.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Faq.t),
      orderByList: orderByList?.call(Faq.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Faq]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Faq>> delete(
    _i1.Session session,
    List<Faq> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Faq>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Faq].
  Future<Faq> deleteRow(
    _i1.Session session,
    Faq row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Faq>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Faq>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<FaqTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Faq>(
      where: where(Faq.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FaqTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Faq>(
      where: where?.call(Faq.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
