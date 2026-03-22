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

abstract class Remboursement implements _i1.SerializableModel {
  Remboursement._({
    this.id,
    required this.paiementId,
    required this.reservationId,
    required this.utilisateurId,
    required this.montant,
    this.raison,
    String? statut,
    this.stripeRefundId,
    required this.dateDemandeRemboursement,
    this.dateRemboursement,
    this.traitePar,
  }) : statut = statut ?? 'en_attente';

  factory Remboursement({
    int? id,
    required int paiementId,
    required int reservationId,
    required int utilisateurId,
    required double montant,
    String? raison,
    String? statut,
    String? stripeRefundId,
    required DateTime dateDemandeRemboursement,
    DateTime? dateRemboursement,
    int? traitePar,
  }) = _RemboursementImpl;

  factory Remboursement.fromJson(Map<String, dynamic> jsonSerialization) {
    return Remboursement(
      id: jsonSerialization['id'] as int?,
      paiementId: jsonSerialization['paiementId'] as int,
      reservationId: jsonSerialization['reservationId'] as int,
      utilisateurId: jsonSerialization['utilisateurId'] as int,
      montant: (jsonSerialization['montant'] as num).toDouble(),
      raison: jsonSerialization['raison'] as String?,
      statut: jsonSerialization['statut'] as String?,
      stripeRefundId: jsonSerialization['stripeRefundId'] as String?,
      dateDemandeRemboursement: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['dateDemandeRemboursement'],
      ),
      dateRemboursement: jsonSerialization['dateRemboursement'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['dateRemboursement'],
            ),
      traitePar: jsonSerialization['traitePar'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int paiementId;

  int reservationId;

  int utilisateurId;

  double montant;

  String? raison;

  String? statut;

  String? stripeRefundId;

  DateTime dateDemandeRemboursement;

  DateTime? dateRemboursement;

  int? traitePar;

  /// Returns a shallow copy of this [Remboursement]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Remboursement copyWith({
    int? id,
    int? paiementId,
    int? reservationId,
    int? utilisateurId,
    double? montant,
    String? raison,
    String? statut,
    String? stripeRefundId,
    DateTime? dateDemandeRemboursement,
    DateTime? dateRemboursement,
    int? traitePar,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Remboursement',
      if (id != null) 'id': id,
      'paiementId': paiementId,
      'reservationId': reservationId,
      'utilisateurId': utilisateurId,
      'montant': montant,
      if (raison != null) 'raison': raison,
      if (statut != null) 'statut': statut,
      if (stripeRefundId != null) 'stripeRefundId': stripeRefundId,
      'dateDemandeRemboursement': dateDemandeRemboursement.toJson(),
      if (dateRemboursement != null)
        'dateRemboursement': dateRemboursement?.toJson(),
      if (traitePar != null) 'traitePar': traitePar,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RemboursementImpl extends Remboursement {
  _RemboursementImpl({
    int? id,
    required int paiementId,
    required int reservationId,
    required int utilisateurId,
    required double montant,
    String? raison,
    String? statut,
    String? stripeRefundId,
    required DateTime dateDemandeRemboursement,
    DateTime? dateRemboursement,
    int? traitePar,
  }) : super._(
         id: id,
         paiementId: paiementId,
         reservationId: reservationId,
         utilisateurId: utilisateurId,
         montant: montant,
         raison: raison,
         statut: statut,
         stripeRefundId: stripeRefundId,
         dateDemandeRemboursement: dateDemandeRemboursement,
         dateRemboursement: dateRemboursement,
         traitePar: traitePar,
       );

  /// Returns a shallow copy of this [Remboursement]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Remboursement copyWith({
    Object? id = _Undefined,
    int? paiementId,
    int? reservationId,
    int? utilisateurId,
    double? montant,
    Object? raison = _Undefined,
    Object? statut = _Undefined,
    Object? stripeRefundId = _Undefined,
    DateTime? dateDemandeRemboursement,
    Object? dateRemboursement = _Undefined,
    Object? traitePar = _Undefined,
  }) {
    return Remboursement(
      id: id is int? ? id : this.id,
      paiementId: paiementId ?? this.paiementId,
      reservationId: reservationId ?? this.reservationId,
      utilisateurId: utilisateurId ?? this.utilisateurId,
      montant: montant ?? this.montant,
      raison: raison is String? ? raison : this.raison,
      statut: statut is String? ? statut : this.statut,
      stripeRefundId: stripeRefundId is String?
          ? stripeRefundId
          : this.stripeRefundId,
      dateDemandeRemboursement:
          dateDemandeRemboursement ?? this.dateDemandeRemboursement,
      dateRemboursement: dateRemboursement is DateTime?
          ? dateRemboursement
          : this.dateRemboursement,
      traitePar: traitePar is int? ? traitePar : this.traitePar,
    );
  }
}
