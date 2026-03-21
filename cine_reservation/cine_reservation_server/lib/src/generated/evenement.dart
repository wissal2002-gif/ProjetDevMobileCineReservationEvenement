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

abstract class Evenement
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Evenement._({
    this.id,
    required this.titre,
    this.description,
    String? type,
    this.cinemaId,
    this.lieu,
    this.ville,
    required this.dateDebut,
    this.dateFin,
    this.affiche,
    this.bandeAnnonce,
    double? prix,
    int? placesDisponibles,
    int? placesTotales,
    this.organisateur,
    double? noteMoyenne,
    int? nombreAvis,
    String? statut,
    bool? annulationGratuite,
    int? delaiAnnulation,
    double? fraisAnnulation,
  }) : type = type ?? 'concert',
       prix = prix ?? 0.0,
       placesDisponibles = placesDisponibles ?? 0,
       placesTotales = placesTotales ?? 0,
       noteMoyenne = noteMoyenne ?? 0.0,
       nombreAvis = nombreAvis ?? 0,
       statut = statut ?? 'actif',
       annulationGratuite = annulationGratuite ?? true,
       delaiAnnulation = delaiAnnulation ?? 48,
       fraisAnnulation = fraisAnnulation ?? 0.0;

  factory Evenement({
    int? id,
    required String titre,
    String? description,
    String? type,
    int? cinemaId,
    String? lieu,
    String? ville,
    required DateTime dateDebut,
    DateTime? dateFin,
    String? affiche,
    String? bandeAnnonce,
    double? prix,
    int? placesDisponibles,
    int? placesTotales,
    String? organisateur,
    double? noteMoyenne,
    int? nombreAvis,
    String? statut,
    bool? annulationGratuite,
    int? delaiAnnulation,
    double? fraisAnnulation,
  }) = _EvenementImpl;

  factory Evenement.fromJson(Map<String, dynamic> jsonSerialization) {
    return Evenement(
      id: jsonSerialization['id'] as int?,
      titre: jsonSerialization['titre'] as String,
      description: jsonSerialization['description'] as String?,
      type: jsonSerialization['type'] as String?,
      cinemaId: jsonSerialization['cinemaId'] as int?,
      lieu: jsonSerialization['lieu'] as String?,
      ville: jsonSerialization['ville'] as String?,
      dateDebut: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['dateDebut'],
      ),
      dateFin: jsonSerialization['dateFin'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['dateFin']),
      affiche: jsonSerialization['affiche'] as String?,
      bandeAnnonce: jsonSerialization['bandeAnnonce'] as String?,
      prix: (jsonSerialization['prix'] as num?)?.toDouble(),
      placesDisponibles: jsonSerialization['placesDisponibles'] as int?,
      placesTotales: jsonSerialization['placesTotales'] as int?,
      organisateur: jsonSerialization['organisateur'] as String?,
      noteMoyenne: (jsonSerialization['noteMoyenne'] as num?)?.toDouble(),
      nombreAvis: jsonSerialization['nombreAvis'] as int?,
      statut: jsonSerialization['statut'] as String?,
      annulationGratuite: jsonSerialization['annulationGratuite'] as bool?,
      delaiAnnulation: jsonSerialization['delaiAnnulation'] as int?,
      fraisAnnulation: (jsonSerialization['fraisAnnulation'] as num?)
          ?.toDouble(),
    );
  }

  static final t = EvenementTable();

  static const db = EvenementRepository._();

  @override
  int? id;

  String titre;

  String? description;

  String? type;

  int? cinemaId;

  String? lieu;

  String? ville;

  DateTime dateDebut;

  DateTime? dateFin;

  String? affiche;

  String? bandeAnnonce;

  double? prix;

  int? placesDisponibles;

  int? placesTotales;

  String? organisateur;

  double? noteMoyenne;

  int? nombreAvis;

  String? statut;

  bool? annulationGratuite;

  int? delaiAnnulation;

  double? fraisAnnulation;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Evenement]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Evenement copyWith({
    int? id,
    String? titre,
    String? description,
    String? type,
    int? cinemaId,
    String? lieu,
    String? ville,
    DateTime? dateDebut,
    DateTime? dateFin,
    String? affiche,
    String? bandeAnnonce,
    double? prix,
    int? placesDisponibles,
    int? placesTotales,
    String? organisateur,
    double? noteMoyenne,
    int? nombreAvis,
    String? statut,
    bool? annulationGratuite,
    int? delaiAnnulation,
    double? fraisAnnulation,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Evenement',
      if (id != null) 'id': id,
      'titre': titre,
      if (description != null) 'description': description,
      if (type != null) 'type': type,
      if (cinemaId != null) 'cinemaId': cinemaId,
      if (lieu != null) 'lieu': lieu,
      if (ville != null) 'ville': ville,
      'dateDebut': dateDebut.toJson(),
      if (dateFin != null) 'dateFin': dateFin?.toJson(),
      if (affiche != null) 'affiche': affiche,
      if (bandeAnnonce != null) 'bandeAnnonce': bandeAnnonce,
      if (prix != null) 'prix': prix,
      if (placesDisponibles != null) 'placesDisponibles': placesDisponibles,
      if (placesTotales != null) 'placesTotales': placesTotales,
      if (organisateur != null) 'organisateur': organisateur,
      if (noteMoyenne != null) 'noteMoyenne': noteMoyenne,
      if (nombreAvis != null) 'nombreAvis': nombreAvis,
      if (statut != null) 'statut': statut,
      if (annulationGratuite != null) 'annulationGratuite': annulationGratuite,
      if (delaiAnnulation != null) 'delaiAnnulation': delaiAnnulation,
      if (fraisAnnulation != null) 'fraisAnnulation': fraisAnnulation,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Evenement',
      if (id != null) 'id': id,
      'titre': titre,
      if (description != null) 'description': description,
      if (type != null) 'type': type,
      if (cinemaId != null) 'cinemaId': cinemaId,
      if (lieu != null) 'lieu': lieu,
      if (ville != null) 'ville': ville,
      'dateDebut': dateDebut.toJson(),
      if (dateFin != null) 'dateFin': dateFin?.toJson(),
      if (affiche != null) 'affiche': affiche,
      if (bandeAnnonce != null) 'bandeAnnonce': bandeAnnonce,
      if (prix != null) 'prix': prix,
      if (placesDisponibles != null) 'placesDisponibles': placesDisponibles,
      if (placesTotales != null) 'placesTotales': placesTotales,
      if (organisateur != null) 'organisateur': organisateur,
      if (noteMoyenne != null) 'noteMoyenne': noteMoyenne,
      if (nombreAvis != null) 'nombreAvis': nombreAvis,
      if (statut != null) 'statut': statut,
      if (annulationGratuite != null) 'annulationGratuite': annulationGratuite,
      if (delaiAnnulation != null) 'delaiAnnulation': delaiAnnulation,
      if (fraisAnnulation != null) 'fraisAnnulation': fraisAnnulation,
    };
  }

  static EvenementInclude include() {
    return EvenementInclude._();
  }

  static EvenementIncludeList includeList({
    _i1.WhereExpressionBuilder<EvenementTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EvenementTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EvenementTable>? orderByList,
    EvenementInclude? include,
  }) {
    return EvenementIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Evenement.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Evenement.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EvenementImpl extends Evenement {
  _EvenementImpl({
    int? id,
    required String titre,
    String? description,
    String? type,
    int? cinemaId,
    String? lieu,
    String? ville,
    required DateTime dateDebut,
    DateTime? dateFin,
    String? affiche,
    String? bandeAnnonce,
    double? prix,
    int? placesDisponibles,
    int? placesTotales,
    String? organisateur,
    double? noteMoyenne,
    int? nombreAvis,
    String? statut,
    bool? annulationGratuite,
    int? delaiAnnulation,
    double? fraisAnnulation,
  }) : super._(
         id: id,
         titre: titre,
         description: description,
         type: type,
         cinemaId: cinemaId,
         lieu: lieu,
         ville: ville,
         dateDebut: dateDebut,
         dateFin: dateFin,
         affiche: affiche,
         bandeAnnonce: bandeAnnonce,
         prix: prix,
         placesDisponibles: placesDisponibles,
         placesTotales: placesTotales,
         organisateur: organisateur,
         noteMoyenne: noteMoyenne,
         nombreAvis: nombreAvis,
         statut: statut,
         annulationGratuite: annulationGratuite,
         delaiAnnulation: delaiAnnulation,
         fraisAnnulation: fraisAnnulation,
       );

  /// Returns a shallow copy of this [Evenement]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Evenement copyWith({
    Object? id = _Undefined,
    String? titre,
    Object? description = _Undefined,
    Object? type = _Undefined,
    Object? cinemaId = _Undefined,
    Object? lieu = _Undefined,
    Object? ville = _Undefined,
    DateTime? dateDebut,
    Object? dateFin = _Undefined,
    Object? affiche = _Undefined,
    Object? bandeAnnonce = _Undefined,
    Object? prix = _Undefined,
    Object? placesDisponibles = _Undefined,
    Object? placesTotales = _Undefined,
    Object? organisateur = _Undefined,
    Object? noteMoyenne = _Undefined,
    Object? nombreAvis = _Undefined,
    Object? statut = _Undefined,
    Object? annulationGratuite = _Undefined,
    Object? delaiAnnulation = _Undefined,
    Object? fraisAnnulation = _Undefined,
  }) {
    return Evenement(
      id: id is int? ? id : this.id,
      titre: titre ?? this.titre,
      description: description is String? ? description : this.description,
      type: type is String? ? type : this.type,
      cinemaId: cinemaId is int? ? cinemaId : this.cinemaId,
      lieu: lieu is String? ? lieu : this.lieu,
      ville: ville is String? ? ville : this.ville,
      dateDebut: dateDebut ?? this.dateDebut,
      dateFin: dateFin is DateTime? ? dateFin : this.dateFin,
      affiche: affiche is String? ? affiche : this.affiche,
      bandeAnnonce: bandeAnnonce is String? ? bandeAnnonce : this.bandeAnnonce,
      prix: prix is double? ? prix : this.prix,
      placesDisponibles: placesDisponibles is int?
          ? placesDisponibles
          : this.placesDisponibles,
      placesTotales: placesTotales is int? ? placesTotales : this.placesTotales,
      organisateur: organisateur is String? ? organisateur : this.organisateur,
      noteMoyenne: noteMoyenne is double? ? noteMoyenne : this.noteMoyenne,
      nombreAvis: nombreAvis is int? ? nombreAvis : this.nombreAvis,
      statut: statut is String? ? statut : this.statut,
      annulationGratuite: annulationGratuite is bool?
          ? annulationGratuite
          : this.annulationGratuite,
      delaiAnnulation: delaiAnnulation is int?
          ? delaiAnnulation
          : this.delaiAnnulation,
      fraisAnnulation: fraisAnnulation is double?
          ? fraisAnnulation
          : this.fraisAnnulation,
    );
  }
}

