import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

part 'language_page_state.freezed.dart';

@freezed
class LanguagePageState with _$LanguagePageState {
  @Implements<BuildState>()
  factory LanguagePageState.loading() = _LanguagePageStateLoading;

  @Implements<BuildState>()
  factory LanguagePageState.idle(String languageCode) = _LanguagePageStateIdle;
}
