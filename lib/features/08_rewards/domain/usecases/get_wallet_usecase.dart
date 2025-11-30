import '../entities/reward_entities.dart';
import '../repositories/rewards_repository.dart';

class GetWalletData {
  final RewardsRepository repository;

  GetWalletData({required this.repository});

  Future<WalletData> call() async {
    return await repository.getWalletData();
  }
}