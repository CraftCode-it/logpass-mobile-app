import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart' as cryptography;

class LogpassCryptoException implements Exception {
  String message;
  LogpassCryptoException(this.message);
}

class LogpassCrypto {
  /// Ed25519 is used for signing/verification
  late cryptography.SimpleKeyPair _ed25519KeyPair;

  /// X25519 is used for key exchange
  late cryptography.SimpleKeyPair _x25519KeyPair;

  /// Ed25519 public key
  late cryptography.SimplePublicKey _ed25519PublicKey;

  /// Ed25519 public key
  late cryptography.SimplePublicKey _x25519PublicKey;

  /// returns random number generator
  static Random get random => Random.secure();

  /// returns encryption algorithm
  static cryptography.AesGcm get aes => cryptography.AesGcm.with256bits();

  /// returns shared secret algorithm
  static cryptography.X25519 get x25519 => cryptography.X25519();

  /// returns digital signature algorithm
  static cryptography.Ed25519 get ed25519 => cryptography.Ed25519();

  /// returns version of encryption
  static int get version => 1;

  /// returns number of max possible recipients for encryption/decryption
  static int get maxRecipients => 15;

  /// returns size of encrypted secret for recipients
  static int get encryptedSecretSize => 60;

  /// returns length of seed
  static int get seedLength => 64;

  /// returns blockchain transaction prefix
  static Uint8List get blockchainTransactionPrefix =>
      Uint8List.fromList(utf8.encode("QAUTH SIGNED TRANSACTION:\n"));

  /// returns blockchain transaction prefix
  static Uint8List get logpassTokenPrefix =>
      Uint8List.fromList(utf8.encode("LOGPASS SIGNED TOKEN:\n"));

  /// creates LogpassCrypto, later _init() must be called
  LogpassCrypto._create();

  /// initialize class members, must be called after constructor
  Future _init(Uint8List seed) async {
    if (seed.length != seedLength) {
      throw LogpassCryptoException(
          "Invalid seed length, should be ${seedLength} bytes");
    }

    _ed25519KeyPair = await ed25519.newKeyPairFromSeed(
        seed.sublist(0, ed25519.keyPairType.publicKeyLength).toList());
    _ed25519PublicKey = await _ed25519KeyPair.extractPublicKey();
    _x25519KeyPair = await x25519.newKeyPairFromSeed(
        seed.sublist(8, 8 + x25519.keyPairType.publicKeyLength).toList());
    _x25519PublicKey = await _x25519KeyPair.extractPublicKey();
  }

  /// generates 64 bytes seed which should be used as parameter to create class
  static Uint8List generateSeed() {
    return randomBytes(seedLength);
  }

  /// generates random bytes
  static Uint8List randomBytes(int length) {
    var randomBytes = Uint8List(length);
    for (var i = 0; i < randomBytes.length; i++) {
      randomBytes[i] = random.nextInt(256);
    }
    return randomBytes;
  }

  /// creates LogpassCrypto class, needs 64 bytes seed
  /// static constructor is used because of async requirement
  static Future<LogpassCrypto> create(Uint8List seed) async {
    var lib = LogpassCrypto._create();
    await lib._init(seed);
    return lib;
  }

  /// Retuns X25519 public key (used for asymmetric encryption)
  Uint8List get publicKey => Uint8List.fromList(_x25519PublicKey.bytes);

  /// Returns Ed25519 public key (used for signatures)
  Uint8List get verifyKey => Uint8List.fromList(_ed25519PublicKey.bytes);

  /// signs blockchain transaction, returns signature (64 bytes)
  Future<Uint8List> signBlockchainTransaction(Uint8List data) async {
    return _sign(blockchainTransactionPrefix, data);
  }

  /// signs logpass token, returns signature (64 bytes)
  Future<Uint8List> signLogpassToken(Uint8List data) async {
    return _sign(logpassTokenPrefix, data);
  }

  /// verifies signature for given blockchain transaction and public key
  static Future<bool> verifyBlockchainTransactionSignature(
      Uint8List data, Uint8List signature, Uint8List publicKey) async {
    return _verify(blockchainTransactionPrefix, data, signature, publicKey);
  }

  /// verifies signature for given logpass token and public key
  static Future<bool> verifyLogpassTokenSignature(
      Uint8List data, Uint8List signature, Uint8List publicKey) async {
    return _verify(logpassTokenPrefix, data, signature, publicKey);
  }

  /// Encrypts data for itself and given recipients (limited by maxRecipients)
  /// Each recipient should be 32 bytes Uint8List (value returned by publicKey())
  /// throws LogpassCryptoException in case of error
  Future<Uint8List> encrypt(Uint8List message,
      {Set<Uint8List> recipients = const {}}) async {
    // generate 32 bytes secret to encrypt data
    final secret = await aes.newSecretKey();
    // encrypt secret for itself and other recipients
    final encryptedSecret = await _encryptSecret(secret, recipients);
    // encrypt message
    final encryptedMessage = await aes.encrypt(message, secretKey: secret);
    // return encryptedSecret and encryptedMessage
    var buffer = BytesBuilder();
    buffer.add(encryptedSecret);
    buffer.add(encryptedMessage.concatenation());
    return buffer.toBytes();
  }

