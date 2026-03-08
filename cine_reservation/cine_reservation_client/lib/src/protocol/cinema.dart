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

abstract class Cinema implements _i1.SerializableModel {
  Cinema._({
    this.id,
    required this.nom,
    required this.adresse,
    required this.ville,
    this.latitude,
    this.longitude,
  });

  factory Cinema({
    int? id,
    required String nom,
    required String adresse,
    required String ville,
    double? latitude,
    double? longitude,
  }) = _CinemaImpl;

  factory Cinema.fromJson(Map<String, dynamic> jsonSerialization) {
    return Cinema(
      id: jsonSerialization['id'] as int?,
      nom: jsonSerialization['nom'] as String,
      adresse: jsonSerialization['adresse'] as String,
      ville: jsonSerialization['ville'] as String,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String nom;

  String adresse;

  String ville;

  double? latitude;

  double? longitude;

  /// Returns a shallow copy of this [Cinema]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Cinema copyWith({
    int? id,
    String? nom,
    String? adresse,
    String? ville,
    double? latitude,
    double? longitude,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Cinema',
      if (id != null) 'id': id,
      'nom': nom,
      'adresse': adresse,
      'ville': ville,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CinemaImpl extends Cinema {
  _CinemaImpl({
    int? id,
    required String nom,
    required String adresse,
    required String ville,
    double? latitude,
    double? longitude,
  }) : super._(
         id: id,
         nom: nom,
         adresse: adresse,
         ville: ville,
         latitude: latitude,
         longitude: longitude,
       );

  /// Returns a shallow copy of this [Cinema]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Cinema copyWith({
    Object? id = _Undefined,
    String? nom,
    String? adresse,
    String? ville,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
  }) {
    return Cinema(
      id: id is int? ? id : this.id,
      nom: nom ?? this.nom,
      adresse: adresse ?? this.adresse,
      ville: ville ?? this.ville,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
    );
  }
}
