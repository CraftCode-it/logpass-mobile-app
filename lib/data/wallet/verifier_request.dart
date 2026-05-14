import 'dart:convert';

class VerifierRequest {
  final String requestId;
  final String verifier;
  final String requestType;
  final int minAge;
  final bool allowGuardian;

  VerifierRequest({
    required this.requestId,
    required this.verifier,
    required this.requestType,
    required this.minAge,
    this.allowGuardian = false,
  });

  factory VerifierRequest.fromQrPayload(String jsonStr) {
    final map = jsonDecode(jsonStr) as Map<String, dynamic>;
    if (map['type'] != 'logpass_verify') {
      throw FormatException('Not a LogPass verification QR code');
    }
    return VerifierRequest(
      requestId: map['request_id'] as String,
      verifier: map['verifier'] as String,
      requestType: map['request_type'] as String? ?? 'age_18',
      minAge: map['min_age'] as int? ?? 18,
      allowGuardian: map['allow_guardian'] as bool? ?? false,
    );
  }
}
