import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/core/crypto/key_provider.dart';
import 'package:logpass_me/data/wallet/wallet_api_data_source.dart';
import 'package:logpass_me/domain/auth/use_case/get_user_tokens_use_case.dart';
import 'package:logpass_me/domain/identity/identity_field.dart';
import 'package:logpass_me/domain/identity/identity_profile.dart';
import 'package:logpass_me/domain/identity/identity_profile_type.dart';
import 'package:logpass_me/domain/identity/identity_repository.dart';
import 'package:logpass_me/domain/wallet/wallet_repository.dart';
import 'package:logpass_me/presentation/page/wallet/verification_request/verification_request_cubit_state.dart';

export 'verification_request_cubit_state.dart';

@injectable
class VerificationRequestCubit extends Cubit<VerificationRequestState> {
  final IdentityRepository _identityRepository;
  final WalletRepository _walletRepository;
  final WalletApiDataSource _walletApi;
  final GetUserTokensUseCase _getUserTokens;
  final KeyProvider _keyProvider;

  VerificationRequestCubit(
    this._identityRepository,
    this._walletRepository,
    this._walletApi,
    this._getUserTokens,
    this._keyProvider,
  ) : super(const VerificationRequestIdle());

  Future<void> initialize() async {
    try {
      final profiles = await _identityRepository.getProfiles();
      final current = state is VerificationRequestIdle
          ? state as VerificationRequestIdle
          : null;
      final selectedId = current?.selectedProfileId;
      final validId = profiles.any((p) => p.id == selectedId)
          ? selectedId
          : (profiles.isNotEmpty ? profiles.first.id : null);

      final isMinor = await _detectIsMinor(profiles);

      emit(VerificationRequestIdle(
        profiles: profiles,
        selectedProfileId: validId,
        isMinor: isMinor,
      ));
    } catch (_) {
      emit(const VerificationRequestIdle());
    }
  }

