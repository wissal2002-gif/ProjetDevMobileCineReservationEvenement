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

abstract class CodePromo implements _i1.SerializableModel {
  CodePromo._({
    this.id,
    required this.code,
    this.description,
    required this.reduction,
    String? typeReduction,
    double? montantMinimum,
    this.dateExpiration,
    int? utilisationsMax,
    int? utilisationsActuelles,
    bool? actif,
  }) : typeReduction = typeReduction ?? 'pourcentage',
       montantMinimum = montantMinimum ?? 0.0,
       utilisationsMax = utilisationsMax ?? 100,
       utilisationsActuelles = utilisationsActuelles ?? 0,
       actif = actif ?? true;

  factory CodePromo({
    int? id,
    required String code,
    String? description,
    required double reduction,
    String? typeReduction,
    double? montantMinimum,
    DateTime? dateExpiration,
    int? utilisationsMax,
    int? utilisationsActuelles,
    bool? actif,
  }) = _CodePromoImpl;

  factory CodePromo.fromJson(Map<String, dynamic> jsonSerialization) {
    return CodePromo(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      description: jsonSerialization['description'] as String?,
      reduction: (jsonSerialization['reduction'] as num).toDouble(),
      typeReduction: jsonSerialization['typeReduction'] as String?,
      montantMinimum: (jsonSerialization['montantMinimum'] as num?)?.toDouble(),
      dateExpiration: jsonSerialization['dateExpiration'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['dateExpiration'],
            ),
      utilisationsMax: jsonSerialization['utilisationsMax'] as int?,
      utilisationsActuelles: jsonSerialization['utilisationsActuelles'] as int?,
      actif: jsonSerialization['actif'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['actif']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String code;

  String? description;

  double reduction;

  String? typeReduction;

  double? montantMinimum;

  DateTime? dateExpiration;

  int? utilisationsMax;

  int? utilisationsActuelles;

  bool? actif;

  /// Returns a shallow copy of this [CodePromo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CodePromo copyWith({
    int? id,
    String? code,
    String? description,
    double? reduction,
    String? typeReduction,
    double? montantMinimum,
    DateTime? dateExpiration,
    int? utilisationsMax,
    int? utilisationsActuelles,
    bool? actif,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CodePromo',
      if (id != null) 'id': id,
      'code': code,
      if (description != null) 'description': description,
      'reduction': reduction,
      if (typeReduction != null) 'typeReduction': typeReduction,
      if (montantMinimum != null) 'montantMinimum': montantMinimum,
      if (dateExpiration != null) 'dateExpiration': dateExpiration?.toJson(),
      if (utilisationsMax != null) 'utilisationsMax': utilisationsMax,
      if (utilisationsActuelles != null)
        'utilisationsActuelles': utilisationsActuelles,
      if (actif != null) 'actif': actif,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CodePromoImpl extends CodePromo {
  _CodePromoImpl({
    int? id,
    required String code,
    String? description,
    required double reduction,
    String? typeReduction,
    double? montantMinimum,
    DateTime? dateExpiration,
    int? utilisationsMax,
    int? utilisationsActuelles,
    bool? actif,
  }) : super._(
         id: id,
         code: code,
         description: description,
         reduction: reduction,
         typeReduction: typeReduction,
         montantMinimum: montantMinimum,
         dateExpiration: dateExpiration,
         utilisationsMax: utilisationsMax,
         utilisationsActuelles: utilisationsActuelles,
         actif: actif,
       );

  /// Returns a shallow copy of this [CodePromo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CodePromo copyWith({
    Object? id = _Undefined,
    String? code,
    Object? description = _Undefined,
    double? reduction,
    Object? typeReduction = _Undefined,
    Object? montantMinimum = _Undefined,
    Object? dateExpiration = _Undefined,
    Object? utilisationsMax = _Undefined,
    Object? utilisationsActuelles = _Undefined,
    Object? actif = _Undefined,
  }) {
    return CodePromo(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      description: description is String? ? description : this.description,
      reduction: reduction ?? this.reduction,
      typeReduction: typeReduction is String?
          ? typeReduction
          : this.typeReduction,
      montantMinimum: montantMinimum is double?
          ? montantMinimum
          : this.montantMinimum,
      dateExpiration: dateExpiration is DateTime?
          ? dateExpiration
          : this.dateExpiration,
      utilisationsMax: utilisationsMax is int?
          ? utilisationsMax
          : this.utilisationsMax,
      utilisationsActuelles: utilisationsActuelles is int?
          ? utilisationsActuelles
          : this.utilisationsActuelles,
      actif: actif is bool? ? actif : this.actif,
    );
  }
}
