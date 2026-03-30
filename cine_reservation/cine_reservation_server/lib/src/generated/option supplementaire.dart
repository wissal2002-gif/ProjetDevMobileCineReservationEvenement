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

abstract class OptionSupplementaire
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  OptionSupplementaire._({
    this.id,
    required this.nom,
    this.description,
    required this.prix,
    String? categorie,
    bool? disponible,
    this.image,
    this.cinemaId,
  }) : categorie = categorie ?? 'snack',
       disponible = disponible ?? true;

  factory OptionSupplementaire({
    int? id,
    required String nom,
    String? description,
    required double prix,
    String? categorie,
    bool? disponible,
    String? image,
    int? cinemaId,
  }) = _OptionSupplementaireImpl;

  factory OptionSupplementaire.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return OptionSupplementaire(
      id: jsonSerialization['id'] as int?,
      nom: jsonSerialization['nom'] as String,
      description: jsonSerialization['description'] as String?,
      prix: (jsonSerialization['prix'] as num).toDouble(),
      categorie: jsonSerialization['categorie'] as String?,
      disponible: jsonSerialization['disponible'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['disponible']),
      image: jsonSerialization['image'] as String?,
      cinemaId: jsonSerialization['cinemaId'] as int?,
    );
  }

  static final t = OptionSupplementaireTable();

  static const db = OptionSupplementaireRepository._();

  @override
  int? id;

  String nom;

  String? description;

  double prix;

  String? categorie;

  bool? disponible;

  String? image;

  int? cinemaId;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [OptionSupplementaire]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OptionSupplementaire copyWith({
    int? id,
    String? nom,
    String? description,
    double? prix,
    String? categorie,
    bool? disponible,
    String? image,
    int? cinemaId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OptionSupplementaire',
      if (id != null) 'id': id,
      'nom': nom,
      if (description != null) 'description': description,
      'prix': prix,
      if (categorie != null) 'categorie': categorie,
      if (disponible != null) 'disponible': disponible,
      if (image != null) 'image': image,
      if (cinemaId != null) 'cinemaId': cinemaId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OptionSupplementaire',
      if (id != null) 'id': id,
      'nom': nom,
      if (description != null) 'description': description,
      'prix': prix,
      if (categorie != null) 'categorie': categorie,
      if (disponible != null) 'disponible': disponible,
      if (image != null) 'image': image,
      if (cinemaId != null) 'cinemaId': cinemaId,
    };
  }

  static OptionSupplementaireInclude include() {
    return OptionSupplementaireInclude._();
  }

  static OptionSupplementaireIncludeList includeList({
    _i1.WhereExpressionBuilder<OptionSupplementaireTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OptionSupplementaireTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OptionSupplementaireTable>? orderByList,
    OptionSupplementaireInclude? include,
  }) {
    return OptionSupplementaireIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OptionSupplementaire.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(OptionSupplementaire.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OptionSupplementaireImpl extends OptionSupplementaire {
  _OptionSupplementaireImpl({
    int? id,
    required String nom,
    String? description,
    required double prix,
    String? categorie,
    bool? disponible,
    String? image,
    int? cinemaId,
  }) : super._(
         id: id,
         nom: nom,
         description: description,
         prix: prix,
         categorie: categorie,
         disponible: disponible,
         image: image,
         cinemaId: cinemaId,
       );

  /// Returns a shallow copy of this [OptionSupplementaire]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OptionSupplementaire copyWith({
    Object? id = _Undefined,
    String? nom,
    Object? description = _Undefined,
    double? prix,
    Object? categorie = _Undefined,
    Object? disponible = _Undefined,
    Object? image = _Undefined,
    Object? cinemaId = _Undefined,
  }) {
    return OptionSupplementaire(
      id: id is int? ? id : this.id,
      nom: nom ?? this.nom,
      description: description is String? ? description : this.description,
      prix: prix ?? this.prix,
      categorie: categorie is String? ? categorie : this.categorie,
      disponible: disponible is bool? ? disponible : this.disponible,
      image: image is String? ? image : this.image,
      cinemaId: cinemaId is int? ? cinemaId : this.cinemaId,
    );
  }
}

