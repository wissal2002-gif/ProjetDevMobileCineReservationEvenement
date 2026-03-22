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

abstract class Favori implements _i1.SerializableModel {
  Favori._({
    this.id,
    required this.utilisateurId,
    this.filmId,
    this.cinemaId,
  });

  factory Favori({
    int? id,
    required int utilisateurId,
    int? filmId,
    int? cinemaId,
  }) = _FavoriImpl;

  factory Favori.fromJson(Map<String, dynamic> jsonSerialization) {
    return Favori(
      id: jsonSerialization['id'] as int?,
      utilisateurId: jsonSerialization['utilisateurId'] as int,
      filmId: jsonSerialization['filmId'] as int?,
      cinemaId: jsonSerialization['cinemaId'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int utilisateurId;

  int? filmId;

  int? cinemaId;

  /// Returns a shallow copy of this [Favori]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Favori copyWith({
    int? id,
    int? utilisateurId,
    int? filmId,
    int? cinemaId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Favori',
      if (id != null) 'id': id,
      'utilisateurId': utilisateurId,
      if (filmId != null) 'filmId': filmId,
      if (cinemaId != null) 'cinemaId': cinemaId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FavoriImpl extends Favori {
  _FavoriImpl({
    int? id,
    required int utilisateurId,
    int? filmId,
    int? cinemaId,
  }) : super._(
         id: id,
         utilisateurId: utilisateurId,
         filmId: filmId,
         cinemaId: cinemaId,
       );

  /// Returns a shallow copy of this [Favori]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Favori copyWith({
    Object? id = _Undefined,
    int? utilisateurId,
    Object? filmId = _Undefined,
    Object? cinemaId = _Undefined,
  }) {
    return Favori(
      id: id is int? ? id : this.id,
      utilisateurId: utilisateurId ?? this.utilisateurId,
      filmId: filmId is int? ? filmId : this.filmId,
      cinemaId: cinemaId is int? ? cinemaId : this.cinemaId,
    );
  }
}
