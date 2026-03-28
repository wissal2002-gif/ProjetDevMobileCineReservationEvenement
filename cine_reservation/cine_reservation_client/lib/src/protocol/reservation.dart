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

abstract class Reservation implements _i1.SerializableModel {
  Reservation._({
    this.id,
    required this.utilisateurId,
    this.seanceId,
    this.cinemaId,
    this.evenementId,
    String? typeReservation,
    required this.dateReservation,
    required this.montantTotal,
    this.montantApresReduction,
    String? statut,
    this.codePromoId,
  }) : typeReservation = typeReservation ?? 'cinema',
       statut = statut ?? 'en_attente';

  factory Reservation({
    int? id,
    required int utilisateurId,
    int? seanceId,
    int? cinemaId,
    int? evenementId,
    String? typeReservation,
    required DateTime dateReservation,
    required double montantTotal,
    double? montantApresReduction,
    String? statut,
    int? codePromoId,
  }) = _ReservationImpl;

  factory Reservation.fromJson(Map<String, dynamic> jsonSerialization) {
    return Reservation(
      id: jsonSerialization['id'] as int?,
      utilisateurId: jsonSerialization['utilisateurId'] as int,
      seanceId: jsonSerialization['seanceId'] as int?,
      cinemaId: jsonSerialization['cinemaId'] as int?,
      evenementId: jsonSerialization['evenementId'] as int?,
      typeReservation: jsonSerialization['typeReservation'] as String?,
      dateReservation: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['dateReservation'],
      ),
      montantTotal: (jsonSerialization['montantTotal'] as num).toDouble(),
      montantApresReduction:
          (jsonSerialization['montantApresReduction'] as num?)?.toDouble(),
      statut: jsonSerialization['statut'] as String?,
      codePromoId: jsonSerialization['codePromoId'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int utilisateurId;

  int? seanceId;

  int? cinemaId;

  int? evenementId;

  String? typeReservation;

  DateTime dateReservation;

  double montantTotal;

  double? montantApresReduction;

  String? statut;

  int? codePromoId;

  /// Returns a shallow copy of this [Reservation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Reservation copyWith({
    int? id,
    int? utilisateurId,
    int? seanceId,
    int? cinemaId,
    int? evenementId,
    String? typeReservation,
    DateTime? dateReservation,
    double? montantTotal,
    double? montantApresReduction,
    String? statut,
    int? codePromoId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Reservation',
      if (id != null) 'id': id,
      'utilisateurId': utilisateurId,
      if (seanceId != null) 'seanceId': seanceId,
      if (cinemaId != null) 'cinemaId': cinemaId,
      if (evenementId != null) 'evenementId': evenementId,
      if (typeReservation != null) 'typeReservation': typeReservation,
      'dateReservation': dateReservation.toJson(),
      'montantTotal': montantTotal,
      if (montantApresReduction != null)
        'montantApresReduction': montantApresReduction,
      if (statut != null) 'statut': statut,
      if (codePromoId != null) 'codePromoId': codePromoId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReservationImpl extends Reservation {
  _ReservationImpl({
    int? id,
    required int utilisateurId,
    int? seanceId,
    int? cinemaId,
    int? evenementId,
    String? typeReservation,
    required DateTime dateReservation,
    required double montantTotal,
    double? montantApresReduction,
    String? statut,
    int? codePromoId,
  }) : super._(
         id: id,
         utilisateurId: utilisateurId,
         seanceId: seanceId,
         cinemaId: cinemaId,
         evenementId: evenementId,
         typeReservation: typeReservation,
         dateReservation: dateReservation,
         montantTotal: montantTotal,
         montantApresReduction: montantApresReduction,
         statut: statut,
         codePromoId: codePromoId,
       );

  /// Returns a shallow copy of this [Reservation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Reservation copyWith({
    Object? id = _Undefined,
    int? utilisateurId,
    Object? seanceId = _Undefined,
    Object? cinemaId = _Undefined,
    Object? evenementId = _Undefined,
    Object? typeReservation = _Undefined,
    DateTime? dateReservation,
    double? montantTotal,
    Object? montantApresReduction = _Undefined,
    Object? statut = _Undefined,
    Object? codePromoId = _Undefined,
  }) {
    return Reservation(
      id: id is int? ? id : this.id,
      utilisateurId: utilisateurId ?? this.utilisateurId,
      seanceId: seanceId is int? ? seanceId : this.seanceId,
      cinemaId: cinemaId is int? ? cinemaId : this.cinemaId,
      evenementId: evenementId is int? ? evenementId : this.evenementId,
      typeReservation: typeReservation is String?
          ? typeReservation
          : this.typeReservation,
      dateReservation: dateReservation ?? this.dateReservation,
      montantTotal: montantTotal ?? this.montantTotal,
      montantApresReduction: montantApresReduction is double?
          ? montantApresReduction
          : this.montantApresReduction,
      statut: statut is String? ? statut : this.statut,
      codePromoId: codePromoId is int? ? codePromoId : this.codePromoId,
    );
  }
}
