class PersonalData {
  final String name;
  final String surname;
  final bool isDefault;

  PersonalData({
    required this.name,
    required this.surname,
    this.isDefault = false,
  });

  @override
  String toString() => '$name $surname';
}
