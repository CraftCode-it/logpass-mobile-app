import 'package:logpass_me/domain/user_data/default_data.dart';

class PersonalData implements DefaultData {
  final String name;
  final String surname;

  @override
  final bool isDefault;

  PersonalData({
    required this.name,
    required this.surname,
    this.isDefault = false,
  });

  @override
  String toString() => '$name $surname';
}
