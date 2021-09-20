import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/crypto/crypto_repository.dart';

@module
abstract class CryptoModule {
  @injectable
  @Named('encryption_key')
  Future<List<int>> getCryptoKey(CryptoRepository cryptoRepository) async {
    final base64Key = await cryptoRepository.getPublicKeyAsBase64();
    return base64Url.decode(base64Key);
  }

  @injectable
  HiveAesCipher dashboardsBox(@Named('encryption_key') List<int> key) {
    return HiveAesCipher(key);
  }
}
