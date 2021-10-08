import 'dart:convert';
import 'dart:typed_data';
import 'package:logpass_crypto/logpass_crypto.dart';
import 'package:test/test.dart';

void main() {
  group('Generation', () {
    test('Generate seed', () async {
      final seed1 = LogpassCrypto.generateSeed();
      final seed2 = LogpassCrypto.generateSeed();
      expect(seed1.length, equals(LogpassCrypto.seedLength));
      expect(seed2.length, equals(LogpassCrypto.seedLength));
      expect(seed1, isNot(equals(seed2)));
    });

    test('Generate', () async {
      final seed = LogpassCrypto.generateSeed();
      final crypto1 = await LogpassCrypto.create(seed);
      final crypto2 = await LogpassCrypto.create(seed);
      expect(crypto1.publicKey.length, equals(32));
      expect(crypto1.verifyKey.length, equals(32));
      expect(crypto1.publicKey, equals(crypto2.publicKey));
      expect(crypto1.verifyKey, equals(crypto2.verifyKey));
    });

    test('Generate different', () async {
      final crypto1 = await LogpassCrypto.create(LogpassCrypto.generateSeed());
      final crypto2 = await LogpassCrypto.create(LogpassCrypto.generateSeed());
      expect(crypto1.publicKey, isNot(equals(crypto2.publicKey)));
      expect(crypto1.verifyKey, isNot(equals(crypto2.verifyKey)));
    });

    test('Invalid seed', () async {
      expect(() async => await LogpassCrypto.create(Uint8List(0)),
          throwsA((e) => e is LogpassCryptoException));
    });
  });

  group('Encryption and decryption', () {
    late LogpassCrypto crypto;
    final testMessage = "Test 123";
    final encodedTestMessage = Uint8List.fromList(utf8.encode(testMessage));

    setUp(() async {
      crypto = await LogpassCrypto.create(LogpassCrypto.generateSeed());
    });

    test('empty', () async {
      final encryptedMessage = await crypto.encrypt(Uint8List(0));
      expect(encryptedMessage.length, equals(122));
      final decryptedMessage = await crypto.decrypt(encryptedMessage);
      expect(decryptedMessage, equals(Uint8List(0)));
    });

    test('simple', () async {
      final encryptedMessage = await crypto.encrypt(encodedTestMessage);
      expect(encryptedMessage.length, equals(130));
      final decryptedMessage = await crypto.decrypt(encryptedMessage);
      expect(decryptedMessage, equals(encodedTestMessage));
      final decryptedMessageStr = utf8.decode(decryptedMessage);
      expect(decryptedMessageStr, equals(testMessage));
    });

    test('random data', () async {
      final randomData = LogpassCrypto.generateSeed();
      final encryptedMessage = await crypto.encrypt(randomData);
      final decryptedMessage = await crypto.decrypt(encryptedMessage);
      expect(decryptedMessage, equals(randomData));
    });

    test('big data', () async {
      final bigData = Uint8List(1024 * 1024);
      bigData[bigData.length - 1] = 1;
      final encryptedMessage = await crypto.encrypt(bigData);
      final decryptedMessage = await crypto.decrypt(encryptedMessage);
      expect(decryptedMessage, equals(bigData));
    });

    test('corrupted data', () async {
      var encryptedMessage = await crypto.encrypt(encodedTestMessage);
      encryptedMessage[encryptedMessage.length - 1] += 1;
      expect(() async => await crypto.decrypt(encryptedMessage),
          throwsA((e) => e is LogpassCryptoException));
    });

    test('invalid data', () async {
      expect(() async => await crypto.decrypt(Uint8List(200)),
          throwsA((e) => e is LogpassCryptoException));
    });

    test('invalid data #2', () async {
      var data = Uint8List(200);
      data[0] = LogpassCrypto.version;
      expect(() async => await crypto.decrypt(data),
          throwsA((e) => e is LogpassCryptoException));
    });

    test('wrong recipient', () async {
      final encryptedMessage = await crypto.encrypt(encodedTestMessage);
      final crypto2 = await LogpassCrypto.create(LogpassCrypto.generateSeed());
      expect(() async => await crypto2.decrypt(encryptedMessage),
          throwsA((e) => e is LogpassCryptoException));
    });

    test('invalid recipient', () async {
      expect(
          () async => await crypto
              .encrypt(encodedTestMessage, recipients: {Uint8List(50)}),
          throwsA((e) => e is LogpassCryptoException));
    });

    test('two recipients', () async {
      final crypto2 = await LogpassCrypto.create(LogpassCrypto.generateSeed());
      final encryptedMessage = await crypto
          .encrypt(encodedTestMessage, recipients: {crypto2.publicKey});
      expect(encryptedMessage.length,
          equals(130 + LogpassCrypto.encryptedSecretSize));
      final decryptedMessage1 = await crypto.decrypt(encryptedMessage);
      expect(decryptedMessage1, equals(encodedTestMessage));
      final decryptedMessage2 = await crypto2.decrypt(encryptedMessage);
      expect(decryptedMessage2, equals(encodedTestMessage));
    });

    test('max recipients', () async {
      List<LogpassCrypto> cryptos = [];
      for (int i = 0; i < LogpassCrypto.maxRecipients; ++i) {
        cryptos.add(await LogpassCrypto.create(LogpassCrypto.generateSeed()));
      }
      Set<Uint8List> publicKeys = {};
      for (final crypto in cryptos) {
        publicKeys.add(crypto.publicKey);
      }
      final encryptedMessage =
          await crypto.encrypt(encodedTestMessage, recipients: publicKeys);
      expect(encryptedMessage.length,
          equals(130 + cryptos.length * LogpassCrypto.encryptedSecretSize));
      for (final crypto in cryptos) {
        final decryptedMessage = await crypto.decrypt(encryptedMessage);
        expect(decryptedMessage, equals(encodedTestMessage));
      }
      final decryptedMessage = await crypto.decrypt(encryptedMessage);
      expect(decryptedMessage, equals(encodedTestMessage));
    });

    test('too many recipients', () async {
      List<LogpassCrypto> cryptos = [];
      for (int i = 0; i < LogpassCrypto.maxRecipients + 1; ++i) {
        cryptos.add(await LogpassCrypto.create(LogpassCrypto.generateSeed()));
      }
      Set<Uint8List> publicKeys = {};
      for (final crypto in cryptos) {
        publicKeys.add(crypto.publicKey);
      }
      expect(
          () async =>
              await crypto.encrypt(encodedTestMessage, recipients: publicKeys),
          throwsA((e) => e is LogpassCryptoException));
    });
  });

  group('Signatures', () {
    late LogpassCrypto crypto;
    final testMessage = "Test 123";
    final encodedTestMessage = Uint8List.fromList(utf8.encode(testMessage));

    setUp(() async {
      crypto = await LogpassCrypto.create(LogpassCrypto.generateSeed());
    });

    test('logpass token', () async {
      final signature = await crypto.signLogpassToken(encodedTestMessage);
      final isValid = await LogpassCrypto.verifyLogpassTokenSignature(
          encodedTestMessage, signature, crypto.verifyKey);
      final crypto2 = await LogpassCrypto.create(LogpassCrypto.generateSeed());
      final isValid2 = await LogpassCrypto.verifyLogpassTokenSignature(
          encodedTestMessage, signature, crypto2.verifyKey);
      final isValid3 = await LogpassCrypto.verifyBlockchainTransactionSignature(
          encodedTestMessage, signature, crypto.verifyKey);
      expect(signature.length, equals(64));
      expect(isValid, true);
      expect(isValid2, false);
      expect(isValid3, false);
    });

    test('blockchain transaction', () async {
      final signature =
          await crypto.signBlockchainTransaction(encodedTestMessage);
      final isValid = await LogpassCrypto.verifyBlockchainTransactionSignature(
          encodedTestMessage, signature, crypto.verifyKey);
      final crypto2 = await LogpassCrypto.create(LogpassCrypto.generateSeed());
      final isValid2 = await LogpassCrypto.verifyBlockchainTransactionSignature(
          encodedTestMessage, signature, crypto2.verifyKey);
      final isValid3 = await LogpassCrypto.verifyLogpassTokenSignature(
          encodedTestMessage, signature, crypto.verifyKey);
      expect(signature.length, equals(64));
      expect(isValid, true);
      expect(isValid2, false);
      expect(isValid3, false);
    });

    test('invalid logpass token signature', () async {
      final invalidSignature = Uint8List(50);
      expect(
          () async => await LogpassCrypto.verifyLogpassTokenSignature(
              encodedTestMessage, invalidSignature, crypto.verifyKey),
          throwsA((e) => e is LogpassCryptoException));
    });

    test('invalid logpass token public key', () async {
      final invalidPublicKey = Uint8List(50);
      expect(
          () async => await LogpassCrypto.verifyLogpassTokenSignature(
              encodedTestMessage, Uint8List(64), invalidPublicKey),
          throwsA((e) => e is LogpassCryptoException));
    });

    test('invalid blockchain transaction signature', () async {
      final invalidSignature = Uint8List(50);
      expect(
          () async => await LogpassCrypto.verifyBlockchainTransactionSignature(
              encodedTestMessage, invalidSignature, crypto.verifyKey),
          throwsA((e) => e is LogpassCryptoException));
    });

    test('invalid blockchain transaction public key', () async {
      final invalidPublicKey = Uint8List(50);
      expect(
          () async => await LogpassCrypto.verifyBlockchainTransactionSignature(
              encodedTestMessage, Uint8List(64), invalidPublicKey),
          throwsA((e) => e is LogpassCryptoException));
    });
  });
}
