import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class QRUtils {
  static String generateCode(String userName, String entryType) {
    String characters =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';

    generateRandomString() {
      final random = Random();
      StringBuffer buffer = StringBuffer();
      for (var i = 0; i < 5; i++) {
        buffer.write(characters[random.nextInt(characters.length)]);
      }
      return buffer.toString();
    }

    String uniqueString =
        '$userName|$entryType|${DateTime.now().millisecondsSinceEpoch}';
    List<int> bytes = utf8.encode(uniqueString);
    Digest digest = sha256.convert(bytes);
    String initials = userName.substring(0, 2).toUpperCase();
    String entryCode = '';
    if (entryType == 'VIP') {
      entryCode = '1';
    } else if (entryType == 'Member') {
      entryCode = '2';
    } else if (entryType == 'Guest') {
      entryCode = '3';
    }

    final generateCode = generateRandomString() +
        digest.toString().substring(0, 8).toUpperCase() +
        entryCode +
        initials;

    return generateCode;
  }
}
