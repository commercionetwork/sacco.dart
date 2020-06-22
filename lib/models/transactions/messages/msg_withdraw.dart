import 'package:meta/meta.dart';
import 'package:sacco/models/transactions/export.dart';

/// [MsgWithdrawDelegationReward] extends [StdMsg] and represents the message that should be
/// used when withdraw tokens.
class MsgWithdrawDelegationReward extends StdMsg {
  /// Bech32 address of the sender.
  final String delegator_address;

  /// Bech32 address of the recipient.
  final String validator_address;

  /// Coins that will be sent.
  final List<StdCoin> amount;

  /// Public constructor.
  MsgWithdrawDelegationReward({
    @required this.delegator_address,
    @required this.validator_address,
    @required this.amount,
  })  : assert(delegator_address != null),
        assert(validator_address != null),
        assert(amount != null),
        super(type: "cosmos-sdk/MsgWithdrawDelegationReward", value: Map());

  @override
  Map<String, dynamic> get value => {
        'delegator_address': this.delegator_address,
        'validator_address': this.validator_address,
        'amount': this.amount.map((coin) => coin.toJson()).toList(),
      };
}
