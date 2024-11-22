import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:cryptography/cryptography.dart' as crypto_graphy;

class EncryptDecrypt {
  static String key = "Criteriontech@786"; // Default Encryption key
  static String _salt = "Criteriontech@786"; // Default Encryption Salt

  // Encrypt a string using AES
  static Future<String> encryptString(String plainText, String password) async {
    // Generate random salt and IV
    final salt = _generateRandomBytes(16); // 16 bytes salt
    final iv = _generateRandomBytes(16);   // 16 bytes IV

    // Derive a 256-bit key using PBKDF2 with SHA256
    final key = await _generateKey(password, salt: salt);

    // Perform AES encryption with CBC mode and PKCS7 padding
    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
    );

    final encrypted = encrypter.encrypt(plainText, iv: encrypt.IV(iv));

    // Combine salt, IV, and encrypted data
    final combined = Uint8List.fromList([...salt, ...iv, ...encrypted.bytes]);

    // Encode to Base64
    return base64Encode(combined);
  }

  // Decrypt a string using AES
  static Future<String> decryptString(String encryptedText, String password) async {
    final combined = base64Decode(encryptedText);

    final salt = combined.sublist(0, 16);
    final iv = combined.sublist(16, 32);
    final encryptedData = combined.sublist(32);

    final key = await _generateKey(password, salt: salt);
    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
    );

    final decrypted = encrypter.decryptBytes(
      encrypt.Encrypted(encryptedData),
      iv: encrypt.IV(iv),
    );

    return utf8.decode(decrypted);
  }

  // Generate random bytes for Salt and IV
  static Uint8List _generateRandomBytes(int length) {
    final random = Random.secure();
    return Uint8List.fromList(List.generate(length, (_) => random.nextInt(256)));
  }

  // Generate a PBKDF2 key
  static Future<encrypt.Key> _generateKey(String password, {required Uint8List salt}) async {
    // Use Pbkdf2 from the cryptography package
    final pbkdf2 = crypto_graphy.Pbkdf2(
      macAlgorithm: crypto_graphy.Hmac.sha256(),
      iterations: 10000,
      bits: 256,
    );

    // Derive the key using PBKDF2
    final secretKey = await pbkdf2.deriveKey(
      secretKey: crypto_graphy.SecretKey(utf8.encode(password)),
      nonce: salt,
    );

    // Extract raw bytes from the derived key
    final keyBytes = await secretKey.extractBytes();
    return encrypt.Key(Uint8List.fromList(keyBytes));
  }

  // Generate a salt (16 bytes)
  static Uint8List _generateSalt() {
    return _generateRandomBytes(16);
  }
}
