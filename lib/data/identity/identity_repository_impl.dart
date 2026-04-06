import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/identity/identity_field.dart';
import 'package:logpass_me/domain/identity/identity_profile.dart';
import 'package:logpass_me/domain/identity/identity_profile_type.dart';
import 'package:logpass_me/domain/identity/identity_repository.dart';
import 'package:uuid/uuid.dart';

@Singleton(as: IdentityRepository)
class IdentityRepositoryImpl implements IdentityRepository {
  static const _profilesKey = 'logpass_identity_profiles';
  static const _activeProfileKey = 'logpass_identity_active_profile';
  static const _iosOptions = IOSOptions(accessibility: KeychainAccessibility.unlocked_this_device);

  final FlutterSecureStorage _storage;

  IdentityRepositoryImpl(this._storage);

  @override
  Future<List<IdentityProfile>> getProfiles() async {
    final json = await _storage.read(key: _profilesKey, iOptions: _iosOptions);
    if (json == null) {
      final defaults = _createDefaultProfiles();
      await _saveProfiles(defaults);
      return defaults;
    }
    try {
      final list = jsonDecode(json) as List;
      final profiles = list.map((e) => IdentityProfile.fromJson(e as Map<String, dynamic>)).toList();
      // Ensure default profiles always exist
      return _mergeWithDefaults(profiles);
    } catch (_) {
      final defaults = _createDefaultProfiles();
      await _saveProfiles(defaults);
      return defaults;
    }
  }

  @override
  Future<String> getActiveProfileId() async {
    final id = await _storage.read(key: _activeProfileKey, iOptions: _iosOptions);
    return id ?? 'private';
  }

  @override
  Future<void> setActiveProfileId(String profileId) async {
    await _storage.write(key: _activeProfileKey, value: profileId, iOptions: _iosOptions);
  }

  @override
  Future<void> saveProfile(IdentityProfile profile) async {
    final profiles = await getProfiles();
    final idx = profiles.indexWhere((p) => p.id == profile.id);
    if (idx >= 0) {
      profiles[idx] = profile;
    } else {
      profiles.add(profile);
    }
    await _saveProfiles(profiles);
  }

  @override
  Future<void> deleteProfile(String profileId) async {
    const predefined = {'private', 'work', 'proxy'};
    if (predefined.contains(profileId)) return;
    final profiles = await getProfiles();
    profiles.removeWhere((p) => p.id == profileId);
    await _saveProfiles(profiles);
    // If active profile was deleted, switch to private
    final activeId = await getActiveProfileId();
    if (activeId == profileId) {
      await setActiveProfileId('private');
    }
  }

  @override
  Future<void> applyVerifiedDob(String dateOfBirth) async {
    final profiles = await getProfiles();
    final updated = profiles.map((profile) {
      final hasDob = profile.fields.any((f) => f.key == IdentityFieldKey.dateOfBirth);
      if (!hasDob) return profile;
      final updatedFields = profile.fields.map((f) {
        if (f.key == IdentityFieldKey.dateOfBirth) {
          return f.copyWith(value: dateOfBirth, isLocked: true);
        }
        return f;
      }).toList();
      return profile.copyWith(fields: updatedFields);
    }).toList();
    await _saveProfiles(updated);
  }

  @override
  Future<void> applyVerifiedIdentity(Map<String, dynamic> data) async {
    final profiles = await getProfiles();
    if (kDebugMode) {
      debugPrint('[applyVerifiedIdentity] profiles count: ${profiles.length}, '
          'types: ${profiles.map((p) => p.type.key).toList()}');
    }
    final dob = data['dob'] as String? ?? '';
    final firstName = data['first_name'] as String? ?? '';
    final lastName = data['last_name'] as String? ?? '';
    final pesel = data['pesel_masked'] as String? ?? '';
    final address = data['address'] as Map<String, dynamic>?;

    final updated = profiles.map((profile) {
      if (profile.type == IdentityProfileType.custom) return profile;

      final updatedFields = profile.fields.map((f) {
        switch (f.key) {
          case IdentityFieldKey.dateOfBirth:
            return f.copyWith(value: dob, isLocked: true);
          case IdentityFieldKey.peselMasked:
            return f.copyWith(value: pesel, isLocked: true);
          case IdentityFieldKey.firstName:
            if (profile.type == IdentityProfileType.private ||
                profile.type == IdentityProfileType.work) {
              return f.copyWith(value: firstName, isLocked: true);
            }
            return f;
          case IdentityFieldKey.lastName:
            if (profile.type == IdentityProfileType.private ||
                profile.type == IdentityProfileType.work) {
              return f.copyWith(value: lastName, isLocked: true);
            }
            return f;
          case IdentityFieldKey.addressCity:
            if (profile.type != IdentityProfileType.proxy) {
              return f.copyWith(value: address?['city'] as String? ?? '', isLocked: true);
            }
            return f;
          case IdentityFieldKey.addressStreet:
            if (profile.type != IdentityProfileType.proxy) {
              return f.copyWith(value: address?['street'] as String? ?? '', isLocked: true);
            }
            return f;
          case IdentityFieldKey.addressPostalCode:
            if (profile.type != IdentityProfileType.proxy) {
              return f.copyWith(value: address?['postal_code'] as String? ?? '', isLocked: true);
            }
            return f;
          default:
            return f;
        }
      }).toList();
      return profile.copyWith(fields: updatedFields);
    }).toList();

    await _saveProfiles(updated);
    if (kDebugMode) {
      for (final p in updated) {
        debugPrint('[applyVerifiedIdentity] ${p.type.key}: ${p.fields.map((f) => f.key).toList()}');
      }
    }
  }

