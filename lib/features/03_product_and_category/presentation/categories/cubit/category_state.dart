import '../../../domain/entities/category.dart';

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

// ✅ جب کیٹیگریز کامیابی سے لوڈ ہو جائیں
class CategoryLoaded extends CategoryState {
  final List<Category> categories;
  CategoryLoaded({required this.categories});
}

// ❌ ایرر کی صورت میں
class CategoryError extends CategoryState {
  final String message;
  CategoryError({required this.message});
}