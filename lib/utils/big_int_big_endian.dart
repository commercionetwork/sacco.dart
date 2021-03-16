import 'dart:typed_data';

class BigIntBigEndian {
  /// Helper class used internally to encode/decode BigInt values in Big-Endian
  /// because of the braking changes inside pointycastle.
  const BigIntBigEndian();

  /// Decode a BigInt from bytes in big-endian encoding.
  BigInt decode(List<int> bytes) {
    var result = BigInt.from(0);
    for (var i = 0; i < bytes.length; i++) {
      result += BigInt.from(bytes[bytes.length - i - 1]) << (8 * i);
    }
    return result;
  }

  /// Encode a BigInt into bytes using big-endian encoding.
  Uint8List encode(BigInt number) {
    final _byteMask = BigInt.from(0xff);
    // Not handling negative numbers. Decide how you want to do that.
    final size = (number.bitLength + 7) >> 3;
    final result = Uint8List(size);

    for (var i = 0; i < size; i++) {
      result[size - i - 1] = (number & _byteMask).toInt();
      number = number >> 8;
    }

    return result;
  }
}
