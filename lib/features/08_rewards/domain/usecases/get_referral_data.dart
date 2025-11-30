import '../entities/reward_entities.dart';
import '../repositories/rewards_repository.dart';

class GetReferralData {
  final RewardsRepository repository;

  GetReferralData({required this.repository});

  Future<ReferralData> call() async {
    return await repository.getReferralData();
  }
}