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

abstract class Billet implements _i1.SerializableModel {
  Billet._({
    this.id,
    required this.reservationId,
    required this.siegeId,
    required this.dateEmission,
    bool? estValide,
    String? typeBillet,
    this.qrCode,
  }) : estValide = estValide ?? true,
       typeBillet = typeBillet ?? 'standard';

  factory Billet({
    int? id,
    required int reservationId,
    required int siegeId,
    required DateTime dateEmission,
    bool? estValide,
    String? typeBillet,
    String? qrCode,
  }) = _BilletImpl;

  factory Billet.fromJson(Map<String, dynamic> jsonSerialization) {
    return Billet(
      id: jsonSerialization['id'] as int?,
      reservationId: jsonSerialization['reservationId'] as int,
      siegeId: jsonSerialization['siegeId'] as int,
      dateEmission: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['dateEmission'],
      ),
      estValide: jsonSerialization['estValide'] as bool?,
      typeBillet: jsonSerialization['typeBillet'] as String?,
      qrCode: jsonSerialization['qrCode'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int reservationId;

  int siegeId;

  DateTime dateEmission;

  bool? estValide;

  String? typeBillet;

  String? qrCode;

  /// Returns a shallow copy of this [Billet]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Billet copyWith({
    int? id,
    int? reservationId,
    int? siegeId,
    DateTime? dateEmission,
    bool? estValide,
    String? typeBillet,
    String? qrCode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Billet',
      if (id != null) 'id': id,
      'reservationId': reservationId,
      'siegeId': siegeId,
      'dateEmission': dateEmission.toJson(),
      if (estValide != null) 'estValide': estValide,
      if (typeBillet != null) 'typeBillet': typeBillet,
      if (qrCode != null) 'qrCode': qrCode,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BilletImpl extends Billet {
  _BilletImpl({
    int? id,
    required int reservationId,
    required int siegeId,
    required DateTime dateEmission,
    bool? estValide,
    String? typeBillet,
    String? qrCode,
  }) : super._(
         id: id,
         reservationId: reservationId,
         siegeId: siegeId,
         dateEmission: dateEmission,
         estValide: estValide,
         typeBillet: typeBillet,
         qrCode: qrCode,
       );

  /// Returns a shallow copy of this [Billet]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Billet copyWith({
    Object? id = _Undefined,
    int? reservationId,
    int? siegeId,
    DateTime? dateEmission,
    Object? estValide = _Undefined,
    Object? typeBillet = _Undefined,
    Object? qrCode = _Undefined,
  }) {
    return Billet(
      id: id is int? ? id : this.id,
      reservationId: reservationId ?? this.reservationId,
      siegeId: siegeId ?? this.siegeId,
      dateEmission: dateEmission ?? this.dateEmission,
      estValide: estValide is bool? ? estValide : this.estValide,
      typeBillet: typeBillet is String? ? typeBillet : this.typeBillet,
      qrCode: qrCode is String? ? qrCode : this.qrCode,
    );
  }
}
