import 'package:test/test.dart';

import 'package:sacco/models/export.dart';

void main() {
  test('MsgWithdrawDelegationReward is built correctly', () {
    final message = MsgWithdrawDelegationReward(
      delegator_address: "cosmos1c0qp24pq92xz5c96usknlxcmwls3pze95u50m9",
      validator_address: "cosmosvaloper1c0qp24pq92xz5c96usknlxcmwls3pze93gq6hk",
      amount: [StdCoin(denom: "umuon", amount: "1")],
    );

    expect(message.type, "cosmos-sdk/MsgWithdrawDelegationReward");
    expect(message.value, {
      "delegator_address": "cosmos1c0qp24pq92xz5c96usknlxcmwls3pze95u50m9",
      "validator_address":
          "cosmosvaloper1c0qp24pq92xz5c96usknlxcmwls3pze93gq6hk",
      "amount": [
        {"amount": "1", "denom": "umuon"}
      ]
    });
    expect(message.toJson(), {
      "type": "cosmos-sdk/MsgWithdrawDelegationReward",
      "value": {
        "delegator_address": "cosmos1c0qp24pq92xz5c96usknlxcmwls3pze95u50m9",
        "validator_address":
            "cosmosvaloper1c0qp24pq92xz5c96usknlxcmwls3pze93gq6hk",
        "amount": [
          {"amount": "1", "denom": "umuon"}
        ]
      }
    });
  });
}
