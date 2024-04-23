
import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {
  static encryptWithAESKey(String data) {
    encrypt.Key aesKey = encrypt.Key.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(aesKey));
    if (data.isNotEmpty) {
      encrypt.Encrypted encryptedData =
      encrypter.encrypt(data, iv: encrypt.IV.fromLength(16));
      return encryptedData.base64;
    } else if (data.isEmpty) {
      // Handle empty data case
      print('Data is empty');
    }
  }

  static  decryptWithAESKey(String data) {
    encrypt.Key aesKey = encrypt.Key.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(aesKey));
    if (data.isNotEmpty) {
      encrypt.Encrypted encrypted = encrypt.Encrypted.fromBase64(data);
      String decryptedData =
      encrypter.decrypt(encrypted, iv: encrypt.IV.fromLength(16));
      return decryptedData;
    } else if (data.isEmpty) {
      // Handle empty data case
      return '';
    }
  }
}
