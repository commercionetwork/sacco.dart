import 'dart:typed_data';

import 'package:pointycastle/api.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/ecc/api.dart';
import 'package:pointycastle/macs/hmac.dart';
import 'package:pointycastle/signers/ecdsa_signer.dart';
import 'package:sacco/utils/big_int_big_endian.dart';

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

    const bigIntEndian = BigIntBigEndian();
    final encR = bigIntEndian.encode(ecSignature.r);
    final encS = bigIntEndian.encode(ecSignature.s);

    // TODO: should we emit only fixed-length signatures?
    /*if (encR.length == 31 && encS.length == 31) {
      return ptutils.concatUint8List([
        encR,
        Uint8List.fromList([0, 0]),
        encS
      ]);
    }*/

    return _concatUint8List([encR, encS]);
  }

  static Uint8List _concatUint8List(Iterable<Uint8List> list) =>
      Uint8List.fromList(list.expand((element) => element).toList());
}
