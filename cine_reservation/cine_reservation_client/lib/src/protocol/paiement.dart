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

abstract class Paiement implements _i1.SerializableModel {
  Paiement._({
    this.id,
    required this.reservationId,
    required this.montant,
    String? methode,
    String? statut,
    this.stripePaymentId,
    this.paypalOrderId,
    this.createdAt,
  }) : methode = methode ?? 'carte',
       statut = statut ?? 'en_attente';

  factory Paiement({
    int? id,
    required int reservationId,
    required double montant,
    String? methode,
    String? statut,
    String? stripePaymentId,
    String? paypalOrderId,
    DateTime? createdAt,
  }) = _PaiementImpl;

  factory Paiement.fromJson(Map<String, dynamic> jsonSerialization) {
    return Paiement(
      id: jsonSerialization['id'] as int?,
      reservationId: jsonSerialization['reservationId'] as int,
      montant: (jsonSerialization['montant'] as num).toDouble(),
      methode: jsonSerialization['methode'] as String?,
      statut: jsonSerialization['statut'] as String?,
      stripePaymentId: jsonSerialization['stripePaymentId'] as String?,
      paypalOrderId: jsonSerialization['paypalOrderId'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int reservationId;

  double montant;

  String? methode;

  String? statut;

  String? stripePaymentId;

  String? paypalOrderId;

  DateTime? createdAt;

  /// Returns a shallow copy of this [Paiement]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Paiement copyWith({
    int? id,
    int? reservationId,
    double? montant,
    String? methode,
    String? statut,
    String? stripePaymentId,
    String? paypalOrderId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Paiement',
      if (id != null) 'id': id,
      'reservationId': reservationId,
      'montant': montant,
      if (methode != null) 'methode': methode,
      if (statut != null) 'statut': statut,
      if (stripePaymentId != null) 'stripePaymentId': stripePaymentId,
      if (paypalOrderId != null) 'paypalOrderId': paypalOrderId,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PaiementImpl extends Paiement {
  _PaiementImpl({
    int? id,
    required int reservationId,
    required double montant,
    String? methode,
    String? statut,
    String? stripePaymentId,
    String? paypalOrderId,
    DateTime? createdAt,
  }) : super._(
         id: id,
         reservationId: reservationId,
         montant: montant,
         methode: methode,
         statut: statut,
         stripePaymentId: stripePaymentId,
         paypalOrderId: paypalOrderId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Paiement]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Paiement copyWith({
    Object? id = _Undefined,
    int? reservationId,
    double? montant,
    Object? methode = _Undefined,
    Object? statut = _Undefined,
    Object? stripePaymentId = _Undefined,
    Object? paypalOrderId = _Undefined,
    Object? createdAt = _Undefined,
  }) {
    return Paiement(
      id: id is int? ? id : this.id,
      reservationId: reservationId ?? this.reservationId,
      montant: montant ?? this.montant,
      methode: methode is String? ? methode : this.methode,
      statut: statut is String? ? statut : this.statut,
      stripePaymentId: stripePaymentId is String?
          ? stripePaymentId
          : this.stripePaymentId,
      paypalOrderId: paypalOrderId is String?
          ? paypalOrderId
          : this.paypalOrderId,
      createdAt: createdAt is DateTime? ? createdAt : this.createdAt,
    );
  }
}
