enum IdentityProfileType {
  /// Prywatny: real data; name/surname/DOB locked from verification
  private,

  /// Służbowy: real name/surname locked; other fields editable
  work,

  /// Fake: only age locked from verification; all other fields editable
  fake,

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
      case IdentityProfileType.fake:
        return 'Fake';
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
