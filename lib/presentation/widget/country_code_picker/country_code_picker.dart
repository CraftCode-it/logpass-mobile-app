import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/country_code/country_code.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/utils/country_flag.dart';
import 'package:logpass_me/presentation/widget/country_code_picker/country_code_picker_cubit.dart';
import 'package:logpass_me/presentation/widget/country_code_picker/country_code_picker_state.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/input_field.dart';

const _width = 110.0;

class CountryCodePicker extends HookWidget {
  final Function(CountryCode countryCode) onCountryCodeSelected;

  const CountryCodePicker({
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
                width: _width,
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    disabledBorder: inputFieldBorder(colors.inputInactiveBorder),
                    hintStyle: typography.h9.copyWith(color: colors.inputHint),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Prefix',
                  ),
                ),
              ),
              Positioned.fill(
                left: AppDimens.s,
                right: AppDimens.s,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: state.maybeMap(
                          loading: (state) => const Center(child: CircularProgressIndicator()),
                          selected: (state) => _Selected(countryCode: state.countryCode),
                          orElse: () {},
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_sharp,
                      color: colors.buttonOutlined,
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
              includeCountryCodes: true,
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

class _Selected extends HookWidget {
  final CountryCode countryCode;

  const _Selected({required this.countryCode, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.network(
          countryFlagUrl(countryCode.country, true),
          width: 24,
          height: 24,
        ),
        const SizedBox(width: AppDimens.xxs),
        Text(
          '+${countryCode.code}',
          style: typography.body1,
        ),
      ],
    );
  }
}
