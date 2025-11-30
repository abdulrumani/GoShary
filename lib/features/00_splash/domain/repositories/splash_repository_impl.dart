import '../../domain/entities/splash_offer.dart';
import '../../domain/repositories/splash_repository.dart';
import '../../data/datasources/splash_remote_datasource.dart';

class SplashRepositoryImpl implements SplashRepository {
  final SplashRemoteDataSource remoteDataSource;

  SplashRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<SplashOffer>> getOffers() async {
    try {
      final offers = await remoteDataSource.fetchOffers();
      return offers;
    } catch (e) {
      // اگر کوئی ایرر آئے تو خالی لسٹ واپس کریں تاکہ ایپ کریش نہ ہو
      return [];
    }
  }
}