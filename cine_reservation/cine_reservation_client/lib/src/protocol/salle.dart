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

abstract class Salle implements _i1.SerializableModel {
  Salle._({
    this.id,
    required this.cinemaId,
    required this.codeSalle,
    required this.capacite,
    this.equipements,
    String? typeProjection,
  }) : typeProjection = typeProjection ?? '2D';

  factory Salle({
    int? id,
    required int cinemaId,
    required String codeSalle,
    required int capacite,
    String? equipements,
    String? typeProjection,
  }) = _SalleImpl;

  factory Salle.fromJson(Map<String, dynamic> jsonSerialization) {
    return Salle(
      id: jsonSerialization['id'] as int?,
      cinemaId: jsonSerialization['cinemaId'] as int,
      codeSalle: jsonSerialization['codeSalle'] as String,
      capacite: jsonSerialization['capacite'] as int,
      equipements: jsonSerialization['equipements'] as String?,
      typeProjection: jsonSerialization['typeProjection'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int cinemaId;

  String codeSalle;

  int capacite;

  String? equipements;

  String? typeProjection;

  /// Returns a shallow copy of this [Salle]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Salle copyWith({
    int? id,
    int? cinemaId,
    String? codeSalle,
    int? capacite,
    String? equipements,
    String? typeProjection,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Salle',
      if (id != null) 'id': id,
      'cinemaId': cinemaId,
      'codeSalle': codeSalle,
      'capacite': capacite,
      if (equipements != null) 'equipements': equipements,
      if (typeProjection != null) 'typeProjection': typeProjection,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SalleImpl extends Salle {
  _SalleImpl({
    int? id,
    required int cinemaId,
    required String codeSalle,
    required int capacite,
    String? equipements,
    String? typeProjection,
  }) : super._(
         id: id,
         cinemaId: cinemaId,
         codeSalle: codeSalle,
         capacite: capacite,
         equipements: equipements,
         typeProjection: typeProjection,
       );

  /// Returns a shallow copy of this [Salle]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Salle copyWith({
    Object? id = _Undefined,
    int? cinemaId,
    String? codeSalle,
    int? capacite,
    Object? equipements = _Undefined,
    Object? typeProjection = _Undefined,
  }) {
    return Salle(
      id: id is int? ? id : this.id,
      cinemaId: cinemaId ?? this.cinemaId,
      codeSalle: codeSalle ?? this.codeSalle,
      capacite: capacite ?? this.capacite,
      equipements: equipements is String? ? equipements : this.equipements,
      typeProjection: typeProjection is String?
          ? typeProjection
          : this.typeProjection,
    );
  }
}
