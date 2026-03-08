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

abstract class ReservationOption implements _i1.SerializableModel {
  ReservationOption._({
    this.id,
    required this.reservationId,
    required this.optionId,
    int? quantite,
    this.prixUnitaire,
  }) : quantite = quantite ?? 1;

  factory ReservationOption({
    int? id,
    required int reservationId,
    required int optionId,
    int? quantite,
    double? prixUnitaire,
  }) = _ReservationOptionImpl;

  factory ReservationOption.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReservationOption(
      id: jsonSerialization['id'] as int?,
      reservationId: jsonSerialization['reservationId'] as int,
      optionId: jsonSerialization['optionId'] as int,
      quantite: jsonSerialization['quantite'] as int?,
      prixUnitaire: (jsonSerialization['prixUnitaire'] as num?)?.toDouble(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int reservationId;

  int optionId;

  int? quantite;

  double? prixUnitaire;

  /// Returns a shallow copy of this [ReservationOption]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ReservationOption copyWith({
    int? id,
    int? reservationId,
    int? optionId,
    int? quantite,
    double? prixUnitaire,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReservationOption',
      if (id != null) 'id': id,
      'reservationId': reservationId,
      'optionId': optionId,
      if (quantite != null) 'quantite': quantite,
      if (prixUnitaire != null) 'prixUnitaire': prixUnitaire,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReservationOptionImpl extends ReservationOption {
  _ReservationOptionImpl({
    int? id,
    required int reservationId,
    required int optionId,
    int? quantite,
    double? prixUnitaire,
  }) : super._(
         id: id,
         reservationId: reservationId,
         optionId: optionId,
         quantite: quantite,
         prixUnitaire: prixUnitaire,
       );

  /// Returns a shallow copy of this [ReservationOption]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ReservationOption copyWith({
    Object? id = _Undefined,
    int? reservationId,
    int? optionId,
    Object? quantite = _Undefined,
    Object? prixUnitaire = _Undefined,
  }) {
    return ReservationOption(
      id: id is int? ? id : this.id,
      reservationId: reservationId ?? this.reservationId,
      optionId: optionId ?? this.optionId,
      quantite: quantite is int? ? quantite : this.quantite,
      prixUnitaire: prixUnitaire is double? ? prixUnitaire : this.prixUnitaire,
    );
  }
}
