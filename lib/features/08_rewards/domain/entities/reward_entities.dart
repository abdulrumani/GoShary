// --- Wallet ---
class WalletData {
  final String balance;
  final String currency;
  final List<WalletTransaction> transactions;

  WalletData({required this.balance, required this.currency, required this.transactions});
}

class WalletTransaction {
  final int id;
  final String type; // credit, debit
  final String amount;
  final String date;
  final String details;

  WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.details
  });
}

// --- Points ---
class PointsData {
  final int balance;
  final String level;
  final List<PointHistory> history;

  PointsData({required this.balance, required this.level, required this.history});
}

class PointHistory {
  final int id;
  final int points;
  final String date;
  final String description;

  PointHistory({required this.id, required this.points, required this.date, required this.description});
}

// --- Referral ---
class ReferralData {
  final String referralCode;
  final String referralLink;
  final String totalEarnings;
  final int totalReferrals;

  ReferralData({
    required this.referralCode,
    required this.referralLink,
    required this.totalEarnings,
    required this.totalReferrals
  });
}