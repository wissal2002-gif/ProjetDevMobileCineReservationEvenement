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

abstract class Faq implements _i1.SerializableModel {
  Faq._({
    this.id,
    required this.question,
    required this.reponse,
    String? categorie,
    int? ordre,
    bool? actif,
  }) : categorie = categorie ?? 'general',
       ordre = ordre ?? 0,
       actif = actif ?? true;

  factory Faq({
    int? id,
    required String question,
    required String reponse,
    String? categorie,
    int? ordre,
    bool? actif,
  }) = _FaqImpl;

  factory Faq.fromJson(Map<String, dynamic> jsonSerialization) {
    return Faq(
      id: jsonSerialization['id'] as int?,
      question: jsonSerialization['question'] as String,
      reponse: jsonSerialization['reponse'] as String,
      categorie: jsonSerialization['categorie'] as String?,
      ordre: jsonSerialization['ordre'] as int?,
      actif: jsonSerialization['actif'] as bool?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String question;

  String reponse;

  String? categorie;

  int? ordre;

  bool? actif;

  /// Returns a shallow copy of this [Faq]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Faq copyWith({
    int? id,
    String? question,
    String? reponse,
    String? categorie,
    int? ordre,
    bool? actif,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Faq',
      if (id != null) 'id': id,
      'question': question,
      'reponse': reponse,
      if (categorie != null) 'categorie': categorie,
      if (ordre != null) 'ordre': ordre,
      if (actif != null) 'actif': actif,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FaqImpl extends Faq {
  _FaqImpl({
    int? id,
    required String question,
    required String reponse,
    String? categorie,
    int? ordre,
    bool? actif,
  }) : super._(
         id: id,
         question: question,
         reponse: reponse,
         categorie: categorie,
         ordre: ordre,
         actif: actif,
       );

  /// Returns a shallow copy of this [Faq]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Faq copyWith({
    Object? id = _Undefined,
    String? question,
    String? reponse,
    Object? categorie = _Undefined,
    Object? ordre = _Undefined,
    Object? actif = _Undefined,
  }) {
    return Faq(
      id: id is int? ? id : this.id,
      question: question ?? this.question,
      reponse: reponse ?? this.reponse,
      categorie: categorie is String? ? categorie : this.categorie,
      ordre: ordre is int? ? ordre : this.ordre,
      actif: actif is bool? ? actif : this.actif,
    );
  }
}
