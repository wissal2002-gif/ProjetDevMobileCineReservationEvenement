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

abstract class Film implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Film._({
    this.id,
    required this.titre,
    this.synopsis,
    this.genre,
    this.duree,
    this.realisateur,
    this.casting,
    this.affiche,
    this.bandeAnnonce,
    this.classification,
    double? noteMoyenne,
    int? nombreAvis,
    this.dateDebut,
    this.dateFin,
    String? langue,
    this.cinemaId,
  }) : noteMoyenne = noteMoyenne ?? 0.0,
       nombreAvis = nombreAvis ?? 0,
       langue = langue ?? 'VF';

  factory Film({
    int? id,
    required String titre,
    String? synopsis,
    String? genre,
    int? duree,
    String? realisateur,
    String? casting,
    String? affiche,
    String? bandeAnnonce,
    String? classification,
    double? noteMoyenne,
    int? nombreAvis,
    DateTime? dateDebut,
    DateTime? dateFin,
    String? langue,
    int? cinemaId,
  }) = _FilmImpl;

  factory Film.fromJson(Map<String, dynamic> jsonSerialization) {
    return Film(
      id: jsonSerialization['id'] as int?,
      titre: jsonSerialization['titre'] as String,
      synopsis: jsonSerialization['synopsis'] as String?,
      genre: jsonSerialization['genre'] as String?,
      duree: jsonSerialization['duree'] as int?,
      realisateur: jsonSerialization['realisateur'] as String?,
      casting: jsonSerialization['casting'] as String?,
      affiche: jsonSerialization['affiche'] as String?,
      bandeAnnonce: jsonSerialization['bandeAnnonce'] as String?,
      classification: jsonSerialization['classification'] as String?,
      noteMoyenne: (jsonSerialization['noteMoyenne'] as num?)?.toDouble(),
      nombreAvis: jsonSerialization['nombreAvis'] as int?,
      dateDebut: jsonSerialization['dateDebut'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['dateDebut']),
      dateFin: jsonSerialization['dateFin'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['dateFin']),
      langue: jsonSerialization['langue'] as String?,
      cinemaId: jsonSerialization['cinemaId'] as int?,
    );
  }

  static final t = FilmTable();

  static const db = FilmRepository._();

  @override
  int? id;

  String titre;

  String? synopsis;

  String? genre;

  int? duree;

  String? realisateur;

  String? casting;

  String? affiche;

  String? bandeAnnonce;

  String? classification;

  double? noteMoyenne;

  int? nombreAvis;

  DateTime? dateDebut;

  DateTime? dateFin;

  String? langue;

  int? cinemaId;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Film]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Film copyWith({
    int? id,
    String? titre,
    String? synopsis,
    String? genre,
    int? duree,
    String? realisateur,
    String? casting,
    String? affiche,
    String? bandeAnnonce,
    String? classification,
    double? noteMoyenne,
    int? nombreAvis,
    DateTime? dateDebut,
    DateTime? dateFin,
    String? langue,
    int? cinemaId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Film',
      if (id != null) 'id': id,
      'titre': titre,
      if (synopsis != null) 'synopsis': synopsis,
      if (genre != null) 'genre': genre,
      if (duree != null) 'duree': duree,
      if (realisateur != null) 'realisateur': realisateur,
      if (casting != null) 'casting': casting,
      if (affiche != null) 'affiche': affiche,
      if (bandeAnnonce != null) 'bandeAnnonce': bandeAnnonce,
      if (classification != null) 'classification': classification,
      if (noteMoyenne != null) 'noteMoyenne': noteMoyenne,
      if (nombreAvis != null) 'nombreAvis': nombreAvis,
      if (dateDebut != null) 'dateDebut': dateDebut?.toJson(),
      if (dateFin != null) 'dateFin': dateFin?.toJson(),
      if (langue != null) 'langue': langue,
      if (cinemaId != null) 'cinemaId': cinemaId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Film',
      if (id != null) 'id': id,
      'titre': titre,
      if (synopsis != null) 'synopsis': synopsis,
      if (genre != null) 'genre': genre,
      if (duree != null) 'duree': duree,
      if (realisateur != null) 'realisateur': realisateur,
      if (casting != null) 'casting': casting,
      if (affiche != null) 'affiche': affiche,
      if (bandeAnnonce != null) 'bandeAnnonce': bandeAnnonce,
      if (classification != null) 'classification': classification,
      if (noteMoyenne != null) 'noteMoyenne': noteMoyenne,
      if (nombreAvis != null) 'nombreAvis': nombreAvis,
      if (dateDebut != null) 'dateDebut': dateDebut?.toJson(),
      if (dateFin != null) 'dateFin': dateFin?.toJson(),
      if (langue != null) 'langue': langue,
      if (cinemaId != null) 'cinemaId': cinemaId,
    };
  }

  static FilmInclude include() {
    return FilmInclude._();
  }

  static FilmIncludeList includeList({
    _i1.WhereExpressionBuilder<FilmTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FilmTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FilmTable>? orderByList,
    FilmInclude? include,
  }) {
    return FilmIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Film.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Film.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FilmImpl extends Film {
  _FilmImpl({
    int? id,
    required String titre,
    String? synopsis,
    String? genre,
    int? duree,
    String? realisateur,
    String? casting,
    String? affiche,
    String? bandeAnnonce,
    String? classification,
    double? noteMoyenne,
    int? nombreAvis,
    DateTime? dateDebut,
    DateTime? dateFin,
    String? langue,
    int? cinemaId,
  }) : super._(
         id: id,
         titre: titre,
         synopsis: synopsis,
         genre: genre,
         duree: duree,
         realisateur: realisateur,
         casting: casting,
         affiche: affiche,
         bandeAnnonce: bandeAnnonce,
         classification: classification,
         noteMoyenne: noteMoyenne,
         nombreAvis: nombreAvis,
         dateDebut: dateDebut,
         dateFin: dateFin,
         langue: langue,
         cinemaId: cinemaId,
       );

  /// Returns a shallow copy of this [Film]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Film copyWith({
    Object? id = _Undefined,
    String? titre,
    Object? synopsis = _Undefined,
    Object? genre = _Undefined,
    Object? duree = _Undefined,
    Object? realisateur = _Undefined,
    Object? casting = _Undefined,
    Object? affiche = _Undefined,
    Object? bandeAnnonce = _Undefined,
    Object? classification = _Undefined,
    Object? noteMoyenne = _Undefined,
    Object? nombreAvis = _Undefined,
    Object? dateDebut = _Undefined,
    Object? dateFin = _Undefined,
    Object? langue = _Undefined,
    Object? cinemaId = _Undefined,
  }) {
    return Film(
      id: id is int? ? id : this.id,
      titre: titre ?? this.titre,
      synopsis: synopsis is String? ? synopsis : this.synopsis,
      genre: genre is String? ? genre : this.genre,
      duree: duree is int? ? duree : this.duree,
      realisateur: realisateur is String? ? realisateur : this.realisateur,
      casting: casting is String? ? casting : this.casting,
      affiche: affiche is String? ? affiche : this.affiche,
      bandeAnnonce: bandeAnnonce is String? ? bandeAnnonce : this.bandeAnnonce,
      classification: classification is String?
          ? classification
          : this.classification,
      noteMoyenne: noteMoyenne is double? ? noteMoyenne : this.noteMoyenne,
      nombreAvis: nombreAvis is int? ? nombreAvis : this.nombreAvis,
      dateDebut: dateDebut is DateTime? ? dateDebut : this.dateDebut,
      dateFin: dateFin is DateTime? ? dateFin : this.dateFin,
      langue: langue is String? ? langue : this.langue,
      cinemaId: cinemaId is int? ? cinemaId : this.cinemaId,
    );
  }
}

