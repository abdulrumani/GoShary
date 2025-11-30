import '../../data/datasources/rewards_datasource.dart';
import '../../domain/entities/reward_entities.dart';
import '../../domain/repositories/rewards_repository.dart';

class RewardsRepositoryImpl implements RewardsRepository {
  final RewardsRemoteDataSource remoteDataSource;

  RewardsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<WalletData> getWalletData() async {
    try {
      final model = await remoteDataSource.getWalletData();
      // Model -> Entity Conversion
      return WalletData(
        balance: model.balance,
        currency: model.currency,
        transactions: model.transactions.map((t) => WalletTransaction(
          id: t.id,
          type: t.type,
          amount: t.amount,
          date: t.date,
          details: t.details,
        )).toList(),
      );
    } catch (e) {
      return WalletData(balance: "0.00", currency: "\$", transactions: []);
    }
  }

  @override
  Future<PointsData> getPointsData() async {
    try {
      final model = await remoteDataSource.getPointsData();
      return PointsData(
        balance: model.balance,
        level: model.level,
        history: model.history.map((h) => PointHistory(
          id: h.id,
          points: h.points,
          date: h.date,
          description: h.description,
        )).toList(),
      );
    } catch (e) {
      return PointsData(balance: 0, level: "", history: []);
    }
  }

  @override
  Future<ReferralData> getReferralData() async {
    try {
      final model = await remoteDataSource.getReferralData();
      return ReferralData(
        referralCode: model.referralCode,
        referralLink: model.referralLink,
        totalEarnings: model.totalEarnings,
        totalReferrals: model.totalReferrals,
      );
    } catch (e) {
      return ReferralData(referralCode: "", referralLink: "", totalEarnings: "0", totalReferrals: 0);
    }
  }

  @override
  Future<bool> dailyCheckIn() async {
    return await remoteDataSource.dailyCheckIn();
  }
}