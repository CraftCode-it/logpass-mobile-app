class Email {
  final String value;
  final bool isDefault;

  Email(
    this.value, {
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
}
