import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_home_data.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetHomeData getHomeData;

  HomeCubit({required this.getHomeData}) : super(HomeInitial());

  Future<void> loadHomeData() async {
    try {
      emit(HomeLoading());

      // UseCase کو کال کریں جو سارا ڈیٹا ایک ساتھ لائے گا
      final homeData = await getHomeData();

      emit(HomeLoaded(homeData: homeData));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }
}