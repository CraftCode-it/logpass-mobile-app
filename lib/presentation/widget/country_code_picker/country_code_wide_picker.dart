import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logpass_me/domain/country_code/country_code.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/country_code_picker/country_code_picker_cubit.dart';
import 'package:logpass_me/presentation/widget/country_code_picker/country_code_picker_state.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/input_field.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

const _arrowIconSize = 24.0;

class CountryCodeWidePicker extends HookWidget {
  final Function(CountryCode countryCode) onCountryCodeSelected;

  const CountryCodeWidePicker({
    required this.onCountryCodeSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<CountryCodePickerCubit>();
    final state = useCubitBuilder(cubit);
    final typography = useAppTypography();
    final colors = useAppThemeColors();

    useCubitListener(cubit, (CountryCodePickerCubit cubit, CountryCodePickerState state, context, {controller}) {
      state.maybeWhen(
        selectedEvent: onCountryCodeSelected,
        orElse: () {},
      );
    });

    useEffect(() {
      cubit.initialize(_getSystemLocale());
    }, [cubit]);

    return InkWell(
      onTap: _onPressed(state, context, cubit),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                width: double.infinity,
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    disabledBorder: inputFieldBorder(colors.inputInactiveBorder),
                    hintStyle: typography.h9.copyWith(color: colors.inputHint),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: LocaleKeys.yourData_addressForm_countryHint.tr(),
                  ),
                ),
              ),
              Positioned.fill(
                left: AppDimens.m,
                right: AppDimens.m,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    state.maybeMap(
                      loading: (state) => const SizedBox.shrink(),
                      selected: (state) => Text(
                        state.countryCode.countryName,
                        style: typography.h9.copyWith(color: colors.text),
                      ),
                      orElse: () => const SizedBox.shrink(),
                    ),
                    SvgPicture.asset(
                      AppIcon.chevronDown,
                      color: colors.text,
                      width: _arrowIconSize,
                      height: _arrowIconSize,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Function()? _onPressed(CountryCodePickerState state, BuildContext context, CountryCodePickerCubit cubit) {
    return state.maybeMap(
      selected: (state) {
        return () async {
          final selectedCountry = await AutoRouter.of(context).push<CountryCode?>(
            CountryCodePickerPageRoute(
              countryCodeList: state.countryCodeList,
              selectedCountryCode: state.countryCode,
              includeCountryCodes: false,
            ),
          );

          if (selectedCountry != null) {
            cubit.select(selectedCountry);
          }
        };
      },
      orElse: () => null,
    );
  }
}

String _getSystemLocale() {
  try {
    return Platform.localeName.split('_').last;
  } catch (e, s) {
    Fimber.e('Getting system locale failed', ex: e, stacktrace: s);
    return 'PL';
  }
}
