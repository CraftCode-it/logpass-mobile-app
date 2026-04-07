import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/core/di/di_config.dart';
import 'package:logpass_me/domain/auth/use_case/get_user_tokens_use_case.dart';
import 'package:logpass_me/domain/identity/identity_field.dart';
import 'package:logpass_me/domain/identity/identity_profile_type.dart';
import 'package:logpass_me/domain/identity/identity_repository.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/exports.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/settings/settings_page_cubit.dart';
import 'package:logpass_me/presentation/page/settings/settings_page_state.dart';
import 'package:logpass_me/presentation/routing/main_router.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/dark_mode_switch/dark_mode_switch_row.dart';
import 'package:logpass_me/presentation/widget/error_snackbar.dart';
import 'package:logpass_me/presentation/widget/full_screen_loader.dart';
import 'package:logpass_me/presentation/widget/messenger/messenger.dart';
import 'package:logpass_me/presentation/widget/navigation_row.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';
import 'package:logpass_me/presentation/widget/separator.dart';
import 'package:qr_flutter/qr_flutter.dart';

const _logoutBorderSideWidth = 0.5;


@RoutePage()
class SettingsPage extends HookWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<SettingsPageCubit>();
    final colors = useAppThemeColors();
    final messengerController = useMessengerController();

    useCubitListener<SettingsPageCubit, SettingsPageState>(cubit, (cubit, state, context) {
      state.maybeMap(
        loggingOut: (_) {
          showFullScreenLoader(context);
        },
        connectionError: (state) {
          AutoRouter.of(context).popUntil((route) => route.settings.name == MainRoute.name);
          messengerController.showError(getConnectionErrorString(state.error));
        },
        error: (_) {
          AutoRouter.of(context).popUntil((route) => route.settings.name == MainRoute.name);
          messengerController.showError(getConnectionErrorString(GeneralConnectionError.somethingWentWrong()));
        },
        orElse: () {},
      );
    });

    return Scaffold(
      backgroundColor: colors.background,
      appBar: CustomAppBar.bigTitle(
        title: LocaleKeys.settings_title.tr(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Messenger(
                controller: messengerController,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.l, vertical: AppDimens.m),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      NavigationRow.withIcon(
                        AppIcon.device,
                        LocaleKeys.settings_devices.tr(),
                        () => AutoRouter.of(context).push(const DeviceListRoute()),
                      ),
                      Separator.light(),
                      NavigationRow.withIcon(
                        AppIcon.security,
                        LocaleKeys.settings_security.tr(),
                        () => AutoRouter.of(context).push(const SecuritySettingsRoute()),
                      ),
                      Separator.light(),
                      NavigationRow.titled(
                        LocaleKeys.settings_guardians.tr(),
                        () => AutoRouter.of(context).push(const GuardianRoute()),
                      ),
                      Separator.light(),
                      const SizedBox(height: AppDimens.xc),
                      const DarkModeSwitchRow(),
                      Separator.light(),
                      NavigationRow.titled(
                        LocaleKeys.settings_language.tr(),
                        () => AutoRouter.of(context).push(const LanguageRoute()),
                      ),
                      Separator.light(),
                      NavigationRow.titled(
                        LocaleKeys.settings_terms.tr(),
                        () => AutoRouter.of(context).push(const TermsAndConditionsRoute()),
                      ),
                      Separator.light(),
                      NavigationRow.titled(
                        LocaleKeys.settings_help.tr(),
                        () => AutoRouter.of(context).push(const NeedHelpRoute()),
                      ),
                      Separator.light(),
                      const SizedBox(height: AppDimens.xxl),
                      const _LogPassIdSection(),
                      const SizedBox(height: AppDimens.xxl),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.l, vertical: AppDimens.l),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: _logoutBorderSideWidth,
                    color: colors.dividerLight,
                  ),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: CustomRectangularButton.outlined(
                  text: LocaleKeys.settings_logout.tr(),
                  onPressed: () => cubit.logOut(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogPassIdSection extends HookWidget {
  const _LogPassIdSection();

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();
    final userId = useState<String?>(null);
    final isMinor = useState<bool?>(null);

    useEffect(() {
      Future<void> load() async {
        try {
          final tokens = await getIt<GetUserTokensUseCase>()();
          userId.value = tokens.sub;

          final repo = getIt<IdentityRepository>();
          final profiles = await repo.getProfiles();
          final privateProfile = profiles
              .where((p) => p.type == IdentityProfileType.private)
              .firstOrNull;
          if (privateProfile == null) {
            isMinor.value = false;
            return;
          }
          final dobField = privateProfile.fields
              .where((f) => f.key == IdentityFieldKey.dateOfBirth && f.value.isNotEmpty)
              .firstOrNull;
          if (dobField == null) {
            isMinor.value = false;
            return;
          }
          final dob = DateTime.tryParse(dobField.value);
          if (dob == null) {
            isMinor.value = false;
            return;
          }
          final now = DateTime.now();
          int age = now.year - dob.year;
          if (now.month < dob.month ||
              (now.month == dob.month && now.day < dob.day)) age--;
          isMinor.value = age < 18;
        } catch (_) {
          isMinor.value = false;
        }
      }
      load();
      return null;
    }, const []);

    if (isMinor.value == null) return const SizedBox.shrink();
    if (isMinor.value == false) return const SizedBox.shrink();

    final id = userId.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.settingsLogPassId_title.tr(),
          style: typography.h8.copyWith(color: colors.text),
        ),
        const SizedBox(height: 4),
        Text(
          LocaleKeys.settingsLogPassId_description.tr(),
          style: typography.info2.copyWith(color: colors.secondaryText),
        ),
        const SizedBox(height: 16),
        if (id == null)
          Center(
            child: CircularProgressIndicator(color: AppColors.primary100),
          )
        else ...[
          Center(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: QrImageView(
                data: id,
                version: QrVersions.auto,
                size: 180,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: SelectableText(
              id,
              style: typography.info2.copyWith(
                color: colors.secondaryText,
                fontFamily: 'monospace',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: OutlinedButton.icon(
              icon: Icon(Icons.copy, size: 16, color: colors.text),
              label: Text(
                LocaleKeys.settingsLogPassId_copyButton.tr(),
                style: typography.body1.copyWith(color: colors.text),
              ),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: id));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(LocaleKeys.settingsLogPassId_copiedMessage.tr()),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colors.dividerMedium),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
