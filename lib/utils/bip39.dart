import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:pointycastle/export.dart';

import 'bip39_wordlist.dart';

class Bip39 {
  static const int _SIZE_BYTE = 255;

  static bool validateMnemonic(String mnemonic) {
    try {
      mnemonicToEntropy(mnemonic);
    } catch (e) {
      return false;
    }
    return true;
  }

  static Uint8List _randomBytes(int size) {
    final rng = Random.secure();
    final bytes = Uint8List(size);

    for (var i = 0; i < size; i++) {
      bytes[i] = rng.nextInt(_SIZE_BYTE);
    }

    return bytes;
  }

  static String generateMnemonic({int strength = 128}) {
    assert(strength % 32 == 0);

    final entropy = _randomBytes(strength ~/ 8);
    return entropyToMnemonic(hex.encode(entropy));
  }

  static String entropyToMnemonic(String entropyString) {
    final entropy = Uint8List.fromList(hex.decode(entropyString));

    if (entropy.length < 16) {
      throw ArgumentError('Invalid entropy');
    }

    if (entropy.length > 32) {
      throw ArgumentError('Invalid entropy');
    }

    if (entropy.length % 4 != 0) {
      throw ArgumentError('Invalid entropy');
    }

    final entropyBits = _bytesToBinary(entropy);
    final checksumBits = _deriveChecksumBits(entropy);
    final bits = entropyBits + checksumBits;
    final regex = RegExp('.{1,11}', caseSensitive: false, multiLine: false);

    final chunks = regex
        .allMatches(bits)
        .map((match) => match.group(0)!)
        .toList(growable: false);

    final words = chunks
        .map((binary) => bip39_english_wordlist[_binaryToByte(binary)])
        .join(' ');

    return words;
  }

  /// Reference: https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki#from-mnemonic-to-seed
  static Uint8List mnemonicToSeed(String mnemonic, {int entropy = 128}) {
    if (entropy != 128 && entropy != 256) {
      throw ArgumentError.value(entropy, 'The entropy should be 128 or 256.');
    }

    final salt = Uint8List.fromList(utf8.encode('mnemonic'));

    final keyDerivator = PBKDF2KeyDerivator(HMac(SHA512Digest(), entropy));
    keyDerivator.init(Pbkdf2Parameters(salt, 2048, 64));

    return keyDerivator.process(Uint8List.fromList(utf8.encode(mnemonic)));
  }

  static String mnemonicToEntropy(String mnemonic) {
    final words = mnemonic.split(' ');

    if (words.length % 3 != 0) {
      throw ArgumentError(
          'The mnemonic must have a number of words that is a multple of 3');
    }

    // convert word indices to 11 bit binary strings
    final bits = words.map((word) {
      final index = bip39_english_wordlist.indexOf(word);

      if (index == -1) {
        throw ArgumentError(
          'The word $word is not contained in the bip39 english dictionary',
        );
      }

      return index.toRadixString(2).padLeft(11, '0');
    }).join('');

    // split the binary string into ENT/CS
    final dividerIndex = (bits.length / 33).floor() * 32;
    final entropyBits = bits.substring(0, dividerIndex);
    final checksumBits = bits.substring(dividerIndex);

    // calculate the checksum and compare
    final regex = RegExp('.{1,8}');
    final entropyBytes = Uint8List.fromList(regex
        .allMatches(entropyBits)
        .map((match) => _binaryToByte(match.group(0)!))
        .toList(growable: false));

    if (entropyBytes.length < 16) {
      throw StateError('Invalid entropy: the bytes must be at least 16');
    }

    if (entropyBytes.length > 32) {
      throw StateError('Invalid entropy: the bytes must be under 32');
    }

    if (entropyBytes.length % 4 != 0) {
      throw StateError('Invalid entropy: the bytes should be a multiple of 4');
    }

    final newChecksum = _deriveChecksumBits(entropyBytes);

    if (newChecksum != checksumBits) {
      throw StateError('Invalid checksum');
    }

    return entropyBytes.map((byte) {
      return byte.toRadixString(16).padLeft(2, '0');
    }).join('');
  }

  static int _binaryToByte(String binary) {
    return int.parse(binary, radix: 2);
  }

  static String _bytesToBinary(Uint8List bytes) {
    return bytes.map((byte) => byte.toRadixString(2).padLeft(8, '0')).join('');
  }

  static String _deriveChecksumBits(Uint8List entropy) {
    final ENT = entropy.length * 8;
    final CS = ENT ~/ 32;
    final sha256 = SHA256Digest();
    final hash = sha256.process(entropy);

    return _bytesToBinary(hash).substring(0, CS);
  }
}
