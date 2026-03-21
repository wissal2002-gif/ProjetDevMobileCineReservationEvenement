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

abstract class Seance implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Seance._({
    this.id,
    required this.filmId,
    required this.salleId,
    required this.dateHeure,
    String? langue,
    String? typeProjection,
    String? typeSeance,
    required this.placesDisponibles,
    required this.prixNormal,
    this.prixReduit,
    this.prixSenior,
    this.prixEnfant,
    this.prixVip,
  }) : langue = langue ?? 'VF',
       typeProjection = typeProjection ?? '2D',
       typeSeance = typeSeance ?? 'standard';

  factory Seance({
    int? id,
    required int filmId,
    required int salleId,
    required DateTime dateHeure,
    String? langue,
    String? typeProjection,
    String? typeSeance,
    required int placesDisponibles,
    required double prixNormal,
    double? prixReduit,
    double? prixSenior,
    double? prixEnfant,
    double? prixVip,
  }) = _SeanceImpl;

  factory Seance.fromJson(Map<String, dynamic> jsonSerialization) {
    return Seance(
      id: jsonSerialization['id'] as int?,
      filmId: jsonSerialization['filmId'] as int,
      salleId: jsonSerialization['salleId'] as int,
      dateHeure: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['dateHeure'],
      ),
      langue: jsonSerialization['langue'] as String?,
      typeProjection: jsonSerialization['typeProjection'] as String?,
      typeSeance: jsonSerialization['typeSeance'] as String?,
      placesDisponibles: jsonSerialization['placesDisponibles'] as int,
      prixNormal: (jsonSerialization['prixNormal'] as num).toDouble(),
      prixReduit: (jsonSerialization['prixReduit'] as num?)?.toDouble(),
      prixSenior: (jsonSerialization['prixSenior'] as num?)?.toDouble(),
      prixEnfant: (jsonSerialization['prixEnfant'] as num?)?.toDouble(),
      prixVip: (jsonSerialization['prixVip'] as num?)?.toDouble(),
    );
  }

  static final t = SeanceTable();

  static const db = SeanceRepository._();

  @override
  int? id;

  int filmId;

  int salleId;

  DateTime dateHeure;

  String? langue;

  String? typeProjection;

  String? typeSeance;

  int placesDisponibles;

  double prixNormal;

  double? prixReduit;

  double? prixSenior;

  double? prixEnfant;

  double? prixVip;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Seance]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Seance copyWith({
    int? id,
    int? filmId,
    int? salleId,
    DateTime? dateHeure,
    String? langue,
    String? typeProjection,
    String? typeSeance,
    int? placesDisponibles,
    double? prixNormal,
    double? prixReduit,
    double? prixSenior,
    double? prixEnfant,
    double? prixVip,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Seance',
      if (id != null) 'id': id,
      'filmId': filmId,
      'salleId': salleId,
      'dateHeure': dateHeure.toJson(),
      if (langue != null) 'langue': langue,
      if (typeProjection != null) 'typeProjection': typeProjection,
      if (typeSeance != null) 'typeSeance': typeSeance,
      'placesDisponibles': placesDisponibles,
      'prixNormal': prixNormal,
      if (prixReduit != null) 'prixReduit': prixReduit,
      if (prixSenior != null) 'prixSenior': prixSenior,
      if (prixEnfant != null) 'prixEnfant': prixEnfant,
      if (prixVip != null) 'prixVip': prixVip,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Seance',
      if (id != null) 'id': id,
      'filmId': filmId,
      'salleId': salleId,
      'dateHeure': dateHeure.toJson(),
      if (langue != null) 'langue': langue,
      if (typeProjection != null) 'typeProjection': typeProjection,
      if (typeSeance != null) 'typeSeance': typeSeance,
      'placesDisponibles': placesDisponibles,
      'prixNormal': prixNormal,
      if (prixReduit != null) 'prixReduit': prixReduit,
      if (prixSenior != null) 'prixSenior': prixSenior,
      if (prixEnfant != null) 'prixEnfant': prixEnfant,
      if (prixVip != null) 'prixVip': prixVip,
    };
  }

  static SeanceInclude include() {
    return SeanceInclude._();
  }

  static SeanceIncludeList includeList({
    _i1.WhereExpressionBuilder<SeanceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SeanceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SeanceTable>? orderByList,
    SeanceInclude? include,
  }) {
    return SeanceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Seance.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Seance.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SeanceImpl extends Seance {
  _SeanceImpl({
    int? id,
    required int filmId,
    required int salleId,
    required DateTime dateHeure,
    String? langue,
    String? typeProjection,
    String? typeSeance,
    required int placesDisponibles,
    required double prixNormal,
    double? prixReduit,
    double? prixSenior,
    double? prixEnfant,
    double? prixVip,
  }) : super._(
         id: id,
         filmId: filmId,
         salleId: salleId,
         dateHeure: dateHeure,
         langue: langue,
         typeProjection: typeProjection,
         typeSeance: typeSeance,
         placesDisponibles: placesDisponibles,
         prixNormal: prixNormal,
         prixReduit: prixReduit,
         prixSenior: prixSenior,
         prixEnfant: prixEnfant,
         prixVip: prixVip,
       );

  /// Returns a shallow copy of this [Seance]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Seance copyWith({
    Object? id = _Undefined,
    int? filmId,
    int? salleId,
    DateTime? dateHeure,
    Object? langue = _Undefined,
    Object? typeProjection = _Undefined,
    Object? typeSeance = _Undefined,
    int? placesDisponibles,
    double? prixNormal,
    Object? prixReduit = _Undefined,
    Object? prixSenior = _Undefined,
    Object? prixEnfant = _Undefined,
    Object? prixVip = _Undefined,
  }) {
    return Seance(
      id: id is int? ? id : this.id,
      filmId: filmId ?? this.filmId,
      salleId: salleId ?? this.salleId,
      dateHeure: dateHeure ?? this.dateHeure,
      langue: langue is String? ? langue : this.langue,
      typeProjection: typeProjection is String?
          ? typeProjection
          : this.typeProjection,
      typeSeance: typeSeance is String? ? typeSeance : this.typeSeance,
      placesDisponibles: placesDisponibles ?? this.placesDisponibles,
      prixNormal: prixNormal ?? this.prixNormal,
      prixReduit: prixReduit is double? ? prixReduit : this.prixReduit,
      prixSenior: prixSenior is double? ? prixSenior : this.prixSenior,
      prixEnfant: prixEnfant is double? ? prixEnfant : this.prixEnfant,
      prixVip: prixVip is double? ? prixVip : this.prixVip,
    );
  }
}

