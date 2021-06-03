import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sacco/sacco.dart';

/// Allows to easily retrieve the data of an account based on the information
/// contained inside a given [Wallet].
class AccountDataRetrieval {
  /// Reads the account endpoint and retrieves data from it.
  static Future<AccountData> getAccountData(
      Wallet wallet, {
        http.Client? client,
      }) async {
    client ??= http.Client();

    // Build the models.wallet api url
    final endpoint = Uri.parse(
        '${wallet.networkInfo.lcdUrl}/cosmos/auth/v1beta1/accounts/${wallet.bech32Address}');

    // Get the server response
    final response = await client.get(endpoint);
    if (response.statusCode != 200) {
      throw Exception(
        'Expected status code 200 but got ${response.statusCode} - ${response.body}',
      );
    }

    // Parse the data
    var json = jsonDecode(response.body) as Map<String, dynamic>;

    final value = json['account'] as Map<String, dynamic>;

    final accountNumber = value['account_number'] is String
        ? value['account_number']
        : value['account_number'].toString();

    final sequence = value['sequence'] is String
        ? value['sequence']
        : value['sequence'].toString();

    return AccountData(
      accountNumber: accountNumber,
      sequence: sequence,
    );
  }
}
