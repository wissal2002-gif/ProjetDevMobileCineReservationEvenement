import 'package:cine_reservation_client/cine_reservation_client.dart';
import '../../domain/repositories/support_repository.dart';
import '../datasources/support_remote_datasource.dart';

class SupportRepositoryImpl implements SupportRepository {
  final SupportRemoteDataSource remoteDataSource;
  SupportRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> creerDemandeSupport(DemandeSupport demande) {
    return remoteDataSource.envoyerDemande(demande);
  }

  @override
  Future<List<DemandeSupport>> recupererMesDemandes() {
    return remoteDataSource.getMesDemandes();
  }
}