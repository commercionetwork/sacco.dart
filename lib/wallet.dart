import 'dart:math';
import 'dart:typed_data';

import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;
import 'package:convert/convert.dart';
import 'package:equatable/equatable.dart';
import 'package:pointycastle/export.dart';
import 'package:pointycastle/src/utils.dart' as pc_utils;
import 'package:sacco/sacco.dart';
import 'package:sacco/utils/bech32_encoder.dart';

import 'utils/tx_signer.dart';

/// Represents a wallet which contains the hex private key, the hex public key
/// and the hex address.
/// In order to create one properly, the [Wallet.derive] method should always
/// be used.
/// The associated [networkInfo] will be used when computing the [bech32Address]
/// associated with the wallet.
class Wallet extends Equatable {
  static const BASE_DERIVATION_PATH = "m/44'/118'/0'/0";

  final Uint8List address;
  final Uint8List privateKey;
  final Uint8List publicKey;

  final NetworkInfo networkInfo;

  const Wallet({
    required this.networkInfo,
    required this.address,
    required this.privateKey,
    required this.publicKey,
  });

  @override
  List<Object> get props {
    return [networkInfo, address, privateKey, publicKey];
  }

  /// Derives the private key from the given [mnemonic]
  /// using the specified [networkInfo].
  /// Optionally can define a different derivation path
  /// setting [lastDerivationPathSegment].
  factory Wallet.derive(
    List<String> mnemonic,
    NetworkInfo networkInfo, {
    String lastDerivationPathSegment = '0',
  }) {
    // Get the mnemonic as a string
    final mnemonicString = mnemonic.join(' ');
    if (!bip39.validateMnemonic(mnemonicString)) {
      throw Exception('Invalid mnemonic ' + mnemonicString);
    }

    final _lastDerivationPathSegmentCheck =
        int.tryParse(lastDerivationPathSegment) ?? -1;
    if (_lastDerivationPathSegmentCheck < 0) {
      throw Exception('Invalid index format $lastDerivationPathSegment');
    }

    // Convert the mnemonic to a BIP32 instance
    final seed = bip39.mnemonicToSeed(mnemonicString);
    final root = bip32.BIP32.fromSeed(seed);

    // Get the node from the derivation path
    final derivedNode =
        root.derivePath('$BASE_DERIVATION_PATH/$lastDerivationPathSegment');

    // Get the curve data
    final secp256k1 = ECCurve_secp256k1();
    final point = secp256k1.G;

    // Compute the curve point associated to the private key
    final bigInt = BigInt.parse(hex.encode(derivedNode.privateKey), radix: 16);
    final curvePoint = point * bigInt;

    // Get the public key
    final publicKeyBytes = curvePoint.getEncoded();

    // Get the address
    final sha256Digest = SHA256Digest().process(publicKeyBytes);
    final address = RIPEMD160Digest().process(sha256Digest);

    // Return the key bytes
    return Wallet(
      address: address,
      publicKey: publicKeyBytes,
      privateKey: derivedNode.privateKey,
      networkInfo: networkInfo,
    );
  }

  /// Creates a new [Wallet] instance based on the existent [wallet] for
  /// the given [networkInfo].
  factory Wallet.convert(Wallet wallet, NetworkInfo networkInfo) {
    return Wallet(
      networkInfo: networkInfo,
      address: wallet.address,
      privateKey: wallet.privateKey,
      publicKey: wallet.publicKey,
    );
  }

  /// Returns the associated [address] as a Bech32 string.
  String get bech32Address =>
      Bech32Encoder.encode(networkInfo.bech32Hrp, address);

  /// Returns the associated [publicKey] as a Bech32 string
  String get bech32PublicKey {
    final type = [235, 90, 233, 135, 33]; // "addwnpep"
    final prefix = networkInfo.bech32Hrp + 'pub';
    final fullPublicKey = Uint8List.fromList(type + publicKey);
    return Bech32Encoder.encode(prefix, fullPublicKey);
  }

  /// Returns the associated [privateKey] as an [ECPrivateKey] instance.
  ECPrivateKey get _ecPrivateKey {
    final privateKeyInt = BigInt.parse(hex.encode(privateKey), radix: 16);
    return ECPrivateKey(privateKeyInt, ECCurve_secp256k1());
  }

  /// Returns the associated [publicKey] as an [ECPublicKey] instance.
  ECPublicKey get ecPublicKey {
    final secp256k1 = ECCurve_secp256k1();
    final point = secp256k1.G;
    final curvePoint = point * _ecPrivateKey.d;
    return ECPublicKey(curvePoint, ECCurve_secp256k1());
  }

  /// Signs the given [data] using the associated [privateKey] and encodes
  /// the signature bytes to be included inside a transaction.
  Uint8List signTxData(List<int> data) {
    final uint8List = Uint8List.fromList(data);
    final hash = SHA256Digest().process(uint8List);
    return TransactionSigner.deriveFrom(hash, _ecPrivateKey, ecPublicKey);
  }

  /// Generates a SecureRandom
  static SecureRandom _getSecureRandom() {
    final secureRandom = FortunaRandom();
    final random = Random.secure();
    final seed = List<int>.generate(32, (_) => random.nextInt(256));
    secureRandom.seed(KeyParameter(Uint8List.fromList(seed)));
    return secureRandom;
  }

  /// Canonicalizes [signature].
  /// This is necessary because if a message can be signed by (r, s), it can also be signed by (r, -s (mod N)).
  /// More details at
  /// https://github.com/web3j/web3j/blob/master/crypto/src/main/java/org/web3j/crypto/ECDSASignature.java#L27
  static ECSignature _toCanonicalised(ECSignature signature) {
    final ECDomainParameters _params = ECCurve_secp256k1();
    final _halfCurveOrder = _params.n >> 1;
    if (signature.s.compareTo(_halfCurveOrder) > 0) {
      final canonicalisedS = _params.n - signature.s;
      signature = ECSignature(signature.r, canonicalisedS);
    }
    return signature;
  }

  /// Signs the given [data] using the private key associated with this wallet,
  /// returning the signature bytes ASN.1 DER encoded.
  Uint8List sign(Uint8List data) {
    final ecdsaSigner = Signer('SHA-256/ECDSA')
      ..init(
          true,
          ParametersWithRandom(
            PrivateKeyParameter(_ecPrivateKey),
            _getSecureRandom(),
          ));
    final ecSignature =
        _toCanonicalised(ecdsaSigner.generateSignature(data) as ECSignature);
    final sigBytes = Uint8List.fromList(
      pc_utils.encodeBigInt(ecSignature.r) +
          pc_utils.encodeBigInt(ecSignature.s),
    );
    return sigBytes;
  }

  /// Creates a new [Wallet] instance from the given [json] and [privateKey].
  factory Wallet.fromJson(Map<String, dynamic> json, Uint8List privateKey) {
    final address =
        Uint8List.fromList(hex.decode(json['hex_address'] as String));
    final publicKey =
        Uint8List.fromList(hex.decode(json['public_key'] as String));
    return Wallet(
      address: address,
      publicKey: publicKey,
      privateKey: privateKey,
      networkInfo: NetworkInfo.fromJson(json['network_info']),
    );
  }

  /// Converts the current [Wallet] instance into a JSON object.
  /// Note that the private key is not serialized for safety reasons.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'hex_address': hex.encode(address),
        'bech32_address': bech32Address,
        'public_key': hex.encode(publicKey),
        'network_info': networkInfo.toJson(),
      };
}
