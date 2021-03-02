import 'package:meta/meta.dart';
import 'package:sacco/models/transactions/std_coin.dart';

class StdFee {
  final String gas;
  final List<StdCoin> amount;

  const StdFee({
    required this.amount,
    required this.gas,
  });

  Map<String, dynamic> toJson() => {
        'amount': this.amount.map((coin) => coin.toJson()).toList(),
        'gas': this.gas,
      };
}