  List<IdentityField> _getDefaultFieldsForType(IdentityProfileType type) {
    switch (type) {
      case IdentityProfileType.private:
        return IdentityProfile.defaultPrivate().fields;
      case IdentityProfileType.work:
        return IdentityProfile.defaultWork().fields;
      case IdentityProfileType.proxy:
        return IdentityProfile.defaultProxy().fields;
      case IdentityProfileType.custom:
        return [];
    }
  }

  Future<void> _saveProfiles(List<IdentityProfile> profiles) async {
    final json = jsonEncode(profiles.map((p) => p.toJson()).toList());
    await _storage.write(key: _profilesKey, value: json, iOptions: _iosOptions);
  }

  List<IdentityProfile> _createDefaultProfiles() => [
        IdentityProfile.defaultPrivate(),
        IdentityProfile.defaultWork(),
        IdentityProfile.defaultProxy(),
      ];

  /// Ensure the 3 predefined profiles are always present.
  /// Migrates legacy 'fake' profile to 'proxy', and old 'address' field to 3 separate fields.
  List<IdentityProfile> _mergeWithDefaults(List<IdentityProfile> profiles) {
    // Migrate legacy 'fake' profile
    final fakeIdx = profiles.indexWhere((p) => p.id == 'fake');
    if (fakeIdx >= 0) {
      profiles.removeAt(fakeIdx);
    }

    // Migrate old single 'address' field → addressCity, addressStreet, addressPostalCode
    profiles = profiles.map((profile) {
      final hasOldAddress = profile.fields.any((f) => f.key == 'address');
      final hasNewAddress = profile.fields.any((f) => f.key == IdentityFieldKey.addressCity);
      if (hasOldAddress && !hasNewAddress) {
        final filtered = profile.fields.where((f) => f.key != 'address').toList();
        final defaults = _getDefaultFieldsForType(profile.type);
        final newFields = defaults.where((f) => [
          IdentityFieldKey.addressCity,
          IdentityFieldKey.addressStreet,
          IdentityFieldKey.addressPostalCode,
          IdentityFieldKey.peselMasked,
        ].contains(f.key));
        return profile.copyWith(fields: [...filtered, ...newFields]);
      }
      // Add peselMasked if missing (new field in this version)
      final hasPesel = profile.fields.any((f) => f.key == IdentityFieldKey.peselMasked);
      if (!hasPesel && (profile.type == IdentityProfileType.private || profile.type == IdentityProfileType.work)) {
        final defaults = _getDefaultFieldsForType(profile.type);
        final peselDefault = defaults.where((f) => f.key == IdentityFieldKey.peselMasked).toList();
        return profile.copyWith(fields: [...profile.fields, ...peselDefault]);
      }
      return profile;
    }).toList();

    final ids = profiles.map((p) => p.id).toSet();
    if (!ids.contains('private')) profiles.insert(0, IdentityProfile.defaultPrivate());
    if (!ids.contains('work')) {
      final privateIdx = profiles.indexWhere((p) => p.id == 'private');
      profiles.insert(privateIdx + 1, IdentityProfile.defaultWork());
    }
    if (!ids.contains('proxy')) {
      final workIdx = profiles.indexWhere((p) => p.id == 'work');
      profiles.insert(workIdx + 1, IdentityProfile.defaultProxy());
    }
    return profiles;
  }
}

/// Creates a new custom profile with a user-provided name.
IdentityProfile createCustomProfile(String displayName) {
  const _uuid = Uuid();
  return IdentityProfile(
    id: _uuid.v4(),
    displayName: displayName,
    type: IdentityProfileType.custom,
    fields: [
      IdentityField(
        key: IdentityFieldKey.firstName,
        label: IdentityFieldKey.label(IdentityFieldKey.firstName),
        value: '',
      ),
      IdentityField(
        key: IdentityFieldKey.lastName,
        label: IdentityFieldKey.label(IdentityFieldKey.lastName),
        value: '',
      ),
      IdentityField(
        key: IdentityFieldKey.email,
        label: IdentityFieldKey.label(IdentityFieldKey.email),
        value: '',
      ),
      IdentityField(
        key: IdentityFieldKey.phone,
        label: IdentityFieldKey.label(IdentityFieldKey.phone),
        value: '',
      ),
    ],
  );
}
