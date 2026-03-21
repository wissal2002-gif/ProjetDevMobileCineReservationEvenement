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

abstract class Cinema implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Cinema._({
    this.id,
    required this.nom,
    required this.adresse,
    required this.ville,
    this.telephone,
    this.email,
    this.latitude,
    this.longitude,
    this.description,
    this.photo,
  });

  factory Cinema({
    int? id,
    required String nom,
    required String adresse,
    required String ville,
    String? telephone,
    String? email,
    double? latitude,
    double? longitude,
    String? description,
    String? photo,
  }) = _CinemaImpl;

  factory Cinema.fromJson(Map<String, dynamic> jsonSerialization) {
    return Cinema(
      id: jsonSerialization['id'] as int?,
      nom: jsonSerialization['nom'] as String,
      adresse: jsonSerialization['adresse'] as String,
      ville: jsonSerialization['ville'] as String,
      telephone: jsonSerialization['telephone'] as String?,
      email: jsonSerialization['email'] as String?,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
      description: jsonSerialization['description'] as String?,
      photo: jsonSerialization['photo'] as String?,
    );
  }

  static final t = CinemaTable();

  static const db = CinemaRepository._();

  @override
  int? id;

  String nom;

  String adresse;

  String ville;

  String? telephone;

  String? email;

  double? latitude;

  double? longitude;

  String? description;

  String? photo;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Cinema]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Cinema copyWith({
    int? id,
    String? nom,
    String? adresse,
    String? ville,
    String? telephone,
    String? email,
    double? latitude,
    double? longitude,
    String? description,
    String? photo,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Cinema',
      if (id != null) 'id': id,
      'nom': nom,
      'adresse': adresse,
      'ville': ville,
      if (telephone != null) 'telephone': telephone,
      if (email != null) 'email': email,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (description != null) 'description': description,
      if (photo != null) 'photo': photo,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Cinema',
      if (id != null) 'id': id,
      'nom': nom,
      'adresse': adresse,
      'ville': ville,
      if (telephone != null) 'telephone': telephone,
      if (email != null) 'email': email,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (description != null) 'description': description,
      if (photo != null) 'photo': photo,
    };
  }

  static CinemaInclude include() {
    return CinemaInclude._();
  }

  static CinemaIncludeList includeList({
    _i1.WhereExpressionBuilder<CinemaTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CinemaTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CinemaTable>? orderByList,
    CinemaInclude? include,
  }) {
    return CinemaIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Cinema.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Cinema.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CinemaImpl extends Cinema {
  _CinemaImpl({
    int? id,
    required String nom,
    required String adresse,
    required String ville,
    String? telephone,
    String? email,
    double? latitude,
    double? longitude,
    String? description,
    String? photo,
  }) : super._(
         id: id,
         nom: nom,
         adresse: adresse,
         ville: ville,
         telephone: telephone,
         email: email,
         latitude: latitude,
         longitude: longitude,
         description: description,
         photo: photo,
       );

  /// Returns a shallow copy of this [Cinema]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Cinema copyWith({
    Object? id = _Undefined,
    String? nom,
    String? adresse,
    String? ville,
    Object? telephone = _Undefined,
    Object? email = _Undefined,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
    Object? description = _Undefined,
    Object? photo = _Undefined,
  }) {
    return Cinema(
      id: id is int? ? id : this.id,
      nom: nom ?? this.nom,
      adresse: adresse ?? this.adresse,
      ville: ville ?? this.ville,
      telephone: telephone is String? ? telephone : this.telephone,
      email: email is String? ? email : this.email,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
      description: description is String? ? description : this.description,
      photo: photo is String? ? photo : this.photo,
    );
  }
}

class CinemaUpdateTable extends _i1.UpdateTable<CinemaTable> {
  CinemaUpdateTable(super.table);

  _i1.ColumnValue<String, String> nom(String value) => _i1.ColumnValue(
    table.nom,
    value,
  );

  _i1.ColumnValue<String, String> adresse(String value) => _i1.ColumnValue(
    table.adresse,
    value,
  );

  _i1.ColumnValue<String, String> ville(String value) => _i1.ColumnValue(
    table.ville,
    value,
  );

  _i1.ColumnValue<String, String> telephone(String? value) => _i1.ColumnValue(
    table.telephone,
    value,
  );

  _i1.ColumnValue<String, String> email(String? value) => _i1.ColumnValue(
    table.email,
    value,
  );

