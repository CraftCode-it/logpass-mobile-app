class ServiceActivity {
  final String id;
  final String serviceName;
  final String? serviceUrl;
  final String actionType;
  final Map<String, dynamic>? details;
  final DateTime createdAt;

  const ServiceActivity({
    required this.id,
    required this.serviceName,
    this.serviceUrl,
    required this.actionType,
    this.details,
    required this.createdAt,
  });

  factory ServiceActivity.fromJson(Map<String, dynamic> json) => ServiceActivity(
        id: json['id'] as String? ?? '',
        serviceName: json['service_name'] as String? ?? '',
        serviceUrl: json['service_url'] as String?,
        actionType: json['action_type'] as String? ?? '',
        details: json['details'] as Map<String, dynamic>?,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : DateTime.now(),
      );

  String get actionLabel {
    switch (actionType) {
      case 'login':
        return 'Logowanie';
      case 'registration':
        return 'Rejestracja';
      case 'purchase':
        return 'Zakup';
      case 'verification':
        return 'Weryfikacja';
      case 'guardian_auth':
        return 'Autoryzacja opiekuna';
      default:
        return actionType;
    }
  }
}

class ServiceSummary {
  final String serviceName;
  final DateTime lastActivity;
  final int actionCount;

  const ServiceSummary({
    required this.serviceName,
    required this.lastActivity,
    required this.actionCount,
  });

  factory ServiceSummary.fromJson(Map<String, dynamic> json) => ServiceSummary(
        serviceName: json['service_name'] as String? ?? '',
        lastActivity: json['last_activity'] != null
            ? DateTime.parse(json['last_activity'] as String)
            : DateTime.now(),
        actionCount: (json['action_count'] as num?)?.toInt() ?? 0,
      );
}
