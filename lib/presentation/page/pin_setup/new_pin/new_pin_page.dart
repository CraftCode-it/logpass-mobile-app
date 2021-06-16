import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/pin_setup/new_pin/new_pin_page_cubit.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/pin_field.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';

class NewPinPage extends HookWidget {
  const NewPinPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<NewPingPageCubit>();
    final state = useCubitBuilder(cubit);
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          LocaleKeys.newPin_title,
          style: typography.h8,
        ).tr(),
        leading: NavigationButton.close(
          customAction: () => AutoRouter.of(context).popUntilRoot(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppDimens.l),
              Text(
                LocaleKeys.newPin_info,
                textAlign: TextAlign.center,
                style: typography.body1,
              ).tr(),
              const SizedBox(height: AppDimens.xl),
              PinField(onPinChanged: cubit.updatePin),
              const Spacer(flex: 1),
              CustomRectangularButton.filled(
                text: tr(LocaleKeys.common_next),
                onPressed: state.valid ? () => _goToConfirmationPage(context, state.pin) : null,
              ),
              const SizedBox(height: AppDimens.l),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _goToConfirmationPage(BuildContext context, String pin) async {
    final pinSaved = await AutoRouter.of(context).push(ConfirmPinPageRoute(pin: pin));

    if (pinSaved == true) {
      await AutoRouter.of(context).pop(pinSaved);
    }
  }
}
