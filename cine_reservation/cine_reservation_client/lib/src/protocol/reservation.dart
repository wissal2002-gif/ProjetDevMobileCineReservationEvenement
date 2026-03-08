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
    required this.seanceId,
    required this.dateReservation,
    required this.montantTotal,
    String? statut,
  }) : statut = statut ?? 'en_attente';

  factory Reservation({
    int? id,
    required int utilisateurId,
    required int seanceId,
    required DateTime dateReservation,
    required double montantTotal,
    String? statut,
  }) = _ReservationImpl;

  factory Reservation.fromJson(Map<String, dynamic> jsonSerialization) {
    return Reservation(
      id: jsonSerialization['id'] as int?,
      utilisateurId: jsonSerialization['utilisateurId'] as int,
      seanceId: jsonSerialization['seanceId'] as int,
      dateReservation: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['dateReservation'],
      ),
      montantTotal: (jsonSerialization['montantTotal'] as num).toDouble(),
      statut: jsonSerialization['statut'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int utilisateurId;

  int seanceId;

  DateTime dateReservation;

  double montantTotal;

  String? statut;

  /// Returns a shallow copy of this [Reservation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Reservation copyWith({
    int? id,
    int? utilisateurId,
    int? seanceId,
    DateTime? dateReservation,
    double? montantTotal,
    String? statut,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Reservation',
      if (id != null) 'id': id,
      'utilisateurId': utilisateurId,
      'seanceId': seanceId,
      'dateReservation': dateReservation.toJson(),
      'montantTotal': montantTotal,
      if (statut != null) 'statut': statut,
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
    required int seanceId,
    required DateTime dateReservation,
    required double montantTotal,
    String? statut,
  }) : super._(
         id: id,
         utilisateurId: utilisateurId,
         seanceId: seanceId,
         dateReservation: dateReservation,
         montantTotal: montantTotal,
         statut: statut,
       );

  /// Returns a shallow copy of this [Reservation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Reservation copyWith({
    Object? id = _Undefined,
    int? utilisateurId,
    int? seanceId,
    DateTime? dateReservation,
    double? montantTotal,
    Object? statut = _Undefined,
  }) {
    return Reservation(
      id: id is int? ? id : this.id,
      utilisateurId: utilisateurId ?? this.utilisateurId,
      seanceId: seanceId ?? this.seanceId,
      dateReservation: dateReservation ?? this.dateReservation,
      montantTotal: montantTotal ?? this.montantTotal,
      statut: statut is String? ? statut : this.statut,
    );
  }
}
