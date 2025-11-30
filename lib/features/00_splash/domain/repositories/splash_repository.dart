import '../entities/splash_offer.dart';

abstract class SplashRepository {
  Future<List<SplashOffer>> getOffers();
}