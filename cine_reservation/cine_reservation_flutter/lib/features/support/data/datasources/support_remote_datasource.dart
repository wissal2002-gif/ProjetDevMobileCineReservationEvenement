import 'package:cine_reservation_client/cine_reservation_client.dart';

class SupportRemoteDataSource {
  final Client client;
  SupportRemoteDataSource(this.client);

  Future<void> envoyerDemande(DemandeSupport demande) async {
    await client.support.creerDemande(demande.sujet, demande.message,demande.utilisateurId, demande.cinemaId,);
  }

  Future<List<DemandeSupport>> getMesDemandes() async {
    return await client.support.getDemandes();
  }
}