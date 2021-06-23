import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/theme/theme_brightness.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/custom_switch.dart';
import 'package:logpass_me/presentation/widget/dark_mode_switch/dark_mode_switch_row_cubit.dart';

class DarkModeSwitchRow extends HookWidget {
  const DarkModeSwitchRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<DarkModeSwitchRowCubit>();
    final state = useCubitBuilder(cubit);
    final typography = useAppTypography();
    final systemBrightness = MediaQuery.of(context).platformBrightness;

    useEffect(() {
      cubit.initialize();
    }, [cubit]);

    final brightness = state.maybeMap(
      idle: (state) {
        switch (state.themeBrightness) {
          case ThemeBrightness.light:
            return Brightness.light;
          case ThemeBrightness.dark:
            return Brightness.dark;
          case ThemeBrightness.system:
            return systemBrightness;
        }
      },
      orElse: () => null,
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.l),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              LocaleKeys.settings_darkMode.tr(),
              style: typography.h9,
            ),
          ),
          if (brightness == null)
            const Loader()
          else
            CustomSwitch(
              value: brightness == Brightness.dark,
              onChange: (newValue) {
                if (brightness == Brightness.light) {
                  cubit.changeToDarkMode();
                } else {
                  cubit.changeToLightMode();
                }
              },
            ),
        ],
      ),
    );
  }
}
