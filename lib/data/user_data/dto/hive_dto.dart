abstract class HiveDto<I> {
  final String uuid;
  final bool isDefault;

  HiveDto(this.uuid, this.isDefault);

  I copyWith({bool? isDefault});
}
