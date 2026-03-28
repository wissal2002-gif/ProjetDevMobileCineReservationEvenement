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
import 'package:cine_reservation_server/src/generated/protocol.dart' as _i2;

abstract class Utilisateur
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Utilisateur._({
    this.id,
    this.authUserId,
    required this.nom,
    required this.email,
    this.telephone,
    this.dateNaissance,
    this.preferences,
    String? statut,
    String? role,
    this.cinemaId,
    this.nomCinema,
    int? pointsFidelite,
    this.photoProfil,
  }) : statut = statut ?? 'actif',
       role = role ?? 'client',
       pointsFidelite = pointsFidelite ?? 0;

  factory Utilisateur({
    int? id,
    String? authUserId,
    required String nom,
    required String email,
    String? telephone,
    DateTime? dateNaissance,
    List<String>? preferences,
    String? statut,
    String? role,
    int? cinemaId,
    String? nomCinema,
    int? pointsFidelite,
    String? photoProfil,
  }) = _UtilisateurImpl;

  factory Utilisateur.fromJson(Map<String, dynamic> jsonSerialization) {
    return Utilisateur(
      id: jsonSerialization['id'] as int?,
      authUserId: jsonSerialization['authUserId'] as String?,
      nom: jsonSerialization['nom'] as String,
      email: jsonSerialization['email'] as String,
      telephone: jsonSerialization['telephone'] as String?,
      dateNaissance: jsonSerialization['dateNaissance'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['dateNaissance'],
            ),
      preferences: jsonSerialization['preferences'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['preferences'],
            ),
      statut: jsonSerialization['statut'] as String?,
      role: jsonSerialization['role'] as String?,
      cinemaId: jsonSerialization['cinemaId'] as int?,
      nomCinema: jsonSerialization['nomCinema'] as String?,
      pointsFidelite: jsonSerialization['pointsFidelite'] as int?,
      photoProfil: jsonSerialization['photoProfil'] as String?,
    );
  }

  static final t = UtilisateurTable();

  static const db = UtilisateurRepository._();

  @override
  int? id;

  String? authUserId;

  String nom;

  String email;

  String? telephone;

  DateTime? dateNaissance;

  List<String>? preferences;

  String? statut;

  String? role;

  int? cinemaId;

  String? nomCinema;

  int? pointsFidelite;

  String? photoProfil;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Utilisateur]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Utilisateur copyWith({
    int? id,
    String? authUserId,
    String? nom,
    String? email,
    String? telephone,
    DateTime? dateNaissance,
    List<String>? preferences,
    String? statut,
    String? role,
    int? cinemaId,
    String? nomCinema,
    int? pointsFidelite,
    String? photoProfil,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Utilisateur',
      if (id != null) 'id': id,
      if (authUserId != null) 'authUserId': authUserId,
      'nom': nom,
      'email': email,
      if (telephone != null) 'telephone': telephone,
      if (dateNaissance != null) 'dateNaissance': dateNaissance?.toJson(),
      if (preferences != null) 'preferences': preferences?.toJson(),
      if (statut != null) 'statut': statut,
      if (role != null) 'role': role,
      if (cinemaId != null) 'cinemaId': cinemaId,
      if (nomCinema != null) 'nomCinema': nomCinema,
      if (pointsFidelite != null) 'pointsFidelite': pointsFidelite,
      if (photoProfil != null) 'photoProfil': photoProfil,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Utilisateur',
      if (id != null) 'id': id,
      if (authUserId != null) 'authUserId': authUserId,
      'nom': nom,
      'email': email,
      if (telephone != null) 'telephone': telephone,
      if (dateNaissance != null) 'dateNaissance': dateNaissance?.toJson(),
      if (preferences != null) 'preferences': preferences?.toJson(),
      if (statut != null) 'statut': statut,
      if (role != null) 'role': role,
      if (cinemaId != null) 'cinemaId': cinemaId,
      if (nomCinema != null) 'nomCinema': nomCinema,
      if (pointsFidelite != null) 'pointsFidelite': pointsFidelite,
      if (photoProfil != null) 'photoProfil': photoProfil,
    };
  }

  static UtilisateurInclude include() {
    return UtilisateurInclude._();
  }

  static UtilisateurIncludeList includeList({
    _i1.WhereExpressionBuilder<UtilisateurTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UtilisateurTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UtilisateurTable>? orderByList,
    UtilisateurInclude? include,
  }) {
    return UtilisateurIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Utilisateur.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Utilisateur.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UtilisateurImpl extends Utilisateur {
  _UtilisateurImpl({
    int? id,
    String? authUserId,
    required String nom,
    required String email,
    String? telephone,
    DateTime? dateNaissance,
    List<String>? preferences,
    String? statut,
    String? role,
    int? cinemaId,
    String? nomCinema,
    int? pointsFidelite,
    String? photoProfil,
  }) : super._(
         id: id,
         authUserId: authUserId,
         nom: nom,
         email: email,
         telephone: telephone,
         dateNaissance: dateNaissance,
         preferences: preferences,
         statut: statut,
         role: role,
         cinemaId: cinemaId,
         nomCinema: nomCinema,
         pointsFidelite: pointsFidelite,
         photoProfil: photoProfil,
       );

  /// Returns a shallow copy of this [Utilisateur]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Utilisateur copyWith({
    Object? id = _Undefined,
    Object? authUserId = _Undefined,
    String? nom,
    String? email,
    Object? telephone = _Undefined,
    Object? dateNaissance = _Undefined,
    Object? preferences = _Undefined,
    Object? statut = _Undefined,
    Object? role = _Undefined,
    Object? cinemaId = _Undefined,
    Object? nomCinema = _Undefined,
    Object? pointsFidelite = _Undefined,
    Object? photoProfil = _Undefined,
  }) {
    return Utilisateur(
      id: id is int? ? id : this.id,
      authUserId: authUserId is String? ? authUserId : this.authUserId,
      nom: nom ?? this.nom,
      email: email ?? this.email,
      telephone: telephone is String? ? telephone : this.telephone,
      dateNaissance: dateNaissance is DateTime?
          ? dateNaissance
          : this.dateNaissance,
      preferences: preferences is List<String>?
          ? preferences
          : this.preferences?.map((e0) => e0).toList(),
      statut: statut is String? ? statut : this.statut,
      role: role is String? ? role : this.role,
      cinemaId: cinemaId is int? ? cinemaId : this.cinemaId,
      nomCinema: nomCinema is String? ? nomCinema : this.nomCinema,
      pointsFidelite: pointsFidelite is int?
          ? pointsFidelite
          : this.pointsFidelite,
      photoProfil: photoProfil is String? ? photoProfil : this.photoProfil,
    );
  }
}

