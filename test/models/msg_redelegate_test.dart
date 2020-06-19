import 'package:sacco/models/transactions/messages/msg_redelegate.dart';
import 'package:test/test.dart';

import 'package:sacco/models/export.dart';

void main() {
  test('MsgBeginRedelegate is built correctly', () {
    final message = MsgBeginRedelegate(
      delegator_address: "cosmos1c0qp24pq92xz5c96usknlxcmwls3pze95u50m9",
      validator_src_address:
          "cosmosvaloper1c0qp24pq92xz5c96usknlxcmwls3pze93gq6hk",
      validator_dst_address:
          "cosmosvaloper185n9jln2g4w79w39m0g85x2tns6uekqg8hrx3j",
      amount: [StdCoin(denom: "umuon", amount: "1")],
    );

    expect(message.type, "cosmos-sdk/MsgBeginRedelegate");
    expect(message.value, {
      "delegator_address": "cosmos1c0qp24pq92xz5c96usknlxcmwls3pze95u50m9",
      "validator_src_address":
          "cosmosvaloper1c0qp24pq92xz5c96usknlxcmwls3pze93gq6hk",
      "validator_dst_address":
          "cosmosvaloper185n9jln2g4w79w39m0g85x2tns6uekqg8hrx3j",
      "amount": [
        {"amount": "1", "denom": "umuon"}
      ]
    });
    expect(message.toJson(), {
      "type": "cosmos-sdk/MsgBeginRedelegate",
      "value": {
        "delegator_address": "cosmos1c0qp24pq92xz5c96usknlxcmwls3pze95u50m9",
        "validator_src_address":
            "cosmosvaloper1c0qp24pq92xz5c96usknlxcmwls3pze93gq6hk",
        "validator_dst_address":
            "cosmosvaloper185n9jln2g4w79w39m0g85x2tns6uekqg8hrx3j",
        "amount": [
          {"amount": "1", "denom": "umuon"}
        ]
      }
    });
  });
}
