import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sacco/sacco.dart';

/// Allows to easily send a [StdTx] using the data contained inside the
/// specified [Wallet].
class TxSender {
  /// Broadcasts the given [stdTx] using the info contained
  /// inside the given [wallet].
  /// Returns the hash of the transaction once it has been send, or throws an
  /// exception if an error is risen during the sending.
  static Future<TransactionResult> broadcastStdTx({
    required Wallet wallet,
    required StdTx stdTx,
    String mode = 'sync',
    http.Client? client,
  }) async {
    client ??= http.Client();

    // Get the endpoint
    final apiUrl = Uri.parse('${wallet.networkInfo.lcdUrl}/txs');

    // Build the request body
    final requestBody = {'tx': stdTx.toJson(), 'mode': mode};
    final requestBodyJson = jsonEncode(requestBody);

    // Get the response
    final response = await client.post(apiUrl, body: requestBodyJson);
    if (response.statusCode != 200) {
      throw Exception(
        'Expected status code 200 but got ${response.statusCode} - ${response.body}',
      );
    }

    // Convert the response
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return _convertJson(json);
  }

  /// Converts the given [json] to a [TransactionResult] object.
  static TransactionResult _convertJson(Map<String, dynamic> json) {
    if (json['code'] != null) {
      final rawLogAsString = json['raw_log'].toString();
      var errorMessage = '';
      if (rawLogAsString.startsWith('{') &&
          rawLogAsString.contains('message')) {
        errorMessage = jsonDecode(rawLogAsString)['message'];
      } else {
        errorMessage = rawLogAsString;
      }

      return TransactionResult(
        hash: json['txhash'],
        success: false,
        error: TransactionError(
          errorCode: json['code'],
          errorMessage: errorMessage,
        ),
      );
    }

    return TransactionResult(hash: json['txhash'], success: true, error: null);
  }
}
