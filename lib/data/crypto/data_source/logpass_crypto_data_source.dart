import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:logpass_crypto/logpass_crypto.dart';
import 'package:logpass_me/data/crypto/data_source/seed_data_ource.dart';

@Singleton()
class LogpassCryptoDataSource implements SeedDataSource {
  @override
  Future<Uint8List> getSeed() async {
      return LogpassCrypto.generateSeed();
  }
}
