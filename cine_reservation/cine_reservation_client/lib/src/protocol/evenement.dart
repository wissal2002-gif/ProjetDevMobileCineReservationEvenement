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

abstract class Evenement implements _i1.SerializableModel {
  Evenement._({
    this.id,
    required this.titre,
    this.description,
    String? type,
    this.cinemaId,
    this.lieu,
    this.ville,
    required this.dateDebut,
    this.dateFin,
    this.affiche,
    this.bandeAnnonce,
    double? prix,
    int? placesDisponibles,
    int? placesTotales,
    this.organisateur,
    double? noteMoyenne,
    int? nombreAvis,
    String? statut,
    bool? annulationGratuite,
    int? delaiAnnulation,
    double? fraisAnnulation,
  }) : type = type ?? 'concert',
       prix = prix ?? 0.0,
       placesDisponibles = placesDisponibles ?? 0,
       placesTotales = placesTotales ?? 0,
       noteMoyenne = noteMoyenne ?? 0.0,
       nombreAvis = nombreAvis ?? 0,
       statut = statut ?? 'actif',
       annulationGratuite = annulationGratuite ?? true,
       delaiAnnulation = delaiAnnulation ?? 48,
       fraisAnnulation = fraisAnnulation ?? 0.0;

  factory Evenement({
    int? id,
    required String titre,
    String? description,
    String? type,
    int? cinemaId,
    String? lieu,
    String? ville,
    required DateTime dateDebut,
    DateTime? dateFin,
    String? affiche,
    String? bandeAnnonce,
    double? prix,
    int? placesDisponibles,
    int? placesTotales,
    String? organisateur,
    double? noteMoyenne,
    int? nombreAvis,
    String? statut,
    bool? annulationGratuite,
    int? delaiAnnulation,
    double? fraisAnnulation,
  }) = _EvenementImpl;

