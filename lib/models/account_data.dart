import 'package:equatable/equatable.dart';
import 'package:sacco/models/transactions/export.dart';

class AccountData extends Equatable {
  final String accountNumber;
  final String sequence;
  final List<StdCoin> coins;

  const AccountData({
    required this.accountNumber,
    required this.sequence,
    required this.coins,
  });

  @override
  String toString() {
    return 'number: $accountNumber, sequence: $sequence, coins: $coins';
  }

  @override
  List<Object?> get props => [accountNumber, sequence, coins];
}
