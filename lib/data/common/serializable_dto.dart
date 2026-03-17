abstract class SerializableDto<T> {
  Map<String, dynamic> toJson();

  T fromJson(Map<String, dynamic> json);
}
