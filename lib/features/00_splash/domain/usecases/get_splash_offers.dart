import '../entities/splash_offer.dart';
import '../repositories/splash_repository.dart';

class GetSplashOffers {
  final SplashRepository repository;

  GetSplashOffers({required this.repository});

  Future<List<SplashOffer>> call() async {
    return await repository.getOffers();
  }
}