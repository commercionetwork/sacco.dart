import 'package:equatable/equatable.dart';

class NetworkInfo extends Equatable {
  /// Bech32 human readable part
  final String bech32Hrp;

  /// Url to call when accessing the LCD
  final Uri lcdUrl;

  // Optional fields
  /// Human readable chain name
  final String name;

  /// Chain icon url
  final String iconUrl;

  /// Default token denom
  final String? defaultTokenDenom;

  /// Contains the information of a generic Cosmos-based network.
  const NetworkInfo({
    required this.bech32Hrp,
    required this.lcdUrl,
    this.name = '',
    this.iconUrl = '',
    this.defaultTokenDenom,
  });

  @override
  List<Object?> get props =>
      [bech32Hrp, lcdUrl, name, iconUrl, defaultTokenDenom];

  factory NetworkInfo.fromJson(Map<String, dynamic> json) {
    return NetworkInfo(
      bech32Hrp: json['bech32_hrp'] as String,
      lcdUrl: Uri.parse(json['lcd_url'] as String),
      name: json['name'] as String,
      iconUrl: json['icon_url'] as String,
      defaultTokenDenom: json['default_token_denom'] as String,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'bech32_hrp': bech32Hrp,
        'lcd_url': lcdUrl.toString(),
        'name': name,
        'icon_url': iconUrl,
        'default_token_denom': defaultTokenDenom,
      };
}
