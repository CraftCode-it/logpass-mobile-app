abstract class ApiUserDataDto<T> {
  final String keyName;

  ApiUserDataDto(this.keyName);

  Map<String, dynamic> serialize(T data);

  T deSerialize(Map<String, dynamic> data);
}
