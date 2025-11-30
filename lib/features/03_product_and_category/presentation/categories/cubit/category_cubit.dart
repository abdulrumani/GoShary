import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_all_categories.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final GetAllCategories getAllCategories;

  CategoryCubit({required this.getAllCategories}) : super(CategoryInitial());

  Future<void> loadCategories() async {
    try {
      emit(CategoryLoading());

      // UseCase کو کال کریں
      final categories = await getAllCategories();

      emit(CategoryLoaded(categories: categories));
    } catch (e) {
      emit(CategoryError(message: e.toString()));
    }
  }
}