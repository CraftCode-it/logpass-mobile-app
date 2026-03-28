import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/core/di/di_config.dart';
import 'package:logpass_me/domain/guardian/guardian_repository.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';

enum GuardianApprovalType { pairing, authRequest }

@RoutePage()
class GuardianApprovalPage extends HookWidget {
  final String requestId;
  final GuardianApprovalType approvalType;
  final String minorName;
  final String? minorPhone;
  final String? serviceName;
  final String? action;
  final int expiresInSeconds;

  const GuardianApprovalPage({
    Key? key,
    required this.requestId,
    required this.approvalType,
    required this.minorName,
    this.minorPhone,
    this.serviceName,
    this.action,
    this.expiresInSeconds = 300,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();
    final isProcessing = useState(false);
    final resultMessage = useState<String?>(null);
    final isSuccess = useState(false);
    final secondsLeft = useState(expiresInSeconds);

    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (secondsLeft.value > 0) {
          secondsLeft.value--;
        } else {
          t.cancel();
          if (resultMessage.value == null) {
            resultMessage.value = 'Żądanie wygasło.';
            isSuccess.value = false;
          }
        }
      });
      return timer.cancel;
    }, []);

    final minutes = secondsLeft.value ~/ 60;
    final secs = (secondsLeft.value % 60).toString().padLeft(2, '0');
    final timeLabel = '$minutes:$secs';

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: colors.text),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          approvalType == GuardianApprovalType.pairing
              ? 'Prośba o opiekę'
              : 'Żądanie autoryzacji',
          style: typography.h6.copyWith(color: colors.text),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: resultMessage.value != null
            ? _ResultView(
                message: resultMessage.value!,
                success: isSuccess.value,
                colors: colors,
                typography: typography,
                onDone: () => Navigator.of(context).pop(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timer
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: secondsLeft.value < 60
                            ? AppColors.error100.withOpacity(0.1)
                            : colors.secondaryBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: secondsLeft.value < 60
                              ? AppColors.error100.withOpacity(0.4)
                              : colors.dividerMedium,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.timer,
                            color: secondsLeft.value < 60 ? AppColors.error100 : colors.secondaryText,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            timeLabel,
                            style: typography.h4.copyWith(
                              color: secondsLeft.value < 60 ? AppColors.error100 : colors.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Info card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colors.secondaryBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors.dividerMedium),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person, color: colors.secondaryText),
                            const SizedBox(width: 8),
                            Text('Podopieczny', style: typography.info2.copyWith(color: colors.labelText)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(minorName, style: typography.h6),
                        if (minorPhone != null) ...[
                          const SizedBox(height: 2),
                          Text(minorPhone!, style: typography.body2.copyWith(color: colors.secondaryText)),
                        ],
                        if (approvalType == GuardianApprovalType.authRequest) ...[
                          const Divider(height: 24),
                          Row(
                            children: [
                              Icon(Icons.business, color: colors.secondaryText),
                              const SizedBox(width: 8),
                              Text('Serwis', style: typography.info2.copyWith(color: colors.labelText)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(serviceName ?? '', style: typography.h8),
                          if (action != null) ...[
                            const SizedBox(height: 8),
                            Text(action!, style: typography.body2.copyWith(color: colors.secondaryText)),
                          ],
                        ],
                      ],
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: OutlinedButton(
                            onPressed: isProcessing.value ? null : () => _reject(context, isProcessing, resultMessage, isSuccess),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppColors.error100),
                              foregroundColor: AppColors.error100,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text('Odrzuć', style: typography.h8.copyWith(color: AppColors.error100)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: isProcessing.value ? null : () => _approve(context, isProcessing, resultMessage, isSuccess),
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
                  const SizedBox(height: 24),
                ],
              ),
      ),
    );
  }

  Future<void> _approve(
    BuildContext context,
    ValueNotifier<bool> isProcessing,
    ValueNotifier<String?> resultMessage,
    ValueNotifier<bool> isSuccess,
  ) async {
    isProcessing.value = true;
    try {
      final repo = getIt<GuardianRepository>();
      if (approvalType == GuardianApprovalType.pairing) {
        await repo.confirmGuardian(requestId);
        resultMessage.value = 'Parowanie zaakceptowane. $minorName jest teraz Twoim podopiecznym.';
      } else {
        await repo.approveAuthorization(requestId);
        resultMessage.value = 'Autoryzacja zatwierdzona dla ${serviceName ?? "serwisu"}.';
      }
      isSuccess.value = true;
    } catch (e) {
      isSuccess.value = false;
      resultMessage.value = 'Błąd: $e';
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> _reject(
    BuildContext context,
    ValueNotifier<bool> isProcessing,
    ValueNotifier<String?> resultMessage,
    ValueNotifier<bool> isSuccess,
  ) async {
    isProcessing.value = true;
    try {
      final repo = getIt<GuardianRepository>();
      if (approvalType == GuardianApprovalType.pairing) {
        await repo.rejectGuardian(requestId);
        resultMessage.value = 'Parowanie odrzucone.';
      } else {
        await repo.rejectAuthorization(requestId);
        resultMessage.value = 'Autoryzacja odrzucona.';
      }
      isSuccess.value = true;
    } catch (e) {
      isSuccess.value = false;
      resultMessage.value = 'Błąd: $e';
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
            success ? 'Gotowe' : 'Błąd',
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
              child: Text('Zamknij', style: typography.h8.copyWith(color: colors.buttonFilledText)),
            ),
          ),
        ],
      ),
    );
  }
}
