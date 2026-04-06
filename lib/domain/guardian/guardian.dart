class Guardian {
  final String id;
  final String userId;
  final String? firstName;
  final String? lastName;
  final String status;
  final DateTime createdAt;
  final String? relationshipType;

  const Guardian({
    required this.id,
    required this.userId,
    this.firstName,
    this.lastName,
    required this.status,
    required this.createdAt,
    this.relationshipType,
  });

  String get displayName {
    final first = firstName ?? '';
    final last = lastName ?? '';
    final full = '$first $last'.trim();
    return full.isEmpty ? 'Nieznany użytkownik' : full;
  }

  String get relationshipLabel {
    switch (relationshipType) {
      case 'parent':
        return 'Rodzic';
      case 'legal_guardian':
        return 'Opiekun prawny';
      default:
        return 'Opiekun';
    }
  }

  bool get isActive => status == 'active';
  bool get isPending => status == 'pending';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Guardian &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          status == other.status &&
          createdAt == other.createdAt &&
          relationshipType == other.relationshipType;

  @override
  int get hashCode => Object.hash(id, userId, firstName, lastName, status, createdAt, relationshipType);

  factory Guardian.fromJson(Map<String, dynamic> json) => Guardian(
        id: json['id'] as String,
        userId: json['user_id'] as String? ?? json['guardian_user_id'] as String? ?? '',
        firstName: json['first_name'] as String?,
        lastName: json['last_name'] as String?,
        status: json['status'] as String? ?? 'pending',
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : DateTime.now(),
        relationshipType: json['relationship_type'] as String?,
      );
}
