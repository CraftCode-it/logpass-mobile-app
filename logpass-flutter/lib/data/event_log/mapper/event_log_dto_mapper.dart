import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/data_mapper.dart';
import 'package:logpass_me/data/event_log/api/dto/application_dto.dart';
import 'package:logpass_me/data/event_log/api/dto/event_log_dto.dart';
import 'package:logpass_me/domain/event_log/event_log.dart';
import 'package:logpass_me/domain/event_log/event_type.dart';
import 'package:logpass_me/domain/event_log/logo_type.dart';

@Injectable()
class EventLogDTOMapper implements DataMapper<EventLogDTO, EventLog> {
  @override
  EventLog call(EventLogDTO data) {

    final eventType = getServiceType(data.type);
    final logo = getLogoType(eventType, data.extraData.application);

    return EventLog(
      logo: logo,
      eventType: eventType,
      dateTime: DateTime.parse(data.reportedAt),
    );
  }

  LogoType getLogoType(EventType eventType, ApplicationDTO? applicationDTO) {

    final networkImage = applicationDTO != null ? LogoType.network(applicationDTO.url) : LogoType.none();
    final assetLogpassImage = LogoType.local('assets/launcher/launcher_android_legacy.png');

    return eventType.maybeMap(
      loginAttemptCreated: (_) => assetLogpassImage,
      loginAttemptVerificationFailed: (_) => assetLogpassImage,
      loginAttemptVerificationRetry: (_) => assetLogpassImage,
      loginAttemptVerificationFinished: (_) => assetLogpassImage,
      authorizationAttemptCreated: (_) => networkImage,
      authorizationAttemptApproved: (_) => networkImage,
      authorizationAttemptDenied: (_) => networkImage,
      agreementAccepted: (_) => networkImage,
      agreementRevoked: (_) => networkImage,
      backupEntryCreated: (_) => networkImage,
      backupEntryUpdated: (_) => networkImage,
      backupEntryDeleted: (_) => networkImage,
      orElse: () => LogoType.none(),
    );
  }

  //TODO add logout type when api will be ready
  EventType getServiceType(String type) {
    switch(type) {
      case 'login_attempt_created': return EventType.loginAttemptCreated();
      case 'login_attempt_verification_failed': return EventType.loginAttemptVerificationFailed();
      case 'login_attempt_verification_retry': return EventType.loginAttemptVerificationRetry();
      case 'login_attempt_verification_finished': return EventType.loginAttemptVerificationFinished();
      case 'authorization_attempt_created': return EventType.authorizationAttemptCreated();
      case 'authorization_attempt_approved': return EventType.authorizationAttemptApproved();
      case 'authorization_attempt_denied': return EventType.authorizationAttemptDenied();
      case 'agreement_accepted': return EventType.agreementAccepted();
      case 'agreement_revoked': return EventType.agreementRevoked();
      case 'backup_entry_created': return EventType.backupEntryCreated();
      case 'backup_entry_updated': return EventType.backupEntryUpdated();
      case 'backup_entry_deleted': return EventType.backupEntryDeleted();
      default: throw Exception('Unsupported action type');
    }
  }
}