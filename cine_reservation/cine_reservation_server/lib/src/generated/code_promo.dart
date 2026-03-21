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

abstract class CodePromo
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CodePromo._({
    this.id,
    required this.code,
    this.description,
    required this.reduction,
    String? typeReduction,
    double? montantMinimum,
    this.dateExpiration,
    int? utilisationsMax,
    int? utilisationsActuelles,
    bool? actif,
  }) : typeReduction = typeReduction ?? 'pourcentage',
       montantMinimum = montantMinimum ?? 0.0,
       utilisationsMax = utilisationsMax ?? 100,
       utilisationsActuelles = utilisationsActuelles ?? 0,
       actif = actif ?? true;

  factory CodePromo({
    int? id,
    required String code,
    String? description,
    required double reduction,
    String? typeReduction,
    double? montantMinimum,
    DateTime? dateExpiration,
    int? utilisationsMax,
    int? utilisationsActuelles,
    bool? actif,
  }) = _CodePromoImpl;

  factory CodePromo.fromJson(Map<String, dynamic> jsonSerialization) {
    return CodePromo(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      description: jsonSerialization['description'] as String?,
      reduction: (jsonSerialization['reduction'] as num).toDouble(),
      typeReduction: jsonSerialization['typeReduction'] as String?,
      montantMinimum: (jsonSerialization['montantMinimum'] as num?)?.toDouble(),
      dateExpiration: jsonSerialization['dateExpiration'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['dateExpiration'],
            ),
      utilisationsMax: jsonSerialization['utilisationsMax'] as int?,
      utilisationsActuelles: jsonSerialization['utilisationsActuelles'] as int?,
      actif: jsonSerialization['actif'] as bool?,
    );
  }

  static final t = CodePromoTable();

  static const db = CodePromoRepository._();

  @override
  int? id;

  String code;

  String? description;

  double reduction;

  String? typeReduction;

  double? montantMinimum;

  DateTime? dateExpiration;

  int? utilisationsMax;

  int? utilisationsActuelles;

  bool? actif;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CodePromo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CodePromo copyWith({
    int? id,
    String? code,
    String? description,
    double? reduction,
    String? typeReduction,
    double? montantMinimum,
    DateTime? dateExpiration,
    int? utilisationsMax,
    int? utilisationsActuelles,
    bool? actif,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CodePromo',
      if (id != null) 'id': id,
      'code': code,
      if (description != null) 'description': description,
      'reduction': reduction,
      if (typeReduction != null) 'typeReduction': typeReduction,
      if (montantMinimum != null) 'montantMinimum': montantMinimum,
      if (dateExpiration != null) 'dateExpiration': dateExpiration?.toJson(),
      if (utilisationsMax != null) 'utilisationsMax': utilisationsMax,
      if (utilisationsActuelles != null)
        'utilisationsActuelles': utilisationsActuelles,
      if (actif != null) 'actif': actif,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CodePromo',
      if (id != null) 'id': id,
      'code': code,
      if (description != null) 'description': description,
      'reduction': reduction,
      if (typeReduction != null) 'typeReduction': typeReduction,
      if (montantMinimum != null) 'montantMinimum': montantMinimum,
      if (dateExpiration != null) 'dateExpiration': dateExpiration?.toJson(),
      if (utilisationsMax != null) 'utilisationsMax': utilisationsMax,
      if (utilisationsActuelles != null)
        'utilisationsActuelles': utilisationsActuelles,
      if (actif != null) 'actif': actif,
    };
  }

  static CodePromoInclude include() {
    return CodePromoInclude._();
  }

  static CodePromoIncludeList includeList({
    _i1.WhereExpressionBuilder<CodePromoTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CodePromoTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CodePromoTable>? orderByList,
    CodePromoInclude? include,
  }) {
    return CodePromoIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CodePromo.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CodePromo.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CodePromoImpl extends CodePromo {
  _CodePromoImpl({
    int? id,
    required String code,
    String? description,
    required double reduction,
    String? typeReduction,
    double? montantMinimum,
    DateTime? dateExpiration,
    int? utilisationsMax,
    int? utilisationsActuelles,
    bool? actif,
  }) : super._(
         id: id,
         code: code,
         description: description,
         reduction: reduction,
         typeReduction: typeReduction,
         montantMinimum: montantMinimum,
         dateExpiration: dateExpiration,
         utilisationsMax: utilisationsMax,
         utilisationsActuelles: utilisationsActuelles,
         actif: actif,
       );

  /// Returns a shallow copy of this [CodePromo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CodePromo copyWith({
    Object? id = _Undefined,
    String? code,
    Object? description = _Undefined,
    double? reduction,
    Object? typeReduction = _Undefined,
    Object? montantMinimum = _Undefined,
    Object? dateExpiration = _Undefined,
    Object? utilisationsMax = _Undefined,
    Object? utilisationsActuelles = _Undefined,
    Object? actif = _Undefined,
  }) {
    return CodePromo(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      description: description is String? ? description : this.description,
      reduction: reduction ?? this.reduction,
      typeReduction: typeReduction is String?
          ? typeReduction
          : this.typeReduction,
      montantMinimum: montantMinimum is double?
          ? montantMinimum
          : this.montantMinimum,
      dateExpiration: dateExpiration is DateTime?
          ? dateExpiration
          : this.dateExpiration,
      utilisationsMax: utilisationsMax is int?
          ? utilisationsMax
          : this.utilisationsMax,
      utilisationsActuelles: utilisationsActuelles is int?
          ? utilisationsActuelles
          : this.utilisationsActuelles,
      actif: actif is bool? ? actif : this.actif,
    );
  }
}

class CodePromoUpdateTable extends _i1.UpdateTable<CodePromoTable> {
  CodePromoUpdateTable(super.table);

