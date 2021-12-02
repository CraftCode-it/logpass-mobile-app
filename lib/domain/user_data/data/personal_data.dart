import 'package:logpass_me/domain/user_data/default_data.dart';

class PersonalData implements DefaultData {
  final String name;
  final String surname;

  @override
  final bool isDefault;

  @override
  final String uuid;

  PersonalData({
    required this.name,
    required this.surname,
    required this.uuid,
    this.isDefault = false,
  });

  @override
  String toString() => '$name $surname';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PersonalData &&
              other.name == name &&
              other.surname == surname &&
              other.isDefault == isDefault &&
              other.uuid == uuid;

  @override
  int get hashCode {
    return name.hashCode ^
    surname.hashCode ^
    uuid.hashCode ^
    isDefault.hashCode;
  }

  PersonalData copyWith({
    String? name,
    String? surname,
    bool? isDefault,
    String? uuid,
  }) {
    return PersonalData(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      isDefault: isDefault ?? this.isDefault,
      uuid: uuid ?? this.uuid,
    );
  }
}
