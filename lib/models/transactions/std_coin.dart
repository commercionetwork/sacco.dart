/// Contains the data of a specific coin
class StdCoin {
  final String denom;
  final String amount;

  const StdCoin({required this.denom, required this.amount});

  factory StdCoin.fromJson(Map<String, dynamic> json) => StdCoin(
        denom: json['denom'] as String,
        amount: json['amount'] as String,
      );

  Map<String, dynamic> toJson() => {
        'denom': denom,
        'amount': amount,
      };
}
