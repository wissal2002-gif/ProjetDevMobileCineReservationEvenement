import 'package:cine_reservation_client/cine_reservation_client.dart';

abstract class SupportRepository {
  Future<void> creerDemandeSupport(DemandeSupport demande);
  Future<List<DemandeSupport>> recupererMesDemandes();
}