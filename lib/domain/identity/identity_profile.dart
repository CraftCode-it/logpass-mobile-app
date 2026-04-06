import 'package:flutter/foundation.dart';
import 'package:logpass_me/domain/identity/identity_field.dart';
import 'package:logpass_me/domain/identity/identity_profile_type.dart';

class IdentityProfile {
  final String id;

  /// Display name shown in UI (user-editable for custom profiles).
  final String displayName;

  final IdentityProfileType type;
  final List<IdentityField> fields;

  const IdentityProfile({
    required this.id,
    required this.displayName,
    required this.type,
    required this.fields,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdentityProfile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          displayName == other.displayName &&
          type == other.type &&
          listEquals(fields, other.fields);

  @override
  int get hashCode => Object.hash(id, displayName, type, Object.hashAll(fields));

  IdentityProfile copyWith({
    String? displayName,
    List<IdentityField>? fields,
  }) {
    return IdentityProfile(
      id: id,
      displayName: displayName ?? this.displayName,
      type: type,
      fields: fields ?? this.fields,
    );
  }

  /// Returns editability of a field based on profile type.
  bool isFieldEditable(String fieldKey) {
    final field = fields.where((f) => f.key == fieldKey).firstOrNull;
    if (field != null && field.isLocked) return false;
    return true;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'displayName': displayName,
        'type': type.key,
        'fields': fields.map((f) => f.toJson()).toList(),
      };

  factory IdentityProfile.fromJson(Map<String, dynamic> json) => IdentityProfile(
        id: json['id'] as String,
        displayName: json['displayName'] as String? ?? '',
        type: IdentityProfileTypeExtension.fromKey(json['type'] as String? ?? 'custom'),
        fields: ((json['fields'] as List?) ?? [])
            .map((f) => IdentityField.fromJson(f as Map<String, dynamic>))
            .toList(),
      );

  /// Creates the default "Prywatny" profile with empty values.
  static IdentityProfile defaultPrivate() => IdentityProfile(
        id: 'private',
        displayName: 'Prywatny',
        type: IdentityProfileType.private,
        fields: [
          IdentityField(key: IdentityFieldKey.firstName, label: IdentityFieldKey.label(IdentityFieldKey.firstName), value: '', isLocked: false),
          IdentityField(key: IdentityFieldKey.lastName, label: IdentityFieldKey.label(IdentityFieldKey.lastName), value: '', isLocked: false),
          IdentityField(key: IdentityFieldKey.dateOfBirth, label: IdentityFieldKey.label(IdentityFieldKey.dateOfBirth), value: '', isLocked: true),
          IdentityField(key: IdentityFieldKey.peselMasked, label: IdentityFieldKey.label(IdentityFieldKey.peselMasked), value: '', isLocked: true),
          IdentityField(key: IdentityFieldKey.email, label: IdentityFieldKey.label(IdentityFieldKey.email), value: '', isLocked: false),
          IdentityField(key: IdentityFieldKey.phone, label: IdentityFieldKey.label(IdentityFieldKey.phone), value: '', isLocked: false),
          IdentityField(key: IdentityFieldKey.addressCity, label: IdentityFieldKey.label(IdentityFieldKey.addressCity), value: '', isLocked: true),
          IdentityField(key: IdentityFieldKey.addressStreet, label: IdentityFieldKey.label(IdentityFieldKey.addressStreet), value: '', isLocked: true),
          IdentityField(key: IdentityFieldKey.addressPostalCode, label: IdentityFieldKey.label(IdentityFieldKey.addressPostalCode), value: '', isLocked: true),
          IdentityField(key: IdentityFieldKey.invoiceData, label: IdentityFieldKey.label(IdentityFieldKey.invoiceData), value: '', isLocked: false),
        ],
      );

  /// Creates the default "Służbowy" profile.
  static IdentityProfile defaultWork() => IdentityProfile(
        id: 'work',
        displayName: 'Służbowy',
        type: IdentityProfileType.work,
        fields: [
          IdentityField(key: IdentityFieldKey.firstName, label: IdentityFieldKey.label(IdentityFieldKey.firstName), value: '', isLocked: false),
          IdentityField(key: IdentityFieldKey.lastName, label: IdentityFieldKey.label(IdentityFieldKey.lastName), value: '', isLocked: false),
          IdentityField(key: IdentityFieldKey.dateOfBirth, label: IdentityFieldKey.label(IdentityFieldKey.dateOfBirth), value: '', isLocked: true),
          IdentityField(key: IdentityFieldKey.peselMasked, label: IdentityFieldKey.label(IdentityFieldKey.peselMasked), value: '', isLocked: true),
          IdentityField(key: IdentityFieldKey.email, label: IdentityFieldKey.label(IdentityFieldKey.email), value: '', isLocked: false),
          IdentityField(key: IdentityFieldKey.phone, label: IdentityFieldKey.label(IdentityFieldKey.phone), value: '', isLocked: false),
          IdentityField(key: IdentityFieldKey.addressCity, label: IdentityFieldKey.label(IdentityFieldKey.addressCity), value: '', isLocked: true),
          IdentityField(key: IdentityFieldKey.addressStreet, label: IdentityFieldKey.label(IdentityFieldKey.addressStreet), value: '', isLocked: true),
          IdentityField(key: IdentityFieldKey.addressPostalCode, label: IdentityFieldKey.label(IdentityFieldKey.addressPostalCode), value: '', isLocked: true),
          IdentityField(key: IdentityFieldKey.invoiceData, label: IdentityFieldKey.label(IdentityFieldKey.invoiceData), value: '', isLocked: false),
        ],
      );

  /// Creates the default "Proxy" profile.
  static IdentityProfile defaultProxy() => IdentityProfile(
        id: 'proxy',
        displayName: 'Proxy',
        type: IdentityProfileType.proxy,
        fields: [
          IdentityField(key: IdentityFieldKey.firstName, label: IdentityFieldKey.label(IdentityFieldKey.firstName), value: '', isLocked: false),
          IdentityField(key: IdentityFieldKey.lastName, label: IdentityFieldKey.label(IdentityFieldKey.lastName), value: '', isLocked: false),
          IdentityField(key: IdentityFieldKey.dateOfBirth, label: IdentityFieldKey.label(IdentityFieldKey.dateOfBirth), value: '', isLocked: true),
          IdentityField(key: IdentityFieldKey.email, label: IdentityFieldKey.label(IdentityFieldKey.email), value: '', isLocked: false),
          IdentityField(key: IdentityFieldKey.phone, label: IdentityFieldKey.label(IdentityFieldKey.phone), value: '', isLocked: false),
        ],
      );
}
