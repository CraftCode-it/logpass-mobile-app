class Credential {
  final String id;
  final String type;
  final bool? result;
  final DateTime? validUntil;
  final String? commitmentHash;
  final String? onChainTxId;
  final DateTime issuedAt;
  final String status;
  /// True when credential was forced for a user whose DOB indicates age < 18.
  final bool forced;

  const Credential({
    required this.id,
    required this.type,
    this.result,
    this.validUntil,
    this.commitmentHash,
    this.onChainTxId,
    required this.issuedAt,
    required this.status,
    this.forced = false,
  });

  bool get isValid =>
      status == 'completed' &&
      result == true &&
      validUntil != null &&
      validUntil!.isAfter(DateTime.now());

  bool get isAnchored => onChainTxId != null && onChainTxId!.isNotEmpty;

  String get displayType {
    if (type.startsWith('age_')) {
      return 'Wiek ${type.substring(4)}+';
    }
    return type;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'result': result,
        'valid_until': validUntil?.toIso8601String(),
        'commitment_hash': commitmentHash,
        'on_chain_tx_id': onChainTxId,
        'issued_at': issuedAt.toIso8601String(),
        'status': status,
        'forced': forced,
      };

  factory Credential.fromMap(Map<String, dynamic> map) => Credential(
        id: map['id'] as String,
        type: map['type'] as String,
        result: map['result'] as bool?,
        validUntil: map['valid_until'] != null
            ? DateTime.parse(map['valid_until'] as String)
            : null,
        commitmentHash: map['commitment_hash'] as String?,
        onChainTxId: map['on_chain_tx_id'] as String?,
        issuedAt: DateTime.parse(map['issued_at'] as String),
        status: map['status'] as String,
        forced: map['forced'] as bool? ?? false,
      );
}
