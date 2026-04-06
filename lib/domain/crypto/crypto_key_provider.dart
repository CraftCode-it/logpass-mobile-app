import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/crypto/data_source/hive_seed_data_source.dart';
import 'package:logpass_me/domain/crypto/crypto_repository.dart';

@injectable
class CryptoKeyProvider {
  final CryptoRepository cryptoRepository;
  final HiveSeedDataSource _seedDataSource;

  CryptoKeyProvider(this.cryptoRepository, this._seedDataSource);

  Future<List<int>> getKey() async {
    final seed = await _seedDataSource.getSeed();
    if (seed != null && seed.isNotEmpty) {
      final hmac = Hmac(sha256, utf8.encode('logpass-hive-key'));
      return hmac.convert(seed).bytes;
    }
    // Fallback dla instalacji bez seed (backward compat -- usunac po pelnej migracji A-4)
    final base64Key = await cryptoRepository.getPublicKeyAsBase64();
    return base64Url.decode(base64Key);
  }
}