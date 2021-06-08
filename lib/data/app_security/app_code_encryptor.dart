import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class AppCodeEncryptor {
  String encrypt(String code) {
    final input = utf8.encode(code);
    final encrypted = sha256.convert(input);
    return encrypted.toString();
  }
}
