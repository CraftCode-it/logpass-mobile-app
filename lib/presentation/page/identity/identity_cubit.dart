import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/core/crypto/key_provider.dart';
import 'package:logpass_me/data/identity/identity_repository_impl.dart';
import 'package:logpass_me/domain/identity/identity_field.dart';
import 'package:logpass_me/domain/identity/identity_profile.dart';
import 'package:logpass_me/domain/identity/identity_repository.dart';
import 'package:logpass_me/domain/wallet/wallet_repository.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

abstract class IdentityState implements BuildState {}

class IdentityLoading extends IdentityState {}

class IdentityLoaded extends IdentityState {
  final List<IdentityProfile> profiles;
  final String activeProfileId;
  final bool identityVerified;
  IdentityLoaded({
    required this.profiles,
    required this.activeProfileId,
    this.identityVerified = false,
  });
}

class IdentityVerifying extends IdentityState {}

class IdentityVerified extends IdentityState {
  final String firstName;
  final String lastName;
  final String pesel;
  final String dob;
  IdentityVerified({
    required this.firstName,
    required this.lastName,
    required this.pesel,
    required this.dob,
  });
}

class IdentityError extends IdentityState {
  final String message;
  IdentityError(this.message);
}

@injectable
class IdentityCubit extends Cubit<IdentityState> {
  final IdentityRepository _repository;
  final WalletRepository _walletRepository;
  final KeyProvider _keyProvider;

  IdentityCubit(this._repository, this._walletRepository, this._keyProvider)
      : super(IdentityLoading());

  Future<void> load() async {
    emit(IdentityLoading());
    try {
      final profiles = await _repository.getProfiles();
      final activeId = await _repository.getActiveProfileId();
      bool identityVerified = false;
      try {
        final selfData = await _walletRepository.getUserSelf();
        final backendVerified = selfData['identity_verified'] == true;
        if (backendVerified) {
          final activeProfile = profiles.firstWhere(
            (p) => p.id == activeId,
            orElse: () => profiles.isNotEmpty ? profiles.first : throw StateError('no profiles'),
          );
          final firstName = activeProfile.fields
              .where((f) => f.key == IdentityFieldKey.firstName)
              .map((f) => f.value)
              .firstOrNull ?? '';
          final dob = activeProfile.fields
              .where((f) => f.key == IdentityFieldKey.dateOfBirth)
              .map((f) => f.value)
              .firstOrNull ?? '';

          // Hydrate local profile from backend when locally empty
          if (firstName.isEmpty && dob.isEmpty) {
            final backendFirstName = selfData['first_name'] as String? ?? '';
            final backendLastName = selfData['last_name'] as String? ?? '';
            final backendDob = selfData['dob'] as String? ?? '';
            if (backendFirstName.isNotEmpty || backendDob.isNotEmpty) {
              await _repository.applyVerifiedIdentity({
                'first_name': backendFirstName,
                'last_name': backendLastName,
                'dob': backendDob,
                'pesel_masked': '',
                'address': {
                  'city': selfData['address_city'] as String? ?? '',
                  'street': selfData['address_street'] as String? ?? '',
                  'postal_code': selfData['address_postal_code'] as String? ?? '',
                },
              });
              return load();
            }
          }

          identityVerified = firstName.isNotEmpty || dob.isNotEmpty;
        }
      } catch (_) {}
      emit(IdentityLoaded(
        profiles: profiles,
        activeProfileId: activeId,
        identityVerified: identityVerified,
      ));
    } catch (e) {
      emit(IdentityError(e.toString()));
    }
  }

  Future<void> verifyMobywatel(String testAccount) async {
    emit(IdentityVerifying());
    try {
      final data = await _walletRepository.verifyIdentityMobywatel(testAccount);
      if (kDebugMode) {
        debugPrint('[mObywatel] keys received: ${data.keys.toList()}');
      }

      await _repository.applyVerifiedIdentity(data);

      final fn = data['first_name'] as String? ?? '';
      final ln = data['last_name'] as String? ?? '';
      final ps = data['pesel_masked'] as String? ?? '';
      final db = data['dob'] as String? ?? '';
      emit(IdentityVerified(firstName: fn, lastName: ln, pesel: ps, dob: db));

      // Auto-credential 18+ if DOB indicates adult
      final dobStr = data['dob'] as String? ?? '';
      if (dobStr.isNotEmpty) {
        try {
          final dob = DateTime.parse(dobStr);
          final age = _calculateAge(dob);
          if (age >= 18) {
            final pubkey = await _keyProvider.getUserPubkeyHex();
            await _walletRepository.requestAgeVerification(
              userPubkey: pubkey,
              minAge: 18,
            );
          }
        } catch (e, st) {
          if (kDebugMode) {
            debugPrint('[mObywatel] Auto-credential 18+ FAILED: $e\n$st');
          }
        }
      }

      await load();
    } catch (e) {
      emit(IdentityError(e.toString()));
    }
  }

  int _calculateAge(DateTime dob) {
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }

  Future<void> setActiveProfile(String profileId) async {
    await _repository.setActiveProfileId(profileId);
    await load();
  }

  Future<void> updateField(String profileId, String fieldKey, String value) async {
    final state = this.state;
    if (state is! IdentityLoaded) return;
    final loaded = state as IdentityLoaded;
    final profile = loaded.profiles.firstWhere((p) => p.id == profileId);
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
    if (state is! IdentityLoaded) return;
    final loaded = state as IdentityLoaded;
    final profile = loaded.profiles.firstWhere((p) => p.id == profileId);
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

  Future<void> copyFieldToProfile(
    String sourceProfileId,
    String targetProfileId,
    String fieldKey,
  ) async {
    final st = state;
    if (st is! IdentityLoaded) return;
    final source = st.profiles.firstWhere((p) => p.id == sourceProfileId);
    final target = st.profiles.firstWhere((p) => p.id == targetProfileId);
    final field = source.fields.where((f) => f.key == fieldKey).firstOrNull;
    if (field == null) return;
    if (field.value.trim().isEmpty) return;

    final targetField = target.fields.where((f) => f.key == fieldKey).firstOrNull;
    if (targetField != null && targetField.isLocked) return;

    final existingIdx = target.fields.indexWhere((f) => f.key == fieldKey);
    final List<IdentityField> updatedFields;
    if (existingIdx >= 0) {
      updatedFields = List.of(target.fields);
      updatedFields[existingIdx] = updatedFields[existingIdx].copyWith(value: field.value);
    } else {
      updatedFields = [
        ...target.fields,
        IdentityField(key: field.key, label: field.label, value: field.value),
      ];
    }
    await _repository.saveProfile(target.copyWith(fields: updatedFields));
    await load();
  }
}
