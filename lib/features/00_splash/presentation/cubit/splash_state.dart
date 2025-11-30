import '../../domain/entities/splash_offer.dart';

abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashLoaded extends SplashState {
  final List<SplashOffer> offers;
  SplashLoaded({required this.offers});
}

class SplashError extends SplashState {
  final String message;
  SplashError({required this.message});
}