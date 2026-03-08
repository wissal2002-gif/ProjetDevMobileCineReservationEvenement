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
    required this.salleId,
    required this.dateHeure,
    String? langue,
    String? typeProjection,
    required this.placesDisponibles,
    required this.prix,
  }) : langue = langue ?? 'VF',
       typeProjection = typeProjection ?? '2D';

  factory Seance({
    int? id,
    required int filmId,
    required int salleId,
    required DateTime dateHeure,
    String? langue,
    String? typeProjection,
    required int placesDisponibles,
    required double prix,
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
      placesDisponibles: jsonSerialization['placesDisponibles'] as int,
      prix: (jsonSerialization['prix'] as num).toDouble(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int filmId;

  int salleId;

  DateTime dateHeure;

  String? langue;

  String? typeProjection;

  int placesDisponibles;

  double prix;

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
    int? placesDisponibles,
    double? prix,
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
      'placesDisponibles': placesDisponibles,
      'prix': prix,
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
    required int salleId,
    required DateTime dateHeure,
    String? langue,
    String? typeProjection,
    required int placesDisponibles,
    required double prix,
  }) : super._(
         id: id,
         filmId: filmId,
         salleId: salleId,
         dateHeure: dateHeure,
         langue: langue,
         typeProjection: typeProjection,
         placesDisponibles: placesDisponibles,
         prix: prix,
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
    int? placesDisponibles,
    double? prix,
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
      placesDisponibles: placesDisponibles ?? this.placesDisponibles,
      prix: prix ?? this.prix,
    );
  }
}
