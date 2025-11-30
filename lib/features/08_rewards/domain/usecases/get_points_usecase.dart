import '../entities/reward_entities.dart';
import '../repositories/rewards_repository.dart';

class GetPointsData {
  final RewardsRepository repository;

  GetPointsData({required this.repository});

  Future<PointsData> call() async {
    return await repository.getPointsData();
  }
}