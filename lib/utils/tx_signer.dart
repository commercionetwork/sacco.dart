import 'dart:typed_data';

import 'package:pointycastle/api.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/ecc/api.dart';
import 'package:pointycastle/ecc/curves/secp256k1.dart';
import 'package:pointycastle/macs/hmac.dart';
import 'package:pointycastle/signers/ecdsa_signer.dart';
import 'package:pointycastle/src/utils.dart' as ptutils;

/// Helper class used to sign a transaction.
class TransactionSigner {
  static Uint8List deriveFrom(
    Uint8List message,
    ECPrivateKey privateKey,
    ECPublicKey publicKey,
  ) {
    final ecdsaSigner = ECDSASigner(null, HMac(SHA256Digest(), 64));
    final normalizedECDSASigner = NormalizedECDSASigner(
      ecdsaSigner,
      enforceNormalized: true,
    );
    normalizedECDSASigner.init(true, PrivateKeyParameter(privateKey));

    final ecSignature =
        normalizedECDSASigner.generateSignature(message) as ECSignature;

    final encR = ptutils.encodeBigInt(ecSignature.r);
    final encS = ptutils.encodeBigInt(ecSignature.s);

    // TODO: should we emit only fixed-length signatures?
    /*if (encR.length == 31 && encS.length == 31) {
      return ptutils.concatUint8List([
        encR,
        Uint8List.fromList([0, 0]),
        encS
      ]);
    }*/

    return ptutils.concatUint8List([encR, encS]);
  }
}
