import 'dart:convert';
import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:logpass_crypto/logpass_crypto.dart';
import 'package:logpass_me/data/crypto/data_source/hive_seed_data_source.dart';
import 'package:logpass_me/data/crypto/data_source/logpass_crypto_data_source.dart';
import 'package:logpass_me/domain/crypto/crypto_repository.dart';

@LazySingleton(as: CryptoRepository)
class CryptoRepositoryMock implements CryptoRepository {
  final HiveSeedDataSource _hiveSeedDataSource;
  final LogpassCryptoDataSource _logpassCryptoDataSource;

  LogpassCrypto? _crypto;

  CryptoRepositoryMock(this._hiveSeedDataSource, this._logpassCryptoDataSource);

  @override
  Future<String> getPublicKeyAsBase64() async {
    final crypto = await _getCrypto();

    return base64Encode(crypto.publicKey);
  }

  @override
  Future<String> getVerifyKeyAsBase64() async {
    final crypto = await _getCrypto();
    return base64Encode(crypto.verifyKey);
  }

  Future<Uint8List> _getSeed() async {
    final savedSeed = await _hiveSeedDataSource.getSeed();
    if (savedSeed != null) return savedSeed;

    final newSeed = await _logpassCryptoDataSource.getSeed();
    await _hiveSeedDataSource.saveSeed(newSeed);

    return newSeed;
  }

  Future<LogpassCrypto> _getCrypto() async {
    if (_crypto != null) return _crypto!;

    final seed = await _getSeed();
    _crypto = await LogpassCrypto.create(seed);

    return _crypto!;
  }
}