class FilmUpdateTable extends _i1.UpdateTable<FilmTable> {
  FilmUpdateTable(super.table);

  _i1.ColumnValue<String, String> titre(String value) => _i1.ColumnValue(
    table.titre,
    value,
  );

  _i1.ColumnValue<String, String> synopsis(String? value) => _i1.ColumnValue(
    table.synopsis,
    value,
  );

  _i1.ColumnValue<String, String> genre(String? value) => _i1.ColumnValue(
    table.genre,
    value,
  );

  _i1.ColumnValue<int, int> duree(int? value) => _i1.ColumnValue(
    table.duree,
    value,
  );

  _i1.ColumnValue<String, String> realisateur(String? value) => _i1.ColumnValue(
    table.realisateur,
    value,
  );

  _i1.ColumnValue<String, String> casting(String? value) => _i1.ColumnValue(
    table.casting,
    value,
  );

  _i1.ColumnValue<String, String> affiche(String? value) => _i1.ColumnValue(
    table.affiche,
    value,
  );

  _i1.ColumnValue<String, String> bandeAnnonce(String? value) =>
      _i1.ColumnValue(
        table.bandeAnnonce,
        value,
      );

  _i1.ColumnValue<String, String> classification(String? value) =>
      _i1.ColumnValue(
        table.classification,
        value,
      );

  _i1.ColumnValue<double, double> noteMoyenne(double? value) => _i1.ColumnValue(
    table.noteMoyenne,
    value,
  );

