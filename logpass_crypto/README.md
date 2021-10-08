# logpass_crypto

Crypto library (wrapper) for LogPass mobile app. It uses [cryptography](https://pub.dev/packages/cryptography) as its crypto backend.

## Usage

When app is initialized for the first time, random 64 bytes seed must be created by using function:
```dart
final seed = LogpassCrypto.generateSeed()
```
Seed must be stored in database and never change, it should be generated only once.

With seed ready, `LogpassCrypto` can be initialized with
```dart
final crypto = await LogpassCrypto.create(seed)
```

`LogpassCrypto` has 2 important attibutes needed by backend:
`publicKey` - Public key for X25519 key-exchange algorithm
`verifyKey` - Public key for Ed25519 digital signature algorithm
Both of them are 32 bytes `Uint8List`.

To get them just use:
```dart
crypto.publicKey
crypto.verifyKey
```

By now `LogpassCrypto` has 4 useful methods:
```dart
/// encrypts message for itself and other recipients (set of public keys)
Future<Uint8List> encrypt(Uint8List message, {Set<Uint8List> recipients = const {}}) async
/// decrypts encrypted message
Future<Uint8List> decrypt(Uint8List message) async
/// signs blockchain transaction, returns signature (64 bytes)
Future<Uint8List> signBlockchainTransaction(Uint8List data) async
/// signs logpass token, returns signature (64 bytes)
Future<Uint8List> signLogpassToken(Uint8List data) async
```

Every method throws LogpassCryptoException in case of error.

Check `tests` for examples how to use descripted methods.