  /// Decrypts data returned by encrypt method
  /// throws LogpassCryptoException in case of error
  Future<Uint8List> decrypt(Uint8List message) async {
    // decrypt secret
    final secret = await _decryptSecret(message);
    // extract encrypted message
    final recipients = message[1 + x25519.keyPairType.publicKeyLength];
    final encryptedMessage = message.sublist(2 +
        x25519.keyPairType.publicKeyLength +
        recipients * encryptedSecretSize);
    // decrypt message
    final box = cryptography.SecretBox.fromConcatenation(encryptedMessage,
        nonceLength: aes.nonceLength, macLength: aes.macAlgorithm.macLength);
    try {
      final decrypted = await aes.decrypt(box, secretKey: secret);
      return Uint8List.fromList(decrypted);
    } on cryptography.SecretBoxAuthenticationError {}
    throw LogpassCryptoException("Invalid data");
  }

  /// Encrypts 32 bytes secret for itself and recipients
  Future<Uint8List> _encryptSecret(
      cryptography.SecretKey secret, Set<Uint8List> recipients) async {
    final secretBytes = await secret.extractBytes();
    if (secretBytes.length != x25519.keyPairType.publicKeyLength) {
      throw LogpassCryptoException(
          "Invalid length of secret, should be ${x25519.keyPairType.publicKeyLength} bytes");
    }
    if (recipients.length > maxRecipients) {
      throw LogpassCryptoException(
          "Invalid number of recipients, should be between 0 and $maxRecipients");
    }

    final localPublicKey =
        Uint8List.fromList((await _x25519KeyPair.extractPublicKey()).bytes);
    Set<Uint8List> finalRecipients = {localPublicKey, ...recipients};

    final keyPair = await x25519.newKeyPair();
    final keyPairPublicKey = await keyPair.extractPublicKey();

    var buffer = BytesBuilder();
    buffer.addByte(version); // version
    buffer.add(keyPairPublicKey.bytes); // public key of generated keyPair
    buffer.addByte(finalRecipients.length); // number of recipients
    for (final recipient in finalRecipients) {
      if (recipient.length != x25519.keyPairType.publicKeyLength) {
        throw LogpassCryptoException(
            "Invalid length of recipient, should be ${x25519.keyPairType.publicKeyLength} bytes");
      }
      final publicKey = cryptography.SimplePublicKey(recipient,
          type: cryptography.KeyPairType.x25519);
      final sharedSecret = await x25519.sharedSecretKey(
          keyPair: keyPair, remotePublicKey: publicKey);
      final encryptedSecret =
          await aes.encrypt(secretBytes, secretKey: sharedSecret); // 60 bytes
      final encryptedSecretBytes = encryptedSecret.concatenation();
      if (encryptedSecretBytes.length != encryptedSecretSize) {
        throw LogpassCryptoException(
            "Invalid length of encrypted secret, should be $encryptedSecretSize bytes");
      }
      buffer.add(encryptedSecretBytes);
    }
    return buffer.toBytes();
  }

  /// Decrypts 32 bytes secret
  Future<cryptography.SecretKey> _decryptSecret(
      Uint8List encryptedSecret) async {
    if (encryptedSecret[0] != version) {
      throw LogpassCryptoException("Invalid version of encrypted secret");
    }
    if (encryptedSecret.length <
        x25519.keyPairType.publicKeyLength + 2 + encryptedSecretSize) {
      throw LogpassCryptoException(
          "Invalid length of encrypted secret (too small)");
    }
    final rawPublicKey =
        encryptedSecret.sublist(1, 1 + x25519.keyPairType.publicKeyLength);
    final publicKey = cryptography.SimplePublicKey(rawPublicKey,
        type: cryptography.KeyPairType.x25519);
    final recipients = encryptedSecret[1 + x25519.keyPairType.publicKeyLength];
    if (recipients == 0 || recipients > maxRecipients + 1) {
      throw LogpassCryptoException("Invalid number of recipients");
    }
    final sharedSecret = await x25519.sharedSecretKey(
        keyPair: _x25519KeyPair, remotePublicKey: publicKey);
    for (int i = 0; i < recipients; ++i) {
      final readPos =
          1 + x25519.keyPairType.publicKeyLength + 1 + encryptedSecretSize * i;
      final encryptedData =
          encryptedSecret.sublist(readPos, readPos + encryptedSecretSize);
      final box = cryptography.SecretBox.fromConcatenation(encryptedData,
          nonceLength: aes.nonceLength, macLength: aes.macAlgorithm.macLength);
      try {
        final data = await aes.decrypt(box, secretKey: sharedSecret);
        if (data.length != x25519.keyPairType.publicKeyLength) {
          throw LogpassCryptoException(
              "Invalid length of decrypted secret, should be ${x25519.keyPairType.publicKeyLength} bytes");
        }
        return aes.newSecretKeyFromBytes(data);
      } on cryptography.SecretBoxAuthenticationError {
        continue;
      }
    }
    throw LogpassCryptoException("Can't decrypt secret");
  }

  /// signs any data
  Future<Uint8List> _sign(Uint8List prefix, Uint8List message) async {
    final signature =
        await ed25519.sign([...prefix, ...message], keyPair: _ed25519KeyPair);
    return Uint8List.fromList(signature.bytes);
  }

  /// verifies any data
  static Future<bool> _verify(Uint8List prefix, Uint8List data,
      Uint8List signature, Uint8List rawPublicKey) async {
    if (signature.length != 64) {
      throw LogpassCryptoException(
          "Invalid signature length, should be 64 bytes");
    }
    if (rawPublicKey.length != x25519.keyPairType.publicKeyLength) {
      throw LogpassCryptoException(
          "Invalid length of public key, should be ${x25519.keyPairType.publicKeyLength} bytes");
    }
    final publicKey = cryptography.SimplePublicKey(rawPublicKey,
        type: cryptography.KeyPairType.x25519);
    return await ed25519.verify([...prefix, ...data],
        signature: cryptography.Signature(signature, publicKey: publicKey));
  }
}
