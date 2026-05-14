import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/core/di/di_config.dart';
import 'package:logpass_me/domain/auth/use_case/get_user_tokens_use_case.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:qr_flutter/qr_flutter.dart';

@RoutePage()
class GuardianShowQrPage extends HookWidget {
  const GuardianShowQrPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();
    final userId = useState<String?>(null);

    useEffect(() {
      Future<void> load() async {
        try {
          final tokens = await getIt<GetUserTokensUseCase>()();
          userId.value = tokens.sub;
        } catch (_) {}
      }
      load();
      return null;
    }, const []);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.text),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          LocaleKeys.guardian_showQrTitle.tr(),
          style: typography.h6.copyWith(color: colors.text),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppDimens.xxl),
              Text(
                LocaleKeys.guardian_showQrDescription.tr(),
                style: typography.body1.copyWith(color: colors.secondaryText),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimens.xxl),
              if (userId.value == null)
                const CircularProgressIndicator(color: AppColors.primary100)
              else ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: QrImageView(
                    data: userId.value!,
                    version: QrVersions.auto,
                    size: 220,
                  ),
                ),
                const SizedBox(height: AppDimens.l),
                SelectableText(
                  userId.value!,
                  style: typography.info2.copyWith(
                    color: colors.secondaryText,
                    fontFamily: 'monospace',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimens.m),
                OutlinedButton.icon(
                  icon: Icon(Icons.copy, size: 16, color: colors.text),
                  label: Text(
                    LocaleKeys.settingsLogPassId_copyButton.tr(),
                    style: typography.body1.copyWith(color: colors.text),
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: userId.value!));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(LocaleKeys.settingsLogPassId_copiedMessage.tr()),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colors.dividerMedium),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
