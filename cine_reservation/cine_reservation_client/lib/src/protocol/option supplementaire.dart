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

abstract class OptionSupplementaire implements _i1.SerializableModel {
  OptionSupplementaire._({
    this.id,
    required this.nom,
    this.description,
    required this.prix,
    String? categorie,
    bool? disponible,
    this.image,
    this.cinemaId,
  }) : categorie = categorie ?? 'snack',
       disponible = disponible ?? true;

  factory OptionSupplementaire({
    int? id,
    required String nom,
    String? description,
    required double prix,
    String? categorie,
    bool? disponible,
    String? image,
    int? cinemaId,
  }) = _OptionSupplementaireImpl;

  factory OptionSupplementaire.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return OptionSupplementaire(
      id: jsonSerialization['id'] as int?,
      nom: jsonSerialization['nom'] as String,
      description: jsonSerialization['description'] as String?,
      prix: (jsonSerialization['prix'] as num).toDouble(),
      categorie: jsonSerialization['categorie'] as String?,
      disponible: jsonSerialization['disponible'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['disponible']),
      image: jsonSerialization['image'] as String?,
      cinemaId: jsonSerialization['cinemaId'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String nom;

  String? description;

  double prix;

  String? categorie;

  bool? disponible;

  String? image;

  int? cinemaId;

  /// Returns a shallow copy of this [OptionSupplementaire]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OptionSupplementaire copyWith({
    int? id,
    String? nom,
    String? description,
    double? prix,
    String? categorie,
    bool? disponible,
    String? image,
    int? cinemaId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OptionSupplementaire',
      if (id != null) 'id': id,
      'nom': nom,
      if (description != null) 'description': description,
      'prix': prix,
      if (categorie != null) 'categorie': categorie,
      if (disponible != null) 'disponible': disponible,
      if (image != null) 'image': image,
      if (cinemaId != null) 'cinemaId': cinemaId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OptionSupplementaireImpl extends OptionSupplementaire {
  _OptionSupplementaireImpl({
    int? id,
    required String nom,
    String? description,
    required double prix,
    String? categorie,
    bool? disponible,
    String? image,
    int? cinemaId,
  }) : super._(
         id: id,
         nom: nom,
         description: description,
         prix: prix,
         categorie: categorie,
         disponible: disponible,
         image: image,
         cinemaId: cinemaId,
       );

  /// Returns a shallow copy of this [OptionSupplementaire]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OptionSupplementaire copyWith({
    Object? id = _Undefined,
    String? nom,
    Object? description = _Undefined,
    double? prix,
    Object? categorie = _Undefined,
    Object? disponible = _Undefined,
    Object? image = _Undefined,
    Object? cinemaId = _Undefined,
  }) {
    return OptionSupplementaire(
      id: id is int? ? id : this.id,
      nom: nom ?? this.nom,
      description: description is String? ? description : this.description,
      prix: prix ?? this.prix,
      categorie: categorie is String? ? categorie : this.categorie,
      disponible: disponible is bool? ? disponible : this.disponible,
      image: image is String? ? image : this.image,
      cinemaId: cinemaId is int? ? cinemaId : this.cinemaId,
    );
  }
}
