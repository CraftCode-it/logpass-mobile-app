import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/core/crypto/key_provider.dart';
import 'package:logpass_me/core/di/di_config.dart';
import 'package:logpass_me/data/wallet/wallet_api_data_source.dart';
import 'package:logpass_me/domain/auth/use_case/get_user_tokens_use_case.dart';
import 'package:logpass_me/domain/guardian/guardian_repository.dart';
import 'package:logpass_me/domain/wallet/wallet_repository.dart';
import 'package:logpass_me/presentation/page/guardian/guardian_authorization_dialog.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';

@RoutePage()
class VerificationRequestPage extends HookWidget {
  final String? requestId;
  final String? verifierName;
  final String? requestType;
  final int? minAge;

  const VerificationRequestPage({
    Key? key,
    this.requestId,
    this.verifierName,
    this.requestType,
    this.minAge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();
    final isProcessing = useState(false);
    final resultMessage = useState<String?>(null);
    final isSuccess = useState(false);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: colors.text),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Żądanie weryfikacji', style: typography.h6.copyWith(color: colors.text)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: resultMessage.value != null
            ? _ResultView(
                message: resultMessage.value!,
                success: isSuccess.value,
                colors: colors,
                typography: typography,
                onDone: () => Navigator.of(context).pop(true),
              )
            : SingleChildScrollView(
                child: Column(
                children: [
                  const SizedBox(height: 32),
                      Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: colors.secondaryBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors.dividerMedium),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.shield, size: 48, color: colors.text),
                        const SizedBox(height: 16),
                        Text(
                          verifierName ?? 'Nieznany weryfikator',
                          style: typography.h4,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'żąda weryfikacji',
                          style: typography.body1.copyWith(color: colors.secondaryText),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  _RequestDetail(
                    icon: Icons.verified_user,
                    title: 'Typ weryfikacji',
                    value: requestType == 'identity'
                        ? 'Tożsamość'
                        : requestType == 'age_18'
                            ? 'Wiek 18+'
                            : requestType ?? 'Weryfikacja wieku',
                    colors: colors,
                    typography: typography,
                  ),
                  if (requestType != 'identity') ...[
                    const SizedBox(height: 16),
                    _RequestDetail(
                      icon: Icons.cake,
                      title: 'Minimalny wiek',
                      value: '${minAge ?? 18}+',
                      colors: colors,
                      typography: typography,
                    ),
                  ],
                  const SizedBox(height: 16),
                  _RequestDetail(
                    icon: Icons.privacy_tip,
                    title: 'Udostępniane dane',
                    value: requestType == 'identity'
                        ? 'Tylko potwierdzenie tożsamości\nBez ujawniania danych osobowych'
                        : 'Tylko dowód ZK\nBez ujawniania danych osobowych',
                    colors: colors,
                    typography: typography,
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: isProcessing.value
                          ? null
                          : () => _showPairingCodeDialog(context),
                      icon: Icon(Icons.tag, color: colors.secondaryText),
                      label: Text(
                        'Pokaż kod parowania',
                        style: typography.h8.copyWith(color: colors.secondaryText),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: colors.dividerMedium),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: OutlinedButton(
                            onPressed: isProcessing.value ? null : () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: colors.buttonOutlined),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text('Odmów', style: typography.h8.copyWith(color: colors.buttonOutlinedText)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: isProcessing.value
                                ? null
                                : () {
                                    if (requestType == 'identity') {
                                      _approveIdentity(
                                        isProcessing: isProcessing,
                                        resultMessage: resultMessage,
                                        isSuccess: isSuccess,
                                      );
                                    } else {
                                      _approve(
                                        context: context,
                                        isProcessing: isProcessing,
                                        resultMessage: resultMessage,
                                        isSuccess: isSuccess,
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.success100,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: isProcessing.value
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : Text('Zatwierdź', style: typography.h8.copyWith(color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              ),
      ),
    );
  }

  Future<void> _showPairingCodeDialog(BuildContext context) async {
    final repo = getIt<WalletRepository>();
    String? code;
    String? error;
    try {
      code = await repo.registerPairingCode();
    } catch (e) {
      error = e.toString();
    }
    if (!context.mounted) return;
    showDialog<void>(
      context: context,
      builder: (ctx) => _PairingCodeDialog(code: code, error: error),
    );
  }

  Future<void> _approve({
    required BuildContext context,
    required ValueNotifier<bool> isProcessing,
    required ValueNotifier<String?> resultMessage,
    required ValueNotifier<bool> isSuccess,
  }) async {
    isProcessing.value = true;
    try {
      final keyProvider = getIt<KeyProvider>();
      final repo = getIt<WalletRepository>();
      final api = getIt<WalletApiDataSource>();
      final getUserTokens = getIt<GetUserTokensUseCase>();

      final pubkey = await keyProvider.getUserPubkeyHex();
      String? userId;
      try {
        final tokens = await getUserTokens();
        userId = tokens.sub;
      } catch (_) {}

      final credential = await repo.requestAgeVerification(
        userPubkey: pubkey,
        minAge: minAge ?? 18,
      );

      // F5: Block forced credentials — user is a minor, require guardian authorization
      if (credential.forced) {
        isProcessing.value = false;

        // F8: Show guardian authorization dialog
        final approved = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) => GuardianAuthorizationDialog(
            serviceName: verifierName ?? 'Weryfikator',
            action: 'age_verification_${minAge ?? 18}',
            verifierName: verifierName,
          ),
        );

        if (approved == true) {
          // Guardian approved — proceed with proof
          isProcessing.value = true;
          final proof = await repo.generateProof(credential.id);
          if (requestId != null) {
            await api.fulfillRequest(
              requestId: requestId!,
              zkProof: proof['zk_proof'] as String? ?? '',
              zkPublicInputs: (proof['zk_public_inputs'] is List)
                  ? (proof['zk_public_inputs'] as List).map((e) => e.toString()).toList()
                  : <String>[],
              userId: userId,
            );
          }
          isSuccess.value = true;
          resultMessage.value =
              'Weryfikacja zatwierdzona przez opiekuna!\nDowód ZK przesłany do ${verifierName ?? 'weryfikatora'}.';
        } else {
          isSuccess.value = false;
          resultMessage.value =
              'Poświadczenie odrzucone — wiek poniżej ${minAge ?? 18} lat.\n'
              'Opiekun odmówił lub czas oczekiwania upłynął.';
        }
        return;
      }

      final proof = await repo.generateProof(credential.id);

      if (requestId != null) {
        await api.fulfillRequest(
          requestId: requestId!,
          zkProof: proof['zk_proof'] as String? ?? '',
          zkPublicInputs: (proof['zk_public_inputs'] is List)
              ? (proof['zk_public_inputs'] as List).map((e) => e.toString()).toList()
              : <String>[],
          userId: userId,
        );
      }

      isSuccess.value = true;
      resultMessage.value = 'Weryfikacja zatwierdzona!\nDowód ZK przesłany do ${verifierName ?? 'weryfikatora'}.';
    } catch (e) {
      isSuccess.value = false;
      if (e is DioException && e.response?.statusCode == 409) {
        resultMessage.value = 'Żądanie wygasło.\nZeskanuj ponownie kod QR.';
      } else {
        resultMessage.value = 'Weryfikacja nieudana:\n$e';
      }
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> _approveIdentity({
    required ValueNotifier<bool> isProcessing,
    required ValueNotifier<String?> resultMessage,
    required ValueNotifier<bool> isSuccess,
  }) async {
    isProcessing.value = true;
    try {
      final api = getIt<WalletApiDataSource>();
      final getUserTokens = getIt<GetUserTokensUseCase>();
      String? userId;
      try {
        final tokens = await getUserTokens();
        userId = tokens.sub;
      } catch (_) {}
      if (requestId != null) {
        await api.fulfillIdentityRequest(requestId: requestId!, userId: userId);
      }
      isSuccess.value = true;
      resultMessage.value =
          'Tożsamość udostępniona serwisowi ${verifierName ?? "weryfikator"}.';
    } catch (e) {
      isSuccess.value = false;
      if (e is DioException && e.response?.statusCode == 409) {
        resultMessage.value = 'Żądanie wygasło.\nZeskanuj ponownie kod QR.';
      } else {
        resultMessage.value = 'Weryfikacja tożsamości nieudana:\n$e';
      }
    } finally {
      isProcessing.value = false;
    }
  }
}

class _ResultView extends StatelessWidget {
  final String message;
  final bool success;
  final AppThemeColors colors;
  final AppTypography typography;
  final VoidCallback onDone;

  const _ResultView({
    required this.message,
    required this.success,
    required this.colors,
    required this.typography,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            success ? Icons.check_circle : Icons.error_outline,
            size: 80,
            color: success ? AppColors.success100 : AppColors.error100,
          ),
          const SizedBox(height: 24),
          Text(
            success ? 'Sukces' : 'Błąd',
            style: typography.h3.copyWith(
              color: success ? AppColors.success100 : AppColors.error100,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: typography.body1.copyWith(color: colors.secondaryText),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: 200,
            height: 48,
            child: ElevatedButton(
              onPressed: onDone,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.buttonFill,
                foregroundColor: colors.buttonFilledText,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Gotowe', style: typography.h8.copyWith(color: colors.buttonFilledText)),
            ),
          ),
        ],
      ),
    );
  }
}

class _PairingCodeDialog extends StatefulWidget {
  final String? code;
  final String? error;

  const _PairingCodeDialog({this.code, this.error});

  @override
  State<_PairingCodeDialog> createState() => _PairingCodeDialogState();
}

class _PairingCodeDialogState extends State<_PairingCodeDialog> {
  late int _secondsLeft;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _secondsLeft = 5 * 60;
    if (widget.code != null) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() {
          if (_secondsLeft > 0) {
            _secondsLeft--;
          } else {
            _timer?.cancel();
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final m = _secondsLeft ~/ 60;
    final s = _secondsLeft % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Kod parowania'),
      content: widget.error != null
          ? Text('Błąd: ${widget.error}')
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.code ?? '',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _secondsLeft > 0 ? 'Ważny przez: $_formattedTime' : 'Wygasł',
                  style: TextStyle(
                    color: _secondsLeft > 0 ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Wpisz ten kod w polu "Kod z aplikacji" na stronie weryfikacji.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
      actions: [
        if (widget.code != null)
          TextButton.icon(
            icon: const Icon(Icons.copy, size: 16),
            label: const Text('Kopiuj'),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: widget.code!));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kod skopiowany')),
              );
            },
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Zamknij'),
        ),
      ],
    );
  }
}

class _RequestDetail extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final AppThemeColors colors;
  final AppTypography typography;

  const _RequestDetail({
    required this.icon,
    required this.title,
    required this.value,
    required this.colors,
    required this.typography,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: colors.secondaryText),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: typography.info2.copyWith(color: colors.secondaryText)),
                const SizedBox(height: 2),
                Text(value, style: typography.body2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