  _i1.ColumnValue<String, String> code(String value) => _i1.ColumnValue(
    table.code,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<double, double> reduction(double value) => _i1.ColumnValue(
    table.reduction,
    value,
  );

  _i1.ColumnValue<String, String> typeReduction(String? value) =>
      _i1.ColumnValue(
        table.typeReduction,
        value,
      );

  _i1.ColumnValue<double, double> montantMinimum(double? value) =>
      _i1.ColumnValue(
        table.montantMinimum,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> dateExpiration(DateTime? value) =>
      _i1.ColumnValue(
        table.dateExpiration,
        value,
      );

  _i1.ColumnValue<int, int> utilisationsMax(int? value) => _i1.ColumnValue(
    table.utilisationsMax,
    value,
  );

  _i1.ColumnValue<int, int> utilisationsActuelles(int? value) =>
      _i1.ColumnValue(
        table.utilisationsActuelles,
        value,
      );

  _i1.ColumnValue<bool, bool> actif(bool? value) => _i1.ColumnValue(
    table.actif,
    value,
  );
}

class CodePromoTable extends _i1.Table<int?> {
  CodePromoTable({super.tableRelation}) : super(tableName: 'codes_promo') {
    updateTable = CodePromoUpdateTable(this);
    code = _i1.ColumnString(
      'code',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    reduction = _i1.ColumnDouble(
      'reduction',
      this,
    );
    typeReduction = _i1.ColumnString(
      'typeReduction',
      this,
      hasDefault: true,
    );
    montantMinimum = _i1.ColumnDouble(
      'montantMinimum',
      this,
      hasDefault: true,
    );
    dateExpiration = _i1.ColumnDateTime(
      'dateExpiration',
      this,
    );
    utilisationsMax = _i1.ColumnInt(
      'utilisationsMax',
      this,
      hasDefault: true,
    );
    utilisationsActuelles = _i1.ColumnInt(
      'utilisationsActuelles',
      this,
      hasDefault: true,
    );
    actif = _i1.ColumnBool(
      'actif',
      this,
      hasDefault: true,
    );
  }

  late final CodePromoUpdateTable updateTable;

  late final _i1.ColumnString code;

  late final _i1.ColumnString description;

  late final _i1.ColumnDouble reduction;

  late final _i1.ColumnString typeReduction;

  late final _i1.ColumnDouble montantMinimum;

  late final _i1.ColumnDateTime dateExpiration;

  late final _i1.ColumnInt utilisationsMax;

  late final _i1.ColumnInt utilisationsActuelles;

  late final _i1.ColumnBool actif;

  @override
  List<_i1.Column> get columns => [
    id,
    code,
    description,
    reduction,
    typeReduction,
    montantMinimum,
    dateExpiration,
    utilisationsMax,
    utilisationsActuelles,
    actif,
  ];
}

class CodePromoInclude extends _i1.IncludeObject {
  CodePromoInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => CodePromo.t;
}

class CodePromoIncludeList extends _i1.IncludeList {
  CodePromoIncludeList._({
    _i1.WhereExpressionBuilder<CodePromoTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CodePromo.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CodePromo.t;
}

class CodePromoRepository {
  const CodePromoRepository._();

  /// Returns a list of [CodePromo]s matching the given query parameters.
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
  Future<List<CodePromo>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CodePromoTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CodePromoTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CodePromoTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<CodePromo>(
      where: where?.call(CodePromo.t),
      orderBy: orderBy?.call(CodePromo.t),
      orderByList: orderByList?.call(CodePromo.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [CodePromo] matching the given query parameters.
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
  Future<CodePromo?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CodePromoTable>? where,
    int? offset,
    _i1.OrderByBuilder<CodePromoTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CodePromoTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<CodePromo>(
      where: where?.call(CodePromo.t),
      orderBy: orderBy?.call(CodePromo.t),
      orderByList: orderByList?.call(CodePromo.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [CodePromo] by its [id] or null if no such row exists.
  Future<CodePromo?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<CodePromo>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [CodePromo]s in the list and returns the inserted rows.
  ///
  /// The returned [CodePromo]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<CodePromo>> insert(
    _i1.Session session,
    List<CodePromo> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<CodePromo>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [CodePromo] and returns the inserted row.
  ///
  /// The returned [CodePromo] will have its `id` field set.
  Future<CodePromo> insertRow(
    _i1.Session session,
    CodePromo row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CodePromo>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CodePromo]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CodePromo>> update(
    _i1.Session session,
    List<CodePromo> rows, {
    _i1.ColumnSelections<CodePromoTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CodePromo>(
      rows,
      columns: columns?.call(CodePromo.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CodePromo]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CodePromo> updateRow(
    _i1.Session session,
    CodePromo row, {
    _i1.ColumnSelections<CodePromoTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CodePromo>(
      row,
      columns: columns?.call(CodePromo.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CodePromo] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CodePromo?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<CodePromoUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CodePromo>(
      id,
      columnValues: columnValues(CodePromo.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CodePromo]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CodePromo>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<CodePromoUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<CodePromoTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CodePromoTable>? orderBy,
    _i1.OrderByListBuilder<CodePromoTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CodePromo>(
      columnValues: columnValues(CodePromo.t.updateTable),
      where: where(CodePromo.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CodePromo.t),
      orderByList: orderByList?.call(CodePromo.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CodePromo]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CodePromo>> delete(
    _i1.Session session,
    List<CodePromo> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CodePromo>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CodePromo].
  Future<CodePromo> deleteRow(
    _i1.Session session,
    CodePromo row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CodePromo>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CodePromo>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CodePromoTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CodePromo>(
      where: where(CodePromo.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CodePromoTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CodePromo>(
      where: where?.call(CodePromo.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
