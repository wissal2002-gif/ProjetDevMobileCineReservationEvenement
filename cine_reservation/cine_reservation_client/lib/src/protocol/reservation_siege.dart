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

abstract class ReservationSiege implements _i1.SerializableModel {
  ReservationSiege._({
    this.id,
    required this.reservationId,
    required this.siegeId,
    String? typeTarif,
    this.prix,
  }) : typeTarif = typeTarif ?? 'normal';

  factory ReservationSiege({
    int? id,
    required int reservationId,
    required int siegeId,
    String? typeTarif,
    double? prix,
  }) = _ReservationSiegeImpl;

  factory ReservationSiege.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReservationSiege(
      id: jsonSerialization['id'] as int?,
      reservationId: jsonSerialization['reservationId'] as int,
      siegeId: jsonSerialization['siegeId'] as int,
      typeTarif: jsonSerialization['typeTarif'] as String?,
      prix: (jsonSerialization['prix'] as num?)?.toDouble(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int reservationId;

  int siegeId;

  String? typeTarif;

  double? prix;

  /// Returns a shallow copy of this [ReservationSiege]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ReservationSiege copyWith({
    int? id,
    int? reservationId,
    int? siegeId,
    String? typeTarif,
    double? prix,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReservationSiege',
      if (id != null) 'id': id,
      'reservationId': reservationId,
      'siegeId': siegeId,
      if (typeTarif != null) 'typeTarif': typeTarif,
      if (prix != null) 'prix': prix,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReservationSiegeImpl extends ReservationSiege {
  _ReservationSiegeImpl({
    int? id,
    required int reservationId,
    required int siegeId,
    String? typeTarif,
    double? prix,
  }) : super._(
         id: id,
         reservationId: reservationId,
         siegeId: siegeId,
         typeTarif: typeTarif,
         prix: prix,
       );

  /// Returns a shallow copy of this [ReservationSiege]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ReservationSiege copyWith({
    Object? id = _Undefined,
    int? reservationId,
    int? siegeId,
    Object? typeTarif = _Undefined,
    Object? prix = _Undefined,
  }) {
    return ReservationSiege(
      id: id is int? ? id : this.id,
      reservationId: reservationId ?? this.reservationId,
      siegeId: siegeId ?? this.siegeId,
      typeTarif: typeTarif is String? ? typeTarif : this.typeTarif,
      prix: prix is double? ? prix : this.prix,
    );
  }
}
