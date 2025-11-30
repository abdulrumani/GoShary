import '../../domain/usecases/get_home_data.dart'; // HomeDataEntity

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

// ✅ ڈیٹا کامیابی سے لوڈ ہو گیا
class HomeLoaded extends HomeState {
  final HomeDataEntity homeData;
  HomeLoaded({required this.homeData});
}

// ❌ کوئی ایرر آ گیا
class HomeError extends HomeState {
  final String message;
  HomeError({required this.message});
}