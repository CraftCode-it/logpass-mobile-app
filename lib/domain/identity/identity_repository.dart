import 'package:logpass_me/domain/identity/identity_profile.dart';

abstract class IdentityRepository {
  /// Returns all profiles; creates defaults if none exist.
  Future<List<IdentityProfile>> getProfiles();

  /// Returns the currently active profile ID (defaults to 'private').
  Future<String> getActiveProfileId();

  /// Sets the active profile by ID.
  Future<void> setActiveProfileId(String profileId);

  /// Saves (creates or updates) a profile.
  Future<void> saveProfile(IdentityProfile profile);

  /// Deletes a profile by ID. Predefined profiles (private/work/proxy) cannot be deleted.
  Future<void> deleteProfile(String profileId);

  /// Applies DOB value (from mObywatel verification) to all profiles that have a dateOfBirth field.
  Future<void> applyVerifiedDob(String dateOfBirth);
}
