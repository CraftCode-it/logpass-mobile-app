abstract class HiveEntity<I> {
  final String uuid;
  final bool isDefault;

  HiveEntity(this.uuid, this.isDefault);

  I copyWith({bool? isDefault});

  int hashIt();
}