class SeanceUpdateTable extends _i1.UpdateTable<SeanceTable> {
  SeanceUpdateTable(super.table);

  _i1.ColumnValue<int, int> filmId(int value) => _i1.ColumnValue(
    table.filmId,
    value,
  );

  _i1.ColumnValue<int, int> salleId(int value) => _i1.ColumnValue(
    table.salleId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> dateHeure(DateTime value) =>
      _i1.ColumnValue(
        table.dateHeure,
        value,
      );

  _i1.ColumnValue<String, String> langue(String? value) => _i1.ColumnValue(
    table.langue,
    value,
  );

  _i1.ColumnValue<String, String> typeProjection(String? value) =>
      _i1.ColumnValue(
        table.typeProjection,
        value,
      );

  _i1.ColumnValue<String, String> typeSeance(String? value) => _i1.ColumnValue(
    table.typeSeance,
    value,
  );

  _i1.ColumnValue<int, int> placesDisponibles(int value) => _i1.ColumnValue(
    table.placesDisponibles,
    value,
  );

  _i1.ColumnValue<double, double> prixNormal(double value) => _i1.ColumnValue(
    table.prixNormal,
    value,
  );

  _i1.ColumnValue<double, double> prixReduit(double? value) => _i1.ColumnValue(
    table.prixReduit,
    value,
  );

  _i1.ColumnValue<double, double> prixSenior(double? value) => _i1.ColumnValue(
    table.prixSenior,
    value,
  );

  _i1.ColumnValue<double, double> prixEnfant(double? value) => _i1.ColumnValue(
    table.prixEnfant,
    value,
  );

  _i1.ColumnValue<double, double> prixVip(double? value) => _i1.ColumnValue(
    table.prixVip,
    value,
  );
}

class SeanceTable extends _i1.Table<int?> {
  SeanceTable({super.tableRelation}) : super(tableName: 'seances') {
    updateTable = SeanceUpdateTable(this);
    filmId = _i1.ColumnInt(
      'filmId',
      this,
    );
    salleId = _i1.ColumnInt(
      'salleId',
      this,
    );
    dateHeure = _i1.ColumnDateTime(
      'dateHeure',
      this,
    );
    langue = _i1.ColumnString(
      'langue',
      this,
      hasDefault: true,
    );
    typeProjection = _i1.ColumnString(
      'typeProjection',
      this,
      hasDefault: true,
    );
    typeSeance = _i1.ColumnString(
      'typeSeance',
      this,
      hasDefault: true,
    );
    placesDisponibles = _i1.ColumnInt(
      'placesDisponibles',
      this,
    );
    prixNormal = _i1.ColumnDouble(
      'prixNormal',
      this,
    );
    prixReduit = _i1.ColumnDouble(
      'prixReduit',
      this,
    );
    prixSenior = _i1.ColumnDouble(
      'prixSenior',
      this,
    );
    prixEnfant = _i1.ColumnDouble(
      'prixEnfant',
      this,
    );
    prixVip = _i1.ColumnDouble(
      'prixVip',
      this,
    );
  }

