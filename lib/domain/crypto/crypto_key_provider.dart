import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/crypto/crypto_repository.dart';

@injectable
class CryptoKeyProvider {
  final CryptoRepository cryptoRepository;

  CryptoKeyProvider(this.cryptoRepository);

  Future<List<int>> getKey() async {
    final base64Key = await cryptoRepository.getPublicKeyAsBase64();
    return base64Url.decode(base64Key);
  }
}