  Future<bool> _detectIsMinor(List profiles) async {
    try {
      final privateProfile = profiles
          .where((p) => p.type == IdentityProfileType.private)
          .firstOrNull;
      if (privateProfile == null) return false;
      final dobField = privateProfile.fields
          .where((f) => f.key == IdentityFieldKey.dateOfBirth && f.value.isNotEmpty)
          .firstOrNull;
      if (dobField == null) return false;
      final dob = DateTime.tryParse(dobField.value);
      if (dob == null) return false;
      final now = DateTime.now();
      int age = now.year - dob.year;
      if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) age--;
      return age < 18;
    } catch (_) {
      return false;
    }
  }

  void selectProfile(String id) {
    if (state is! VerificationRequestIdle) return;
    final current = state as VerificationRequestIdle;
    emit(current.copyWith(selectedProfileId: id));
  }

  Future<void> approveAgeVerification({
    required String? requestId,
    required String? verifierName,
    required int? minAge,
    bool guardianApproved = false,
    bool allowGuardian = false,
    bool includeAttributes = false,
  }) async {
    final profileId = state is VerificationRequestIdle
        ? (state as VerificationRequestIdle).selectedProfileId
        : null;
    final attributes = includeAttributes ? _collectSharedAttributes(profileId) : null;
    emit(const VerificationRequestProcessing());

    try {
      final pubkey = await _keyProvider.getUserPubkeyHex();
      String? userId;
      try {
        final tokens = await _getUserTokens();
        userId = tokens.sub;
      } catch (_) {}

      final credential = await _walletRepository.requestAgeVerification(
        userPubkey: pubkey,
        minAge: minAge ?? 18,
      );

      if (credential.forced && !guardianApproved) {
        if (allowGuardian) {
          emit(const VerificationRequestFailure(message: '__guardian_required__'));
        } else {
          emit(VerificationRequestFailure(
            message: 'Odmowa — wiek poniżej ${minAge ?? 18} lat.\n'
                'Ten serwis nie akceptuje zgody opiekuna.',
          ));
        }
        return;
      }

      final proof = await _walletRepository.generateProof(credential.id);

      if (requestId != null) {
        await _walletApi.fulfillRequest(
          requestId: requestId,
          zkProof: proof['zk_proof'] as String? ?? '',
          zkPublicInputs: (proof['zk_public_inputs'] is List)
              ? (proof['zk_public_inputs'] as List).map((e) => e.toString()).toList()
              : <String>[],
          userId: userId,
          profileId: profileId,
          userPubkey: pubkey,
          attributes: attributes,
        );
      }

      emit(VerificationRequestSuccess(
        message:
            'Weryfikacja zatwierdzona!\nDowód ZK przesłany do ${verifierName ?? 'weryfikatora'}.',
      ));
    } catch (e) {
      emit(VerificationRequestFailure(message: _errorMessage(e, 'Weryfikacja nieudana')));
    }
  }

  Map<String, dynamic> _collectSharedAttributes(String? selectedProfileId) {
    final current = state;
    if (current is! VerificationRequestIdle) return {};

    final selectedProfile = current.profiles
        .where((p) => p.id == selectedProfileId)
        .firstOrNull;
    final adultProfile = current.profiles
        .where((p) => p.type == IdentityProfileType.adult)
        .firstOrNull;

    final result = <String, dynamic>{};
    void copyFields(IdentityProfile? profile, {bool overwrite = true}) {
      if (profile == null) return;
      for (final field in profile.fields) {
        final value = field.value.trim();
        if (value.isEmpty) continue;
        if (IdentityFieldKey.adultPreferenceKeys.contains(field.key) ||
            field.key == IdentityFieldKey.firstName ||
            field.key == IdentityFieldKey.lastName ||
            field.key == IdentityFieldKey.dateOfBirth) {
          if (overwrite || !result.containsKey(field.key)) {
            result[field.key] = value;
          }
        }
      }
    }

    copyFields(adultProfile, overwrite: true);
    copyFields(selectedProfile, overwrite: true);
    return result;
  }

  Future<void> approveIdentityVerification({
    required String? requestId,
    required String? verifierName,
  }) async {
    final profileId = state is VerificationRequestIdle
        ? (state as VerificationRequestIdle).selectedProfileId
        : null;
    emit(const VerificationRequestProcessing());

    try {
      String? userId;
      try {
        final tokens = await _getUserTokens();
        userId = tokens.sub;
      } catch (_) {}

      if (requestId != null) {
        await _walletApi.fulfillIdentityRequest(
          requestId: requestId,
          userId: userId,
          profileId: profileId,
        );
      }

      emit(VerificationRequestSuccess(
        message: 'Tożsamość udostępniona serwisowi ${verifierName ?? "weryfikator"}.',
      ));
    } catch (e) {
      emit(VerificationRequestFailure(
          message: _errorMessage(e, 'Weryfikacja tożsamości nieudana')));
    }
  }

  void triggerGuardianRequired(int? minAge) {
    emit(const VerificationRequestFailure(message: '__guardian_required__'));
  }

  void rejectUnderage(int? minAge) {
    emit(VerificationRequestFailure(
      message: 'Odmowa — wiek poniżej ${minAge ?? 18} lat.\n'
               'Ten serwis nie akceptuje zgody opiekuna.',
    ));
  }

  void setGuardianDenied(int? minAge) {
    emit(VerificationRequestFailure(
      message: 'Poświadczenie odrzucone — wiek poniżej ${minAge ?? 18} lat.\n'
          'Opiekun odmówił lub czas oczekiwania upłynął.',
    ));
  }

  String _errorMessage(Object e, String prefix) {
    if (e is DioException && e.response?.statusCode == 409) {
      return 'Żądanie wygasło.\nZeskanuj ponownie kod QR.';
    }
    return '$prefix:\n$e';
  }
}