  late final SeanceUpdateTable updateTable;

  late final _i1.ColumnInt filmId;

  late final _i1.ColumnInt salleId;

  late final _i1.ColumnDateTime dateHeure;

  late final _i1.ColumnString langue;

  late final _i1.ColumnString typeProjection;

  late final _i1.ColumnString typeSeance;

  late final _i1.ColumnInt placesDisponibles;

  late final _i1.ColumnDouble prixNormal;

  late final _i1.ColumnDouble prixReduit;

  late final _i1.ColumnDouble prixSenior;

  late final _i1.ColumnDouble prixEnfant;

  late final _i1.ColumnDouble prixVip;

  @override
  List<_i1.Column> get columns => [
    id,
    filmId,
    salleId,
    dateHeure,
    langue,
    typeProjection,
    typeSeance,
    placesDisponibles,
    prixNormal,
    prixReduit,
    prixSenior,
    prixEnfant,
    prixVip,
  ];
}

class SeanceInclude extends _i1.IncludeObject {
  SeanceInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Seance.t;
}

class SeanceIncludeList extends _i1.IncludeList {
  SeanceIncludeList._({
    _i1.WhereExpressionBuilder<SeanceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Seance.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Seance.t;
}

class SeanceRepository {
  const SeanceRepository._();

  /// Returns a list of [Seance]s matching the given query parameters.
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
  Future<List<Seance>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SeanceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SeanceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SeanceTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Seance>(
      where: where?.call(Seance.t),
      orderBy: orderBy?.call(Seance.t),
      orderByList: orderByList?.call(Seance.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Seance] matching the given query parameters.
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
  Future<Seance?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SeanceTable>? where,
    int? offset,
    _i1.OrderByBuilder<SeanceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SeanceTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Seance>(
      where: where?.call(Seance.t),
      orderBy: orderBy?.call(Seance.t),
      orderByList: orderByList?.call(Seance.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Seance] by its [id] or null if no such row exists.
  Future<Seance?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Seance>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Seance]s in the list and returns the inserted rows.
  ///
  /// The returned [Seance]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Seance>> insert(
    _i1.Session session,
    List<Seance> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Seance>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Seance] and returns the inserted row.
  ///
  /// The returned [Seance] will have its `id` field set.
  Future<Seance> insertRow(
    _i1.Session session,
    Seance row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Seance>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Seance]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Seance>> update(
    _i1.Session session,
    List<Seance> rows, {
    _i1.ColumnSelections<SeanceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Seance>(
      rows,
      columns: columns?.call(Seance.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Seance]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Seance> updateRow(
    _i1.Session session,
    Seance row, {
    _i1.ColumnSelections<SeanceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Seance>(
      row,
      columns: columns?.call(Seance.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Seance] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Seance?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<SeanceUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Seance>(
      id,
      columnValues: columnValues(Seance.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Seance]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Seance>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<SeanceUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<SeanceTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SeanceTable>? orderBy,
    _i1.OrderByListBuilder<SeanceTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Seance>(
      columnValues: columnValues(Seance.t.updateTable),
      where: where(Seance.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Seance.t),
      orderByList: orderByList?.call(Seance.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Seance]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Seance>> delete(
    _i1.Session session,
    List<Seance> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Seance>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Seance].
  Future<Seance> deleteRow(
    _i1.Session session,
    Seance row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Seance>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Seance>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SeanceTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Seance>(
      where: where(Seance.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SeanceTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Seance>(
      where: where?.call(Seance.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
