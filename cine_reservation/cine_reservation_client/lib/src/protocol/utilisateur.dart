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
import 'package:cine_reservation_client/src/protocol/protocol.dart' as _i2;

abstract class Utilisateur implements _i1.SerializableModel {
  Utilisateur._({
    this.id,
    this.authUserId,
    required this.nom,
    required this.email,
    this.telephone,
    this.dateNaissance,
    this.preferences,
    String? statut,
    String? role,
  }) : statut = statut ?? 'actif',
       role = role ?? 'client';

  factory Utilisateur({
    int? id,
    String? authUserId,
    required String nom,
    required String email,
    String? telephone,
    DateTime? dateNaissance,
    List<String>? preferences,
    String? statut,
    String? role,
  }) = _UtilisateurImpl;

  factory Utilisateur.fromJson(Map<String, dynamic> jsonSerialization) {
    return Utilisateur(
      id: jsonSerialization['id'] as int?,
      authUserId: jsonSerialization['authUserId'] as String?,
      nom: jsonSerialization['nom'] as String,
      email: jsonSerialization['email'] as String,
      telephone: jsonSerialization['telephone'] as String?,
      dateNaissance: jsonSerialization['dateNaissance'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['dateNaissance'],
            ),
      preferences: jsonSerialization['preferences'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['preferences'],
            ),
      statut: jsonSerialization['statut'] as String?,
      role: jsonSerialization['role'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String? authUserId;

  String nom;

  String email;

  String? telephone;

  DateTime? dateNaissance;

  List<String>? preferences;

  String? statut;

  String? role;

  /// Returns a shallow copy of this [Utilisateur]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Utilisateur copyWith({
    int? id,
    String? authUserId,
    String? nom,
    String? email,
    String? telephone,
    DateTime? dateNaissance,
    List<String>? preferences,
    String? statut,
    String? role,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Utilisateur',
      if (id != null) 'id': id,
      if (authUserId != null) 'authUserId': authUserId,
      'nom': nom,
      'email': email,
      if (telephone != null) 'telephone': telephone,
      if (dateNaissance != null) 'dateNaissance': dateNaissance?.toJson(),
      if (preferences != null) 'preferences': preferences?.toJson(),
      if (statut != null) 'statut': statut,
      if (role != null) 'role': role,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UtilisateurImpl extends Utilisateur {
  _UtilisateurImpl({
    int? id,
    String? authUserId,
    required String nom,
    required String email,
    String? telephone,
    DateTime? dateNaissance,
    List<String>? preferences,
    String? statut,
    String? role,
  }) : super._(
         id: id,
         authUserId: authUserId,
         nom: nom,
         email: email,
         telephone: telephone,
         dateNaissance: dateNaissance,
         preferences: preferences,
         statut: statut,
         role: role,
       );

  /// Returns a shallow copy of this [Utilisateur]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Utilisateur copyWith({
    Object? id = _Undefined,
    Object? authUserId = _Undefined,
    String? nom,
    String? email,
    Object? telephone = _Undefined,
    Object? dateNaissance = _Undefined,
    Object? preferences = _Undefined,
    Object? statut = _Undefined,
    Object? role = _Undefined,
  }) {
    return Utilisateur(
      id: id is int? ? id : this.id,
      authUserId: authUserId is String? ? authUserId : this.authUserId,
      nom: nom ?? this.nom,
      email: email ?? this.email,
      telephone: telephone is String? ? telephone : this.telephone,
      dateNaissance: dateNaissance is DateTime?
          ? dateNaissance
          : this.dateNaissance,
      preferences: preferences is List<String>?
          ? preferences
          : this.preferences?.map((e0) => e0).toList(),
      statut: statut is String? ? statut : this.statut,
      role: role is String? ? role : this.role,
    );
  }
}
