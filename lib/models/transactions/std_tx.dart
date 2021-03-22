import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sacco/models/transactions/export.dart';

class StdTx extends Equatable {
  final List<StdMsg> messages;
  final List<StdSignature>? signatures;
  final StdFee fee;
  final String memo;

  const StdTx({
    required this.messages,
    required this.fee,
    required this.memo,
    this.signatures,
  });

  Map<String, dynamic> toJson() => {
        'msg': messages.map((message) => message.toJson()).toList(),
        'fee': fee.toJson(),
        'signatures':
            signatures?.map((signature) => signature.toJson()).toList(),
        'memo': memo,
      };

  @override
  String toString() {
    final tx = {'type': 'cosmos-sdk/StdTx', 'value': toJson()};
    return jsonEncode(tx);
  }

  @override
  List<Object?> get props => [messages, signatures, fee, memo];
}
