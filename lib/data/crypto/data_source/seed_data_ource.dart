import 'dart:typed_data';

abstract class SeedDataSource {
  Future<Uint8List?> getSeed();
}