  _i1.ColumnValue<int, int> nombreAvis(int? value) => _i1.ColumnValue(
    table.nombreAvis,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> dateDebut(DateTime? value) =>
      _i1.ColumnValue(
        table.dateDebut,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> dateFin(DateTime? value) =>
      _i1.ColumnValue(
        table.dateFin,
        value,
      );

  _i1.ColumnValue<String, String> langue(String? value) => _i1.ColumnValue(
    table.langue,
    value,
  );

  _i1.ColumnValue<int, int> cinemaId(int? value) => _i1.ColumnValue(
    table.cinemaId,
    value,
  );
}

class FilmTable extends _i1.Table<int?> {
  FilmTable({super.tableRelation}) : super(tableName: 'films') {
    updateTable = FilmUpdateTable(this);
    titre = _i1.ColumnString(
      'titre',
      this,
    );
    synopsis = _i1.ColumnString(
      'synopsis',
      this,
    );
    genre = _i1.ColumnString(
      'genre',
      this,
    );
    duree = _i1.ColumnInt(
      'duree',
      this,
    );
    realisateur = _i1.ColumnString(
      'realisateur',
      this,
    );
    casting = _i1.ColumnString(
      'casting',
      this,
    );
    affiche = _i1.ColumnString(
      'affiche',
      this,
    );
    bandeAnnonce = _i1.ColumnString(
      'bandeAnnonce',
      this,
    );
    classification = _i1.ColumnString(
      'classification',
      this,
    );
    noteMoyenne = _i1.ColumnDouble(
      'noteMoyenne',
      this,
      hasDefault: true,
    );
    nombreAvis = _i1.ColumnInt(
      'nombreAvis',
      this,
      hasDefault: true,
    );
    dateDebut = _i1.ColumnDateTime(
      'dateDebut',
      this,
    );
    dateFin = _i1.ColumnDateTime(
      'dateFin',
      this,
    );
    langue = _i1.ColumnString(
      'langue',
      this,
      hasDefault: true,
    );
    cinemaId = _i1.ColumnInt(
      'cinemaId',
      this,
    );
  }

  late final FilmUpdateTable updateTable;

  late final _i1.ColumnString titre;

  late final _i1.ColumnString synopsis;

  late final _i1.ColumnString genre;

  late final _i1.ColumnInt duree;

  late final _i1.ColumnString realisateur;

  late final _i1.ColumnString casting;

  late final _i1.ColumnString affiche;

  late final _i1.ColumnString bandeAnnonce;

  late final _i1.ColumnString classification;

  late final _i1.ColumnDouble noteMoyenne;

  late final _i1.ColumnInt nombreAvis;

  late final _i1.ColumnDateTime dateDebut;

  late final _i1.ColumnDateTime dateFin;

  late final _i1.ColumnString langue;

  late final _i1.ColumnInt cinemaId;

  @override
  List<_i1.Column> get columns => [
    id,
    titre,
    synopsis,
    genre,
    duree,
    realisateur,
    casting,
    affiche,
    bandeAnnonce,
    classification,
    noteMoyenne,
    nombreAvis,
    dateDebut,
    dateFin,
    langue,
    cinemaId,
  ];
}

class FilmInclude extends _i1.IncludeObject {
  FilmInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Film.t;
}

class FilmIncludeList extends _i1.IncludeList {
  FilmIncludeList._({
    _i1.WhereExpressionBuilder<FilmTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Film.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Film.t;
}

class FilmRepository {
  const FilmRepository._();

  /// Returns a list of [Film]s matching the given query parameters.
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
  Future<List<Film>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FilmTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FilmTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FilmTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Film>(
      where: where?.call(Film.t),
      orderBy: orderBy?.call(Film.t),
      orderByList: orderByList?.call(Film.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Film] matching the given query parameters.
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
  Future<Film?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FilmTable>? where,
    int? offset,
    _i1.OrderByBuilder<FilmTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FilmTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Film>(
      where: where?.call(Film.t),
      orderBy: orderBy?.call(Film.t),
      orderByList: orderByList?.call(Film.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Film] by its [id] or null if no such row exists.
  Future<Film?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Film>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Film]s in the list and returns the inserted rows.
  ///
  /// The returned [Film]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<Film>> insert(
    _i1.DatabaseSession session,
    List<Film> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Film>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Film] and returns the inserted row.
  ///
  /// The returned [Film] will have its `id` field set.
  Future<Film> insertRow(
    _i1.DatabaseSession session,
    Film row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Film>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Film]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Film>> update(
    _i1.DatabaseSession session,
    List<Film> rows, {
    _i1.ColumnSelections<FilmTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Film>(
      rows,
      columns: columns?.call(Film.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Film]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Film> updateRow(
    _i1.DatabaseSession session,
    Film row, {
    _i1.ColumnSelections<FilmTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Film>(
      row,
      columns: columns?.call(Film.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Film] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Film?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<FilmUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Film>(
      id,
      columnValues: columnValues(Film.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Film]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Film>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<FilmUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<FilmTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FilmTable>? orderBy,
    _i1.OrderByListBuilder<FilmTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Film>(
      columnValues: columnValues(Film.t.updateTable),
      where: where(Film.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Film.t),
      orderByList: orderByList?.call(Film.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Film]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Film>> delete(
    _i1.DatabaseSession session,
    List<Film> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Film>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Film].
  Future<Film> deleteRow(
    _i1.DatabaseSession session,
    Film row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Film>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Film>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<FilmTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Film>(
      where: where(Film.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FilmTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Film>(
      where: where?.call(Film.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Film] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<FilmTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Film>(
      where: where(Film.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
