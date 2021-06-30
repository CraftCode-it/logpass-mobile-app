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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PersonalData && other.name == name && other.surname == surname && other.isDefault == isDefault;
  }

  @override
  int get hashCode => name.hashCode ^ surname.hashCode ^ isDefault.hashCode;

  @override
  String toString() => '$name $surname';
}
