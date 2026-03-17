import 'package:logpass_me/domain/user_data/default_data.dart';

class Email implements DefaultData {
  final String value;

  @override
  final bool isDefault;

  @override
  final String uuid;

  Email(
    this.value, {
    required this.uuid,
    this.isDefault = false,
  });

  @override
  String toString() => '$value';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Email && other.value == value && other.isDefault == isDefault;
  }

  @override
  int get hashCode => value.hashCode ^ isDefault.hashCode;

  Email copyWith({
    String? value,
    bool? isDefault,
    String? uuid,
  }) {
    return Email(
      value ?? this.value,
      isDefault: isDefault ?? this.isDefault,
      uuid: uuid ?? this.uuid,
    );
  }
}
