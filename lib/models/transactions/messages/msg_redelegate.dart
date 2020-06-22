import 'package:meta/meta.dart';
import 'package:sacco/models/transactions/export.dart';

/// [MsgBeginRedelegate] extends [StdMsg] and represents the message that should be
/// used when redelegating tokens.
class MsgBeginRedelegate extends StdMsg {
  /// Bech32 address of the sender.
  final String delegator_address;

  /// Bech32 address of the recipient.
  final String validator_src_address;

  final String validator_dst_address;

  /// Coins that will be sent.
  final List<StdCoin> amount;

  /// Public constructor.
  MsgBeginRedelegate({
    @required this.delegator_address,
    @required this.validator_src_address,
    @required this.validator_dst_address,
    @required this.amount,
  })  : assert(delegator_address != null),
        assert(validator_src_address != null),
        assert(validator_dst_address != null),
        assert(amount != null),
        super(type: "cosmos-sdk/MsgBeginRedelegate", value: Map());

  @override
  Map<String, dynamic> get value => {
        'delegator_address': this.delegator_address,
        'validator_src_address': this.validator_src_address,
        'validator_dst_address': this.validator_dst_address,
        'amount': this.amount.map((coin) => coin.toJson()).toList(),
      };
}
