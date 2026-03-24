import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/identity/identity_repository_impl.dart';
import 'package:logpass_me/domain/identity/identity_field.dart';
import 'package:logpass_me/domain/identity/identity_profile.dart';
import 'package:logpass_me/domain/identity/identity_repository.dart';

part 'identity_cubit.freezed.dart';

@freezed
class IdentityState with _$IdentityState {
  const factory IdentityState.loading() = _Loading;
  const factory IdentityState.loaded({
    required List<IdentityProfile> profiles,
    required String activeProfileId,
  }) = _Loaded;
  const factory IdentityState.error(String message) = _Error;
}

@injectable
class IdentityCubit extends Cubit<IdentityState> {
  final IdentityRepository _repository;

  IdentityCubit(this._repository) : super(const IdentityState.loading());

  Future<void> load() async {
    emit(const IdentityState.loading());
    try {
      final profiles = await _repository.getProfiles();
      final activeId = await _repository.getActiveProfileId();
      emit(IdentityState.loaded(profiles: profiles, activeProfileId: activeId));
    } catch (e) {
      emit(IdentityState.error(e.toString()));
    }
  }

  Future<void> setActiveProfile(String profileId) async {
    await _repository.setActiveProfileId(profileId);
    await load();
  }

  Future<void> updateField(String profileId, String fieldKey, String value) async {
    final state = this.state;
    if (state is! _Loaded) return;
    final profile = state.profiles.firstWhere((p) => p.id == profileId);
    final updatedFields = profile.fields.map((f) {
      if (f.key == fieldKey && !f.isLocked) {
        return f.copyWith(value: value);
      }
      return f;
    }).toList();
    await _repository.saveProfile(profile.copyWith(fields: updatedFields));
    await load();
  }

  Future<void> addCustomField(String profileId, String key, String label, String value) async {
    final state = this.state;
    if (state is! _Loaded) return;
    final profile = state.profiles.firstWhere((p) => p.id == profileId);
    final newField = IdentityField(key: key, label: label, value: value);
    final updatedFields = [...profile.fields, newField];
    await _repository.saveProfile(profile.copyWith(fields: updatedFields));
    await load();
  }

  Future<void> addCustomProfile(String displayName) async {
    final profile = createCustomProfile(displayName);
    await _repository.saveProfile(profile);
    await _repository.setActiveProfileId(profile.id);
    await load();
  }

  Future<void> deleteProfile(String profileId) async {
    await _repository.deleteProfile(profileId);
    await load();
  }
}
