import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/country_code/country_code.dart';
import 'package:logpass_me/presentation/routing/main_router.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/utils/country_flag.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/country_code_picker/country_code_picker_cubit.dart';
import 'package:logpass_me/presentation/widget/country_code_picker/country_code_picker_state.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

const _flagThumbnailSize = 24.0;
const _boxFontSize = 12.0;
const _boxFontHeight = 0.8;
const _boxHeight = 64.0;

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
    final colors = useAppThemeColors();

    useCubitListener<CountryCodePickerCubit, CountryCodePickerState>(
      cubit,
      (cubit, state, context) {
        state.maybeWhen(
          selectedEvent: onCountryCodeSelected,
          orElse: () {},
        );
      },
    );

    useEffect(() {
      cubit.initialize(_getSystemLocale());
    }, [cubit]);

    return GestureDetector(
      onTap: _onPressed(state, context, cubit),
      child: _DecorationBorder(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            state.maybeMap(
              loading: (state) => const Loader(),
              selected: (state) => _Selected(countryCode: state.countryCode),
              orElse: () => const SizedBox.shrink(),
            ),
            const SizedBox(width: AppDimens.xs),
            Icon(
              Icons.keyboard_arrow_down_sharp,
              color: colors.buttonOutlined,
            ),
          ],
        ),
      ),
    );
  }

  Function()? _onPressed(CountryCodePickerState state, BuildContext context, CountryCodePickerCubit cubit) {
    return state.maybeMap(
      selected: (state) {
        return () async {
          final selectedCountry = await AutoRouter.of(context).push<CountryCode?>(
            CountryCodePickerRoute(
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
    final localeName = Platform.localeName;
    if (localeName.isEmpty) return 'PL';
    
    // Handle different formats: "en_US", "en-US", "en_US.UTF-8", "en"
    String cleaned = localeName.split('.').first; // Remove ".UTF-8" suffix
    
    // Try splitting by underscore first (most common)
    if (cleaned.contains('_')) {
      return cleaned.split('_').last.toUpperCase();
    }
    
    // Try splitting by hyphen (iOS format)
    if (cleaned.contains('-')) {
      return cleaned.split('-').last.toUpperCase();
    }
    
    // If no separator, return the string as-is if it's 2 chars (country code)
    if (cleaned.length == 2) {
      return cleaned.toUpperCase();
    }
    
    // Fallback to PL
    return 'PL';
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
        Image.asset(
          countryFlagAssetPath(countryCode.country),
          width: _flagThumbnailSize,
          height: _flagThumbnailSize,
          errorBuilder: (context, _, __) => const SizedBox.shrink(),
        ),
        const SizedBox(width: AppDimens.xs),
        Text(
          '+${countryCode.code}',
          style: typography.body1,
        ),
      ],
    );
  }
}

class _DecorationBorder extends HookWidget {
  final Widget child;

  const _DecorationBorder({required this.child});

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final colors = useAppThemeColors();

    return Stack(
      children: [
        Container(
          height: _boxHeight,
          padding: const EdgeInsets.all(AppDimens.m),
          decoration: BoxDecoration(
            border: Border.all(
              color: colors.inputBorder,
              width: 1,
            ),
            color: Colors.transparent,
          ),
          child: child,
        ),
        Positioned(
          left: AppDimens.s,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.xs),
            color: colors.background,
            child: Text(
              LocaleKeys.common_prefix.tr(),
              style: typography.h9.copyWith(
                color: colors.inputHint,
                fontSize: _boxFontSize,
                height: _boxFontHeight,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
