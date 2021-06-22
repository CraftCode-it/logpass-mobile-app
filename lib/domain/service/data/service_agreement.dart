import 'package:logpass_me/domain/model/agreement_type.dart';
import 'package:logpass_me/domain/model/scope.dart';

class ServiceAgreement {
  final String id;
  final AgreementType type;
  final String name;
  final String url;
  final String checksum;
  final bool isRequired;
  final bool isAccepted;
  final Scope? scope;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceAgreement({
    required this.id,
    required this.type,
    required this.name,
    required this.url,
    required this.checksum,
    required this.isRequired,
    required this.isAccepted,
    required this.createdAt,
    required this.updatedAt,
    required this.scope,
  });

  ServiceAgreement copyWith({bool? isAccepted}) {
    return ServiceAgreement(
      name: name,
      scope: scope,
      type: type,
      checksum: checksum,
      createdAt: createdAt,
      id: id,
      isAccepted: isAccepted ?? this.isAccepted,
      isRequired: isRequired,
      updatedAt: updatedAt,
      url: url,
    );
  }
}
