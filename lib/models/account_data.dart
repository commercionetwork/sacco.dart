import 'package:sacco/models/transactions/export.dart';

class AccountData {
  final String accountNumber;
  final String sequence;
  final List<StdCoin> coins;

  AccountData({
    required this.accountNumber,
    required this.sequence,
    required this.coins,
  });

  @override
  String toString() {
    return "number: $accountNumber, sequence: $sequence, coins: $coins";
  }
}
