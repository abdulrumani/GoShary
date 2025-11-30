import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';

abstract class RewardsRemoteDataSource {
  Future<WalletDataModel> getWalletData();
  Future<PointsDataModel> getPointsData();
  Future<ReferralDataModel> getReferralData();
  Future<bool> dailyCheckIn();
}

class RewardsRemoteDataSourceImpl implements RewardsRemoteDataSource {
  final ApiClient apiClient;

  RewardsRemoteDataSourceImpl({required this.apiClient});

  /// 💰 1. والیٹ بیلنس اور ہسٹری
  @override
  Future<WalletDataModel> getWalletData() async {
    try {
      // TeraWallet Example Endpoint: 'wp-json/tera-wallet/v1/balance'
      // YITH Example: 'wp-json/yith/v1/funds'

      /* // Uncomment when API is ready:
      final response = await apiClient.get(
        'wp-json/tera-wallet/v1/balance',
        queryParameters: {'consumer_key': ..., 'consumer_secret': ...}
      );
      return WalletDataModel.fromJson(response.data);
      */

      // --- Mock Data (UI Testing) ---
      await Future.delayed(const Duration(seconds: 1));
      return WalletDataModel(
        balance: "125.00",
        currency: "\$",
        transactions: [
          WalletTransactionModel(id: 1, type: 'credit', amount: '50.00', date: '2023-10-20', details: 'Topup'),
          WalletTransactionModel(id: 2, type: 'debit', amount: '25.00', date: '2023-10-22', details: 'Order #1234 Payment'),
          WalletTransactionModel(id: 3, type: 'credit', amount: '100.00', date: '2023-10-25', details: 'Cashback Reward'),
        ],
      );
    } catch (e) {
      // Fallback mock data
      return WalletDataModel(balance: "0.00", currency: "\$", transactions: []);
    }
  }

  /// ⭐ 2. پوائنٹس ڈیٹا
  @override
  Future<PointsDataModel> getPointsData() async {
    try {
      // myCred Example Endpoint: 'wp-json/mycred/v1/balance'

      // --- Mock Data ---
      await Future.delayed(const Duration(seconds: 1));
      return PointsDataModel(
        balance: 2450,
        level: "Gold Member",
        history: [
          PointHistoryModel(id: 1, points: 50, date: '2023-10-20', description: 'Daily Check-in'),
          PointHistoryModel(id: 2, points: 200, date: '2023-10-21', description: 'Product Purchase'),
          PointHistoryModel(id: 3, points: -100, date: '2023-10-25', description: 'Redeemed for Coupon'),
        ],
      );
    } catch (e) {
      return PointsDataModel(balance: 0, level: "Bronze", history: []);
    }
  }

  /// 🔗 3. ریفرل ڈیٹا
  @override
  Future<ReferralDataModel> getReferralData() async {
    try {
      // AffiliateWP Example Endpoint: 'wp-json/affwp/v1/affiliates'

      // --- Mock Data ---
      await Future.delayed(const Duration(seconds: 1));
      return ReferralDataModel(
        referralCode: "SHOPLUXE-USER-29",
        referralLink: "https://shopluxe.com/?ref=29",
        totalEarnings: "50.00",
        totalReferrals: 12,
      );
    } catch (e) {
      return ReferralDataModel(referralCode: "", referralLink: "", totalEarnings: "0", totalReferrals: 0);
    }
  }

  /// ✅ 4. ڈیلی چیک ان (Daily Check-in)
  @override
  Future<bool> dailyCheckIn() async {
    try {
      // API Call to award points
      await Future.delayed(const Duration(seconds: 1));
      return true; // Success
    } catch (e) {
      return false;
    }
  }
}

// --- Models (Data Transfer Objects) ---
// (یہیں بنا رہے ہیں تاکہ فائلز کی تعداد کم رہے اور انتظام آسان ہو)

class WalletDataModel {
  final String balance;
  final String currency;
  final List<WalletTransactionModel> transactions;

  WalletDataModel({required this.balance, required this.currency, required this.transactions});
}

class WalletTransactionModel {
  final int id;
  final String type; // credit, debit
  final String amount;
  final String date;
  final String details;

  WalletTransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.details
  });
}

class PointsDataModel {
  final int balance;
  final String level;
  final List<PointHistoryModel> history;

  PointsDataModel({required this.balance, required this.level, required this.history});
}

class PointHistoryModel {
  final int id;
  final int points; // positive or negative
  final String date;
  final String description;

  PointHistoryModel({required this.id, required this.points, required this.date, required this.description});
}

class ReferralDataModel {
  final String referralCode;
  final String referralLink;
  final String totalEarnings;
  final int totalReferrals;

  ReferralDataModel({
    required this.referralCode,
    required this.referralLink,
    required this.totalEarnings,
    required this.totalReferrals
  });
}