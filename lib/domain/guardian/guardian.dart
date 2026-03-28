class Guardian {
  final String id;
  final String userId;
  final String? firstName;
  final String? lastName;
  final String status;
  final DateTime createdAt;

  const Guardian({
    required this.id,
    required this.userId,
    this.firstName,
    this.lastName,
    required this.status,
    required this.createdAt,
  });

  String get displayName {
    final first = firstName ?? '';
    final last = lastName ?? '';
    final full = '$first $last'.trim();
    return full.isEmpty ? 'Nieznany użytkownik' : full;
  }

  bool get isActive => status == 'active';
  bool get isPending => status == 'pending';

  factory Guardian.fromJson(Map<String, dynamic> json) => Guardian(
        id: json['id'] as String,
        userId: json['user_id'] as String? ?? json['guardian_user_id'] as String? ?? '',
        firstName: json['first_name'] as String?,
        lastName: json['last_name'] as String?,
        status: json['status'] as String? ?? 'pending',
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : DateTime.now(),
      );
}