  factory Evenement.fromJson(Map<String, dynamic> jsonSerialization) {
    return Evenement(
      id: jsonSerialization['id'] as int?,
      titre: jsonSerialization['titre'] as String,
      description: jsonSerialization['description'] as String?,
      type: jsonSerialization['type'] as String?,
      cinemaId: jsonSerialization['cinemaId'] as int?,
      lieu: jsonSerialization['lieu'] as String?,
      ville: jsonSerialization['ville'] as String?,
      dateDebut: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['dateDebut'],
      ),
      dateFin: jsonSerialization['dateFin'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['dateFin']),
      affiche: jsonSerialization['affiche'] as String?,
      bandeAnnonce: jsonSerialization['bandeAnnonce'] as String?,
      prix: (jsonSerialization['prix'] as num?)?.toDouble(),
      placesDisponibles: jsonSerialization['placesDisponibles'] as int?,
      placesTotales: jsonSerialization['placesTotales'] as int?,
      organisateur: jsonSerialization['organisateur'] as String?,
      noteMoyenne: (jsonSerialization['noteMoyenne'] as num?)?.toDouble(),
      nombreAvis: jsonSerialization['nombreAvis'] as int?,
      statut: jsonSerialization['statut'] as String?,
      annulationGratuite: jsonSerialization['annulationGratuite'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['annulationGratuite'],
            ),
      delaiAnnulation: jsonSerialization['delaiAnnulation'] as int?,
      fraisAnnulation: (jsonSerialization['fraisAnnulation'] as num?)
          ?.toDouble(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String titre;

  String? description;

  String? type;

  int? cinemaId;

  String? lieu;

  String? ville;

  DateTime dateDebut;

  DateTime? dateFin;

  String? affiche;

  String? bandeAnnonce;

  double? prix;

  int? placesDisponibles;

  int? placesTotales;

  String? organisateur;

  double? noteMoyenne;

  int? nombreAvis;

  String? statut;

  bool? annulationGratuite;

  int? delaiAnnulation;

  double? fraisAnnulation;

  /// Returns a shallow copy of this [Evenement]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Evenement copyWith({
    int? id,
    String? titre,
    String? description,
    String? type,
    int? cinemaId,
    String? lieu,
    String? ville,
    DateTime? dateDebut,
    DateTime? dateFin,
    String? affiche,
    String? bandeAnnonce,
    double? prix,
    int? placesDisponibles,
    int? placesTotales,
    String? organisateur,
    double? noteMoyenne,
    int? nombreAvis,
    String? statut,
    bool? annulationGratuite,
    int? delaiAnnulation,
    double? fraisAnnulation,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Evenement',
      if (id != null) 'id': id,
      'titre': titre,
      if (description != null) 'description': description,
      if (type != null) 'type': type,
      if (cinemaId != null) 'cinemaId': cinemaId,
      if (lieu != null) 'lieu': lieu,
      if (ville != null) 'ville': ville,
      'dateDebut': dateDebut.toJson(),
      if (dateFin != null) 'dateFin': dateFin?.toJson(),
      if (affiche != null) 'affiche': affiche,
      if (bandeAnnonce != null) 'bandeAnnonce': bandeAnnonce,
      if (prix != null) 'prix': prix,
      if (placesDisponibles != null) 'placesDisponibles': placesDisponibles,
      if (placesTotales != null) 'placesTotales': placesTotales,
      if (organisateur != null) 'organisateur': organisateur,
      if (noteMoyenne != null) 'noteMoyenne': noteMoyenne,
      if (nombreAvis != null) 'nombreAvis': nombreAvis,
      if (statut != null) 'statut': statut,
      if (annulationGratuite != null) 'annulationGratuite': annulationGratuite,
      if (delaiAnnulation != null) 'delaiAnnulation': delaiAnnulation,
      if (fraisAnnulation != null) 'fraisAnnulation': fraisAnnulation,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EvenementImpl extends Evenement {
  _EvenementImpl({
    int? id,
    required String titre,
    String? description,
    String? type,
    int? cinemaId,
    String? lieu,
    String? ville,
    required DateTime dateDebut,
    DateTime? dateFin,
    String? affiche,
    String? bandeAnnonce,
    double? prix,
    int? placesDisponibles,
    int? placesTotales,
    String? organisateur,
    double? noteMoyenne,
    int? nombreAvis,
    String? statut,
    bool? annulationGratuite,
    int? delaiAnnulation,
    double? fraisAnnulation,
  }) : super._(
         id: id,
         titre: titre,
         description: description,
         type: type,
         cinemaId: cinemaId,
         lieu: lieu,
         ville: ville,
         dateDebut: dateDebut,
         dateFin: dateFin,
         affiche: affiche,
         bandeAnnonce: bandeAnnonce,
         prix: prix,
         placesDisponibles: placesDisponibles,
         placesTotales: placesTotales,
         organisateur: organisateur,
         noteMoyenne: noteMoyenne,
         nombreAvis: nombreAvis,
         statut: statut,
         annulationGratuite: annulationGratuite,
         delaiAnnulation: delaiAnnulation,
         fraisAnnulation: fraisAnnulation,
       );

  /// Returns a shallow copy of this [Evenement]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Evenement copyWith({
    Object? id = _Undefined,
    String? titre,
    Object? description = _Undefined,
    Object? type = _Undefined,
    Object? cinemaId = _Undefined,
    Object? lieu = _Undefined,
    Object? ville = _Undefined,
    DateTime? dateDebut,
    Object? dateFin = _Undefined,
    Object? affiche = _Undefined,
    Object? bandeAnnonce = _Undefined,
    Object? prix = _Undefined,
    Object? placesDisponibles = _Undefined,
    Object? placesTotales = _Undefined,
    Object? organisateur = _Undefined,
    Object? noteMoyenne = _Undefined,
    Object? nombreAvis = _Undefined,
    Object? statut = _Undefined,
    Object? annulationGratuite = _Undefined,
    Object? delaiAnnulation = _Undefined,
    Object? fraisAnnulation = _Undefined,
  }) {
    return Evenement(
      id: id is int? ? id : this.id,
      titre: titre ?? this.titre,
      description: description is String? ? description : this.description,
      type: type is String? ? type : this.type,
      cinemaId: cinemaId is int? ? cinemaId : this.cinemaId,
      lieu: lieu is String? ? lieu : this.lieu,
      ville: ville is String? ? ville : this.ville,
      dateDebut: dateDebut ?? this.dateDebut,
      dateFin: dateFin is DateTime? ? dateFin : this.dateFin,
      affiche: affiche is String? ? affiche : this.affiche,
      bandeAnnonce: bandeAnnonce is String? ? bandeAnnonce : this.bandeAnnonce,
      prix: prix is double? ? prix : this.prix,
      placesDisponibles: placesDisponibles is int?
          ? placesDisponibles
          : this.placesDisponibles,
      placesTotales: placesTotales is int? ? placesTotales : this.placesTotales,
      organisateur: organisateur is String? ? organisateur : this.organisateur,
      noteMoyenne: noteMoyenne is double? ? noteMoyenne : this.noteMoyenne,
      nombreAvis: nombreAvis is int? ? nombreAvis : this.nombreAvis,
      statut: statut is String? ? statut : this.statut,
      annulationGratuite: annulationGratuite is bool?
          ? annulationGratuite
          : this.annulationGratuite,
      delaiAnnulation: delaiAnnulation is int?
          ? delaiAnnulation
          : this.delaiAnnulation,
      fraisAnnulation: fraisAnnulation is double?
          ? fraisAnnulation
          : this.fraisAnnulation,
    );
  }
}