class OptionSupplementaireUpdateTable
    extends _i1.UpdateTable<OptionSupplementaireTable> {
  OptionSupplementaireUpdateTable(super.table);

  _i1.ColumnValue<String, String> nom(String value) => _i1.ColumnValue(
    table.nom,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<double, double> prix(double value) => _i1.ColumnValue(
    table.prix,
    value,
  );

  _i1.ColumnValue<String, String> categorie(String? value) => _i1.ColumnValue(
    table.categorie,
    value,
  );

  _i1.ColumnValue<bool, bool> disponible(bool? value) => _i1.ColumnValue(
    table.disponible,
    value,
  );

  _i1.ColumnValue<String, String> image(String? value) => _i1.ColumnValue(
    table.image,
    value,
  );

  _i1.ColumnValue<int, int> cinemaId(int? value) => _i1.ColumnValue(
    table.cinemaId,
    value,
  );
}

class OptionSupplementaireTable extends _i1.Table<int?> {
  OptionSupplementaireTable({super.tableRelation})
    : super(tableName: 'options_supplementaires') {
    updateTable = OptionSupplementaireUpdateTable(this);
    nom = _i1.ColumnString(
      'nom',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    prix = _i1.ColumnDouble(
      'prix',
      this,
    );
    categorie = _i1.ColumnString(
      'categorie',
      this,
      hasDefault: true,
    );
    disponible = _i1.ColumnBool(
      'disponible',
      this,
      hasDefault: true,
    );
    image = _i1.ColumnString(
      'image',
      this,
    );
    cinemaId = _i1.ColumnInt(
      'cinemaId',
      this,
    );
  }

  late final OptionSupplementaireUpdateTable updateTable;

  late final _i1.ColumnString nom;

  late final _i1.ColumnString description;

  late final _i1.ColumnDouble prix;

  late final _i1.ColumnString categorie;

  late final _i1.ColumnBool disponible;

  late final _i1.ColumnString image;

  late final _i1.ColumnInt cinemaId;

  @override
  List<_i1.Column> get columns => [
    id,
    nom,
    description,
    prix,
    categorie,
    disponible,
    image,
    cinemaId,
  ];
}

class OptionSupplementaireInclude extends _i1.IncludeObject {
  OptionSupplementaireInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => OptionSupplementaire.t;
}

class OptionSupplementaireIncludeList extends _i1.IncludeList {
  OptionSupplementaireIncludeList._({
    _i1.WhereExpressionBuilder<OptionSupplementaireTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(OptionSupplementaire.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => OptionSupplementaire.t;
}

class OptionSupplementaireRepository {
  const OptionSupplementaireRepository._();

  /// Returns a list of [OptionSupplementaire]s matching the given query parameters.
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
  Future<List<OptionSupplementaire>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OptionSupplementaireTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OptionSupplementaireTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OptionSupplementaireTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<OptionSupplementaire>(
      where: where?.call(OptionSupplementaire.t),
      orderBy: orderBy?.call(OptionSupplementaire.t),
      orderByList: orderByList?.call(OptionSupplementaire.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [OptionSupplementaire] matching the given query parameters.
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
  Future<OptionSupplementaire?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OptionSupplementaireTable>? where,
    int? offset,
    _i1.OrderByBuilder<OptionSupplementaireTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OptionSupplementaireTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<OptionSupplementaire>(
      where: where?.call(OptionSupplementaire.t),
      orderBy: orderBy?.call(OptionSupplementaire.t),
      orderByList: orderByList?.call(OptionSupplementaire.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [OptionSupplementaire] by its [id] or null if no such row exists.
  Future<OptionSupplementaire?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<OptionSupplementaire>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [OptionSupplementaire]s in the list and returns the inserted rows.
  ///
  /// The returned [OptionSupplementaire]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<OptionSupplementaire>> insert(
    _i1.DatabaseSession session,
    List<OptionSupplementaire> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<OptionSupplementaire>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [OptionSupplementaire] and returns the inserted row.
  ///
  /// The returned [OptionSupplementaire] will have its `id` field set.
  Future<OptionSupplementaire> insertRow(
    _i1.DatabaseSession session,
    OptionSupplementaire row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<OptionSupplementaire>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [OptionSupplementaire]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<OptionSupplementaire>> update(
    _i1.DatabaseSession session,
    List<OptionSupplementaire> rows, {
    _i1.ColumnSelections<OptionSupplementaireTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<OptionSupplementaire>(
      rows,
      columns: columns?.call(OptionSupplementaire.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OptionSupplementaire]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<OptionSupplementaire> updateRow(
    _i1.DatabaseSession session,
    OptionSupplementaire row, {
    _i1.ColumnSelections<OptionSupplementaireTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<OptionSupplementaire>(
      row,
      columns: columns?.call(OptionSupplementaire.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OptionSupplementaire] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<OptionSupplementaire?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<OptionSupplementaireUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<OptionSupplementaire>(
      id,
      columnValues: columnValues(OptionSupplementaire.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [OptionSupplementaire]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<OptionSupplementaire>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<OptionSupplementaireUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<OptionSupplementaireTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OptionSupplementaireTable>? orderBy,
    _i1.OrderByListBuilder<OptionSupplementaireTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<OptionSupplementaire>(
      columnValues: columnValues(OptionSupplementaire.t.updateTable),
      where: where(OptionSupplementaire.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OptionSupplementaire.t),
      orderByList: orderByList?.call(OptionSupplementaire.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [OptionSupplementaire]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<OptionSupplementaire>> delete(
    _i1.DatabaseSession session,
    List<OptionSupplementaire> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<OptionSupplementaire>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [OptionSupplementaire].
  Future<OptionSupplementaire> deleteRow(
    _i1.DatabaseSession session,
    OptionSupplementaire row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<OptionSupplementaire>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<OptionSupplementaire>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<OptionSupplementaireTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<OptionSupplementaire>(
      where: where(OptionSupplementaire.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OptionSupplementaireTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<OptionSupplementaire>(
      where: where?.call(OptionSupplementaire.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [OptionSupplementaire] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<OptionSupplementaireTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<OptionSupplementaire>(
      where: where(OptionSupplementaire.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