  _i1.ColumnValue<double, double> latitude(double? value) => _i1.ColumnValue(
    table.latitude,
    value,
  );

  _i1.ColumnValue<double, double> longitude(double? value) => _i1.ColumnValue(
    table.longitude,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> photo(String? value) => _i1.ColumnValue(
    table.photo,
    value,
  );
}

class CinemaTable extends _i1.Table<int?> {
  CinemaTable({super.tableRelation}) : super(tableName: 'cinemas') {
    updateTable = CinemaUpdateTable(this);
    nom = _i1.ColumnString(
      'nom',
      this,
    );
    adresse = _i1.ColumnString(
      'adresse',
      this,
    );
    ville = _i1.ColumnString(
      'ville',
      this,
    );
    telephone = _i1.ColumnString(
      'telephone',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    latitude = _i1.ColumnDouble(
      'latitude',
      this,
    );
    longitude = _i1.ColumnDouble(
      'longitude',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    photo = _i1.ColumnString(
      'photo',
      this,
    );
  }

  late final CinemaUpdateTable updateTable;

  late final _i1.ColumnString nom;

  late final _i1.ColumnString adresse;

  late final _i1.ColumnString ville;

  late final _i1.ColumnString telephone;

  late final _i1.ColumnString email;

  late final _i1.ColumnDouble latitude;

  late final _i1.ColumnDouble longitude;

  late final _i1.ColumnString description;

  late final _i1.ColumnString photo;

  @override
  List<_i1.Column> get columns => [
    id,
    nom,
    adresse,
    ville,
    telephone,
    email,
    latitude,
    longitude,
    description,
    photo,
  ];
}

class CinemaInclude extends _i1.IncludeObject {
  CinemaInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Cinema.t;
}

class CinemaIncludeList extends _i1.IncludeList {
  CinemaIncludeList._({
    _i1.WhereExpressionBuilder<CinemaTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Cinema.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Cinema.t;
}

class CinemaRepository {
  const CinemaRepository._();

  /// Returns a list of [Cinema]s matching the given query parameters.
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
  Future<List<Cinema>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CinemaTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CinemaTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CinemaTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Cinema>(
      where: where?.call(Cinema.t),
      orderBy: orderBy?.call(Cinema.t),
      orderByList: orderByList?.call(Cinema.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Cinema] matching the given query parameters.
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
  Future<Cinema?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CinemaTable>? where,
    int? offset,
    _i1.OrderByBuilder<CinemaTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CinemaTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Cinema>(
      where: where?.call(Cinema.t),
      orderBy: orderBy?.call(Cinema.t),
      orderByList: orderByList?.call(Cinema.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Cinema] by its [id] or null if no such row exists.
  Future<Cinema?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Cinema>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Cinema]s in the list and returns the inserted rows.
  ///
  /// The returned [Cinema]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Cinema>> insert(
    _i1.Session session,
    List<Cinema> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Cinema>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Cinema] and returns the inserted row.
  ///
  /// The returned [Cinema] will have its `id` field set.
  Future<Cinema> insertRow(
    _i1.Session session,
    Cinema row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Cinema>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Cinema]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Cinema>> update(
    _i1.Session session,
    List<Cinema> rows, {
    _i1.ColumnSelections<CinemaTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Cinema>(
      rows,
      columns: columns?.call(Cinema.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Cinema]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Cinema> updateRow(
    _i1.Session session,
    Cinema row, {
    _i1.ColumnSelections<CinemaTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Cinema>(
      row,
      columns: columns?.call(Cinema.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Cinema] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Cinema?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<CinemaUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Cinema>(
      id,
      columnValues: columnValues(Cinema.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Cinema]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Cinema>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<CinemaUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<CinemaTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CinemaTable>? orderBy,
    _i1.OrderByListBuilder<CinemaTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Cinema>(
      columnValues: columnValues(Cinema.t.updateTable),
      where: where(Cinema.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Cinema.t),
      orderByList: orderByList?.call(Cinema.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Cinema]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Cinema>> delete(
    _i1.Session session,
    List<Cinema> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Cinema>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Cinema].
  Future<Cinema> deleteRow(
    _i1.Session session,
    Cinema row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Cinema>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Cinema>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CinemaTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Cinema>(
      where: where(Cinema.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CinemaTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Cinema>(
      where: where?.call(Cinema.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
