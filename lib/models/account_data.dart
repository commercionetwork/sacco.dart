import 'package:equatable/equatable.dart';
import 'package:sacco/models/transactions/export.dart';

class AccountData extends Equatable {
  final String accountNumber;
  final String sequence;

  const AccountData({
    required this.accountNumber,
    required this.sequence,
  });

  @override
  String toString() {
    return 'number: $accountNumber, sequence: $sequence';
  }

  @override
  List<Object?> get props => [accountNumber, sequence];
}