class UtilisateurUpdateTable extends _i1.UpdateTable<UtilisateurTable> {
  UtilisateurUpdateTable(super.table);

  _i1.ColumnValue<String, String> authUserId(String? value) => _i1.ColumnValue(
    table.authUserId,
    value,
  );

  _i1.ColumnValue<String, String> nom(String value) => _i1.ColumnValue(
    table.nom,
    value,
  );

  _i1.ColumnValue<String, String> email(String value) => _i1.ColumnValue(
    table.email,
    value,
  );

  _i1.ColumnValue<String, String> telephone(String? value) => _i1.ColumnValue(
    table.telephone,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> dateNaissance(DateTime? value) =>
      _i1.ColumnValue(
        table.dateNaissance,
        value,
      );

  _i1.ColumnValue<List<String>, List<String>> preferences(
    List<String>? value,
  ) => _i1.ColumnValue(
    table.preferences,
    value,
  );

  _i1.ColumnValue<String, String> statut(String? value) => _i1.ColumnValue(
    table.statut,
    value,
  );

  _i1.ColumnValue<String, String> role(String? value) => _i1.ColumnValue(
    table.role,
    value,
  );

  _i1.ColumnValue<int, int> cinemaId(int? value) => _i1.ColumnValue(
    table.cinemaId,
    value,
  );

  _i1.ColumnValue<String, String> nomCinema(String? value) => _i1.ColumnValue(
    table.nomCinema,
    value,
  );

  _i1.ColumnValue<int, int> pointsFidelite(int? value) => _i1.ColumnValue(
    table.pointsFidelite,
    value,
  );

  _i1.ColumnValue<String, String> photoProfil(String? value) => _i1.ColumnValue(
    table.photoProfil,
    value,
  );
}

class UtilisateurTable extends _i1.Table<int?> {
  UtilisateurTable({super.tableRelation}) : super(tableName: 'utilisateurs') {
    updateTable = UtilisateurUpdateTable(this);
    authUserId = _i1.ColumnString(
      'authUserId',
      this,
    );
    nom = _i1.ColumnString(
      'nom',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    telephone = _i1.ColumnString(
      'telephone',
      this,
    );
    dateNaissance = _i1.ColumnDateTime(
      'dateNaissance',
      this,
    );
    preferences = _i1.ColumnSerializable<List<String>>(
      'preferences',
      this,
    );
    statut = _i1.ColumnString(
      'statut',
      this,
      hasDefault: true,
    );
    role = _i1.ColumnString(
      'role',
      this,
      hasDefault: true,
    );
    cinemaId = _i1.ColumnInt(
      'cinemaId',
      this,
    );
    nomCinema = _i1.ColumnString(
      'nomCinema',
      this,
    );
    pointsFidelite = _i1.ColumnInt(
      'pointsFidelite',
      this,
      hasDefault: true,
    );
    photoProfil = _i1.ColumnString(
      'photoProfil',
      this,
    );
  }

  late final UtilisateurUpdateTable updateTable;

  late final _i1.ColumnString authUserId;

  late final _i1.ColumnString nom;

  late final _i1.ColumnString email;

  late final _i1.ColumnString telephone;

  late final _i1.ColumnDateTime dateNaissance;

  late final _i1.ColumnSerializable<List<String>> preferences;

  late final _i1.ColumnString statut;

  late final _i1.ColumnString role;

  late final _i1.ColumnInt cinemaId;

  late final _i1.ColumnString nomCinema;

  late final _i1.ColumnInt pointsFidelite;

  late final _i1.ColumnString photoProfil;

  @override
  List<_i1.Column> get columns => [
    id,
    authUserId,
    nom,
    email,
    telephone,
    dateNaissance,
    preferences,
    statut,
    role,
    cinemaId,
    nomCinema,
    pointsFidelite,
    photoProfil,
  ];
}

class UtilisateurInclude extends _i1.IncludeObject {
  UtilisateurInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Utilisateur.t;
}

class UtilisateurIncludeList extends _i1.IncludeList {
  UtilisateurIncludeList._({
    _i1.WhereExpressionBuilder<UtilisateurTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Utilisateur.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Utilisateur.t;
}

class UtilisateurRepository {
  const UtilisateurRepository._();

  /// Returns a list of [Utilisateur]s matching the given query parameters.
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
  Future<List<Utilisateur>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UtilisateurTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UtilisateurTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UtilisateurTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Utilisateur>(
      where: where?.call(Utilisateur.t),
      orderBy: orderBy?.call(Utilisateur.t),
      orderByList: orderByList?.call(Utilisateur.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Utilisateur] matching the given query parameters.
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
  Future<Utilisateur?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UtilisateurTable>? where,
    int? offset,
    _i1.OrderByBuilder<UtilisateurTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UtilisateurTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Utilisateur>(
      where: where?.call(Utilisateur.t),
      orderBy: orderBy?.call(Utilisateur.t),
      orderByList: orderByList?.call(Utilisateur.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Utilisateur] by its [id] or null if no such row exists.
  Future<Utilisateur?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Utilisateur>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Utilisateur]s in the list and returns the inserted rows.
  ///
  /// The returned [Utilisateur]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Utilisateur>> insert(
    _i1.Session session,
    List<Utilisateur> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Utilisateur>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Utilisateur] and returns the inserted row.
  ///
  /// The returned [Utilisateur] will have its `id` field set.
  Future<Utilisateur> insertRow(
    _i1.Session session,
    Utilisateur row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Utilisateur>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Utilisateur]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Utilisateur>> update(
    _i1.Session session,
    List<Utilisateur> rows, {
    _i1.ColumnSelections<UtilisateurTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Utilisateur>(
      rows,
      columns: columns?.call(Utilisateur.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Utilisateur]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Utilisateur> updateRow(
    _i1.Session session,
    Utilisateur row, {
    _i1.ColumnSelections<UtilisateurTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Utilisateur>(
      row,
      columns: columns?.call(Utilisateur.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Utilisateur] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Utilisateur?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<UtilisateurUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Utilisateur>(
      id,
      columnValues: columnValues(Utilisateur.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Utilisateur]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Utilisateur>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<UtilisateurUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<UtilisateurTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UtilisateurTable>? orderBy,
    _i1.OrderByListBuilder<UtilisateurTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Utilisateur>(
      columnValues: columnValues(Utilisateur.t.updateTable),
      where: where(Utilisateur.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Utilisateur.t),
      orderByList: orderByList?.call(Utilisateur.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Utilisateur]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Utilisateur>> delete(
    _i1.Session session,
    List<Utilisateur> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Utilisateur>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Utilisateur].
  Future<Utilisateur> deleteRow(
    _i1.Session session,
    Utilisateur row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Utilisateur>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Utilisateur>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UtilisateurTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Utilisateur>(
      where: where(Utilisateur.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UtilisateurTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Utilisateur>(
      where: where?.call(Utilisateur.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
