import 'package:pointycastle/ecc/api.dart';
import 'package:pointycastle/ecc/ecc_base.dart';
import 'package:pointycastle/src/ec_standard_curve_constructor.dart';
import 'package:pointycastle/src/registry/registry.dart';

class ECCSecp256k1 extends ECDomainParametersImpl {
  static final FactoryConfig factoryConfig = StaticFactoryConfig(
    ECDomainParameters,
    'secp256k1',
    () => ECCSecp256k1(),
  );

  /// Custom re-implementation of pointcastle one because of non-null seed bug.
  factory ECCSecp256k1() => constructFpStandardCurve(
      'secp256k1', ECCSecp256k1._make,
      q: BigInt.parse(
          'fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f',
          radix: 16),
      a: BigInt.parse('0', radix: 16),
      b: BigInt.parse('7', radix: 16),
      g: BigInt.parse(
          '0479be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8',
          radix: 16),
      n: BigInt.parse(
          'fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141',
          radix: 16),
      h: BigInt.parse('1', radix: 16),
      seed: null) as ECCSecp256k1;

  static ECCSecp256k1 _make(String domainName, ECCurve curve, ECPoint G,
          BigInt n, BigInt _h, List<int>? seed) =>
      ECCSecp256k1._super(domainName, curve, G, n, _h, seed);

  ECCSecp256k1._super(String domainName, ECCurve curve, ECPoint G, BigInt n,
      BigInt _h, List<int>? seed)
      : super(domainName, curve, G, n, _h, seed);
}
