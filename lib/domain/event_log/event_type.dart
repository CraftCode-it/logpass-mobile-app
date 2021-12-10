import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_type.freezed.dart';

@freezed
class EventType with _$EventType {
  factory EventType.loginAttemptCreated() = EventTypeLoginAttemptCreated;
  factory EventType.loginAttemptVerificationFailed() = EventTypeLoginAttemptVerificationFailed;
  factory EventType.loginAttemptVerificationRetry() = EventTypeLoginAttemptVerificationRetry;
  factory EventType.loginAttemptVerificationFinished() = EventTypeLoginAttemptVerificationFinished;
  factory EventType.authorizationAttemptCreated() = EventTypeAuthorizationAttemptCreated;
  factory EventType.authorizationAttemptApproved() = EventTypeAuthorizationAttemptApproved;
  factory EventType.authorizationAttemptDenied() = EventTypeAuthorizationAttemptDenied;
  factory EventType.agreementAccepted() = EventTypeAgreementAccepted;
  factory EventType.agreementRevoked() = EventTypeAgreementRevoked;
  factory EventType.backupEntryCreated() = EventTypeBackupEntryCreated;
  factory EventType.backupEntryUpdated() = EventTypeBackupEntryUpdated;
  factory EventType.backupEntryDeleted() = EventTypeBackupEntryDeleted;
}