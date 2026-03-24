/// Predefined field keys used across profiles.
class IdentityFieldKey {
  static const firstName = 'firstName';
  static const lastName = 'lastName';
  static const dateOfBirth = 'dateOfBirth';
  static const email = 'email';
  static const phone = 'phone';
  static const address = 'address';
  static const invoiceData = 'invoiceData';

  /// Returns a human-readable Polish label for built-in fields.
  static String label(String key) {
    switch (key) {
      case firstName:
        return 'Imię';
      case lastName:
        return 'Nazwisko';
      case dateOfBirth:
        return 'Data urodzenia';
      case email:
        return 'Email';
      case phone:
        return 'Telefon';
      case address:
        return 'Adres';
      case invoiceData:
        return 'Dane do faktury';
      default:
        return key;
    }
  }
}

class IdentityField {
  final String key;
  final String label;
  final String value;

  /// If true, the value cannot be edited by the user (set from verification).
  final bool isLocked;

  const IdentityField({
    required this.key,
    required this.label,
    required this.value,
    this.isLocked = false,
  });

  IdentityField copyWith({String? value, bool? isLocked}) {
    return IdentityField(
      key: key,
      label: label,
      value: value ?? this.value,
      isLocked: isLocked ?? this.isLocked,
    );
  }

  Map<String, dynamic> toJson() => {
        'key': key,
        'label': label,
        'value': value,
        'isLocked': isLocked,
      };

  factory IdentityField.fromJson(Map<String, dynamic> json) => IdentityField(
        key: json['key'] as String,
        label: json['label'] as String? ?? json['key'] as String,
        value: json['value'] as String? ?? '',
        isLocked: json['isLocked'] as bool? ?? false,
      );
}
