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

abstract class Fidelite implements _i1.SerializableModel {
  Fidelite._({
    this.id,
    required this.utilisateurId,
    int? points,
    String? niveau,
    double? totalDepense,
    this.dateAdhesion,
  }) : points = points ?? 0,
       niveau = niveau ?? 'bronze',
       totalDepense = totalDepense ?? 0.0;

  factory Fidelite({
    int? id,
    required int utilisateurId,
    int? points,
    String? niveau,
    double? totalDepense,
    DateTime? dateAdhesion,
  }) = _FideliteImpl;

  factory Fidelite.fromJson(Map<String, dynamic> jsonSerialization) {
    return Fidelite(
      id: jsonSerialization['id'] as int?,
      utilisateurId: jsonSerialization['utilisateurId'] as int,
      points: jsonSerialization['points'] as int?,
      niveau: jsonSerialization['niveau'] as String?,
      totalDepense: (jsonSerialization['totalDepense'] as num?)?.toDouble(),
      dateAdhesion: jsonSerialization['dateAdhesion'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['dateAdhesion'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int utilisateurId;

  int? points;

  String? niveau;

  double? totalDepense;

  DateTime? dateAdhesion;

  /// Returns a shallow copy of this [Fidelite]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Fidelite copyWith({
    int? id,
    int? utilisateurId,
    int? points,
    String? niveau,
    double? totalDepense,
    DateTime? dateAdhesion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Fidelite',
      if (id != null) 'id': id,
      'utilisateurId': utilisateurId,
      if (points != null) 'points': points,
      if (niveau != null) 'niveau': niveau,
      if (totalDepense != null) 'totalDepense': totalDepense,
      if (dateAdhesion != null) 'dateAdhesion': dateAdhesion?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FideliteImpl extends Fidelite {
  _FideliteImpl({
    int? id,
    required int utilisateurId,
    int? points,
    String? niveau,
    double? totalDepense,
    DateTime? dateAdhesion,
  }) : super._(
         id: id,
         utilisateurId: utilisateurId,
         points: points,
         niveau: niveau,
         totalDepense: totalDepense,
         dateAdhesion: dateAdhesion,
       );

  /// Returns a shallow copy of this [Fidelite]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Fidelite copyWith({
    Object? id = _Undefined,
    int? utilisateurId,
    Object? points = _Undefined,
    Object? niveau = _Undefined,
    Object? totalDepense = _Undefined,
    Object? dateAdhesion = _Undefined,
  }) {
    return Fidelite(
      id: id is int? ? id : this.id,
      utilisateurId: utilisateurId ?? this.utilisateurId,
      points: points is int? ? points : this.points,
      niveau: niveau is String? ? niveau : this.niveau,
      totalDepense: totalDepense is double? ? totalDepense : this.totalDepense,
      dateAdhesion: dateAdhesion is DateTime?
          ? dateAdhesion
          : this.dateAdhesion,
    );
  }
}
