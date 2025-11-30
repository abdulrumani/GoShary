import '../entities/reward_entities.dart';

abstract class RewardsRepository {
  Future<WalletData> getWalletData();
  Future<PointsData> getPointsData();
  Future<ReferralData> getReferralData();
  Future<bool> dailyCheckIn();
}