class EvenementUpdateTable extends _i1.UpdateTable<EvenementTable> {
  EvenementUpdateTable(super.table);

  _i1.ColumnValue<String, String> titre(String value) => _i1.ColumnValue(
    table.titre,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> type(String? value) => _i1.ColumnValue(
    table.type,
    value,
  );

  _i1.ColumnValue<int, int> cinemaId(int? value) => _i1.ColumnValue(
    table.cinemaId,
    value,
  );

  _i1.ColumnValue<String, String> lieu(String? value) => _i1.ColumnValue(
    table.lieu,
    value,
  );

  _i1.ColumnValue<String, String> ville(String? value) => _i1.ColumnValue(
    table.ville,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> dateDebut(DateTime value) =>
      _i1.ColumnValue(
        table.dateDebut,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> dateFin(DateTime? value) =>
      _i1.ColumnValue(
        table.dateFin,
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

  _i1.ColumnValue<double, double> prix(double? value) => _i1.ColumnValue(
    table.prix,
    value,
  );

  _i1.ColumnValue<int, int> placesDisponibles(int? value) => _i1.ColumnValue(
    table.placesDisponibles,
    value,
  );

  _i1.ColumnValue<int, int> placesTotales(int? value) => _i1.ColumnValue(
    table.placesTotales,
    value,
  );

  _i1.ColumnValue<String, String> organisateur(String? value) =>
      _i1.ColumnValue(
        table.organisateur,
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

  _i1.ColumnValue<String, String> statut(String? value) => _i1.ColumnValue(
    table.statut,
    value,
  );

  _i1.ColumnValue<bool, bool> annulationGratuite(bool? value) =>
      _i1.ColumnValue(
        table.annulationGratuite,
        value,
      );

  _i1.ColumnValue<int, int> delaiAnnulation(int? value) => _i1.ColumnValue(
    table.delaiAnnulation,
    value,
  );

  _i1.ColumnValue<double, double> fraisAnnulation(double? value) =>
      _i1.ColumnValue(
        table.fraisAnnulation,
        value,
      );
}

class EvenementTable extends _i1.Table<int?> {
  EvenementTable({super.tableRelation}) : super(tableName: 'evenements') {
    updateTable = EvenementUpdateTable(this);
    titre = _i1.ColumnString(
      'titre',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    type = _i1.ColumnString(
      'type',
      this,
      hasDefault: true,
    );
    cinemaId = _i1.ColumnInt(
      'cinemaId',
      this,
    );
    lieu = _i1.ColumnString(
      'lieu',
      this,
    );
    ville = _i1.ColumnString(
      'ville',
      this,
    );
    dateDebut = _i1.ColumnDateTime(
      'dateDebut',
      this,
    );
    dateFin = _i1.ColumnDateTime(
      'dateFin',
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
    prix = _i1.ColumnDouble(
      'prix',
      this,
      hasDefault: true,
    );
    placesDisponibles = _i1.ColumnInt(
      'placesDisponibles',
      this,
      hasDefault: true,
    );
    placesTotales = _i1.ColumnInt(
      'placesTotales',
      this,
      hasDefault: true,
    );
    organisateur = _i1.ColumnString(
      'organisateur',
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
    statut = _i1.ColumnString(
      'statut',
      this,
      hasDefault: true,
    );
    annulationGratuite = _i1.ColumnBool(
      'annulationGratuite',
      this,
      hasDefault: true,
    );
    delaiAnnulation = _i1.ColumnInt(
      'delaiAnnulation',
      this,
      hasDefault: true,
    );
    fraisAnnulation = _i1.ColumnDouble(
      'fraisAnnulation',
      this,
      hasDefault: true,
    );
  }

  late final EvenementUpdateTable updateTable;

  late final _i1.ColumnString titre;

  late final _i1.ColumnString description;

  late final _i1.ColumnString type;

  late final _i1.ColumnInt cinemaId;

  late final _i1.ColumnString lieu;

  late final _i1.ColumnString ville;

  late final _i1.ColumnDateTime dateDebut;

  late final _i1.ColumnDateTime dateFin;

  late final _i1.ColumnString affiche;

  late final _i1.ColumnString bandeAnnonce;

  late final _i1.ColumnDouble prix;

  late final _i1.ColumnInt placesDisponibles;

  late final _i1.ColumnInt placesTotales;

  late final _i1.ColumnString organisateur;

  late final _i1.ColumnDouble noteMoyenne;

  late final _i1.ColumnInt nombreAvis;

  late final _i1.ColumnString statut;

  late final _i1.ColumnBool annulationGratuite;

  late final _i1.ColumnInt delaiAnnulation;

  late final _i1.ColumnDouble fraisAnnulation;

  @override
  List<_i1.Column> get columns => [
    id,
    titre,
    description,
    type,
    cinemaId,
    lieu,
    ville,
    dateDebut,
    dateFin,
    affiche,
    bandeAnnonce,
    prix,
    placesDisponibles,
    placesTotales,
    organisateur,
    noteMoyenne,
    nombreAvis,
    statut,
    annulationGratuite,
    delaiAnnulation,
    fraisAnnulation,
  ];
}

class EvenementInclude extends _i1.IncludeObject {
  EvenementInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Evenement.t;
}

class EvenementIncludeList extends _i1.IncludeList {
  EvenementIncludeList._({
    _i1.WhereExpressionBuilder<EvenementTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Evenement.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Evenement.t;
}

class EvenementRepository {
  const EvenementRepository._();

  /// Returns a list of [Evenement]s matching the given query parameters.
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
  Future<List<Evenement>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EvenementTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EvenementTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EvenementTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Evenement>(
      where: where?.call(Evenement.t),
      orderBy: orderBy?.call(Evenement.t),
      orderByList: orderByList?.call(Evenement.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Evenement] matching the given query parameters.
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
  Future<Evenement?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EvenementTable>? where,
    int? offset,
    _i1.OrderByBuilder<EvenementTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EvenementTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Evenement>(
      where: where?.call(Evenement.t),
      orderBy: orderBy?.call(Evenement.t),
      orderByList: orderByList?.call(Evenement.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Evenement] by its [id] or null if no such row exists.
  Future<Evenement?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Evenement>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Evenement]s in the list and returns the inserted rows.
  ///
  /// The returned [Evenement]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Evenement>> insert(
    _i1.Session session,
    List<Evenement> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Evenement>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Evenement] and returns the inserted row.
  ///
  /// The returned [Evenement] will have its `id` field set.
  Future<Evenement> insertRow(
    _i1.Session session,
    Evenement row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Evenement>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Evenement]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Evenement>> update(
    _i1.Session session,
    List<Evenement> rows, {
    _i1.ColumnSelections<EvenementTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Evenement>(
      rows,
      columns: columns?.call(Evenement.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Evenement]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Evenement> updateRow(
    _i1.Session session,
    Evenement row, {
    _i1.ColumnSelections<EvenementTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Evenement>(
      row,
      columns: columns?.call(Evenement.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Evenement] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Evenement?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<EvenementUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Evenement>(
      id,
      columnValues: columnValues(Evenement.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Evenement]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Evenement>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<EvenementUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<EvenementTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EvenementTable>? orderBy,
    _i1.OrderByListBuilder<EvenementTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Evenement>(
      columnValues: columnValues(Evenement.t.updateTable),
      where: where(Evenement.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Evenement.t),
      orderByList: orderByList?.call(Evenement.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Evenement]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Evenement>> delete(
    _i1.Session session,
    List<Evenement> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Evenement>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Evenement].
  Future<Evenement> deleteRow(
    _i1.Session session,
    Evenement row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Evenement>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Evenement>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<EvenementTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Evenement>(
      where: where(Evenement.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EvenementTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Evenement>(
      where: where?.call(Evenement.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
