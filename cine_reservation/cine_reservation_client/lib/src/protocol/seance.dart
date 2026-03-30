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
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class Seance implements _i1.SerializableModel {
  Seance._({
    this.id,
    required this.filmId,
    this.cinemaId,
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
    int? cinemaId,
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
      cinemaId: jsonSerialization['cinemaId'] as int?,
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int filmId;

  int? cinemaId;

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

  /// Returns a shallow copy of this [Seance]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Seance copyWith({
    int? id,
    int? filmId,
    int? cinemaId,
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
      if (cinemaId != null) 'cinemaId': cinemaId,
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
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SeanceImpl extends Seance {
  _SeanceImpl({
    int? id,
    required int filmId,
    int? cinemaId,
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
         cinemaId: cinemaId,
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
    Object? cinemaId = _Undefined,
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
      cinemaId: cinemaId is int? ? cinemaId : this.cinemaId,
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
