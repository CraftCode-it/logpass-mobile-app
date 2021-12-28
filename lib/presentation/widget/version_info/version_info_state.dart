part of 'version_info_cubit.dart';

@freezed
class VersionInfoState with _$VersionInfoState {
  @Implements<BuildState>()
  const factory VersionInfoState.idle(String versionInfo) = _VersionInfoStateIdle;
}
