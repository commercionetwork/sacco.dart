class StdSignatureMessage {
  final String chainId;
  final String accountNumber;
  final String sequence;
  final String memo;
  final Map<String, dynamic> fee;
  final List<Map<String, dynamic>> msgs;

  const StdSignatureMessage({
    required this.chainId,
    required this.accountNumber,
    required this.sequence,
    required this.memo,
    required this.fee,
    required this.msgs,
  });

  Map<String, dynamic> toJson() => {
        'chain_id': chainId,
        'account_number': accountNumber,
        'sequence': sequence,
        'memo': memo,
        'fee': fee,
        'msgs': msgs,
      };
}
