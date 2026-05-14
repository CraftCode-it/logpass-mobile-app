enum IdentityProfileType {
  /// Prywatny: real data; DOB locked from verification
  private,

  /// Służbowy: real name/surname locked; DOB locked from verification
  work,

  /// Proxy: DOB locked from verification; all other fields editable
  proxy,

  /// Adult: optional wallet preferences shared only with explicit consent
  adult,

  /// Custom: user-named profile; all fields editable
  custom,
}

extension IdentityProfileTypeExtension on IdentityProfileType {
  String get defaultDisplayName {
    switch (this) {
      case IdentityProfileType.private:
        return 'Prywatny';
      case IdentityProfileType.work:
        return 'Służbowy';
      case IdentityProfileType.proxy:
        return 'Proxy';
      case IdentityProfileType.adult:
        return 'Preferencje 18+';
      case IdentityProfileType.custom:
        return 'Niestandardowy';
    }
  }

  String get key => name;

  static IdentityProfileType fromKey(String key) {
    return IdentityProfileType.values.firstWhere(
      (e) => e.name == key,
      orElse: () => IdentityProfileType.custom,
    );
  }
}
