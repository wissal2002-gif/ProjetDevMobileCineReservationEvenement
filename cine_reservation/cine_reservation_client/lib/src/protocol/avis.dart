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

abstract class Avis implements _i1.SerializableModel {
  Avis._({
    this.id,
    required this.utilisateurId,
    required this.filmId,
    required this.note,
    required this.dateAvis,
  });

  factory Avis({
    int? id,
    required int utilisateurId,
    required int filmId,
    required int note,
    required DateTime dateAvis,
  }) = _AvisImpl;

  factory Avis.fromJson(Map<String, dynamic> jsonSerialization) {
    return Avis(
      id: jsonSerialization['id'] as int?,
      utilisateurId: jsonSerialization['utilisateurId'] as int,
      filmId: jsonSerialization['filmId'] as int,
      note: jsonSerialization['note'] as int,
      dateAvis: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['dateAvis'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int utilisateurId;

  int filmId;

  int note;

  DateTime dateAvis;

  /// Returns a shallow copy of this [Avis]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Avis copyWith({
    int? id,
    int? utilisateurId,
    int? filmId,
    int? note,
    DateTime? dateAvis,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Avis',
      if (id != null) 'id': id,
      'utilisateurId': utilisateurId,
      'filmId': filmId,
      'note': note,
      'dateAvis': dateAvis.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AvisImpl extends Avis {
  _AvisImpl({
    int? id,
    required int utilisateurId,
    required int filmId,
    required int note,
    required DateTime dateAvis,
  }) : super._(
         id: id,
         utilisateurId: utilisateurId,
         filmId: filmId,
         note: note,
         dateAvis: dateAvis,
       );

  /// Returns a shallow copy of this [Avis]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Avis copyWith({
    Object? id = _Undefined,
    int? utilisateurId,
    int? filmId,
    int? note,
    DateTime? dateAvis,
  }) {
    return Avis(
      id: id is int? ? id : this.id,
      utilisateurId: utilisateurId ?? this.utilisateurId,
      filmId: filmId ?? this.filmId,
      note: note ?? this.note,
      dateAvis: dateAvis ?? this.dateAvis,
    );
  }
}
