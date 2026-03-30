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

abstract class DemandeSupport implements _i1.SerializableModel {
  DemandeSupport._({
    this.id,
    required this.utilisateurId,
    this.cinemaId,
    required this.sujet,
    required this.message,
    String? statut,
    this.reponse,
    this.createdAt,
    this.updatedAt,
  }) : statut = statut ?? 'ouvert';

  factory DemandeSupport({
    int? id,
    required int utilisateurId,
    int? cinemaId,
    required String sujet,
    required String message,
    String? statut,
    String? reponse,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _DemandeSupportImpl;

  factory DemandeSupport.fromJson(Map<String, dynamic> jsonSerialization) {
    return DemandeSupport(
      id: jsonSerialization['id'] as int?,
      utilisateurId: jsonSerialization['utilisateurId'] as int,
      cinemaId: jsonSerialization['cinemaId'] as int?,
      sujet: jsonSerialization['sujet'] as String,
      message: jsonSerialization['message'] as String,
      statut: jsonSerialization['statut'] as String?,
      reponse: jsonSerialization['reponse'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int utilisateurId;

  int? cinemaId;

  String sujet;

  String message;

  String? statut;

  String? reponse;

  DateTime? createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [DemandeSupport]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DemandeSupport copyWith({
    int? id,
    int? utilisateurId,
    int? cinemaId,
    String? sujet,
    String? message,
    String? statut,
    String? reponse,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DemandeSupport',
      if (id != null) 'id': id,
      'utilisateurId': utilisateurId,
      if (cinemaId != null) 'cinemaId': cinemaId,
      'sujet': sujet,
      'message': message,
      if (statut != null) 'statut': statut,
      if (reponse != null) 'reponse': reponse,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DemandeSupportImpl extends DemandeSupport {
  _DemandeSupportImpl({
    int? id,
    required int utilisateurId,
    int? cinemaId,
    required String sujet,
    required String message,
    String? statut,
    String? reponse,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         utilisateurId: utilisateurId,
         cinemaId: cinemaId,
         sujet: sujet,
         message: message,
         statut: statut,
         reponse: reponse,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [DemandeSupport]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DemandeSupport copyWith({
    Object? id = _Undefined,
    int? utilisateurId,
    Object? cinemaId = _Undefined,
    String? sujet,
    String? message,
    Object? statut = _Undefined,
    Object? reponse = _Undefined,
    Object? createdAt = _Undefined,
    Object? updatedAt = _Undefined,
  }) {
    return DemandeSupport(
      id: id is int? ? id : this.id,
      utilisateurId: utilisateurId ?? this.utilisateurId,
      cinemaId: cinemaId is int? ? cinemaId : this.cinemaId,
      sujet: sujet ?? this.sujet,
      message: message ?? this.message,
      statut: statut is String? ? statut : this.statut,
      reponse: reponse is String? ? reponse : this.reponse,
      createdAt: createdAt is DateTime? ? createdAt : this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}
