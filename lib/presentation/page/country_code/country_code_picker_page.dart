import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/country_code/country_code.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/separator.dart';

class CountryCodePickerPage extends HookWidget {
  final List<CountryCode> countryCodeList;
  final CountryCode selectedCountryCode;

  const CountryCodePickerPage({
    required this.countryCodeList,
    required this.selectedCountryCode,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        leading: NavigationButton.back(),
        title: Text(
          'Select your country',
          style: typography.h8,
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.only(
          bottom: AppDimens.xc,
          left: AppDimens.l,
          right: AppDimens.l,
        ),
        itemCount: countryCodeList.length,
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimens.s),
          child: Separator.light(),
        ),
        itemBuilder: (context, index) {
          final countryCode = countryCodeList[index];
          return _CountryCodeRow(
            countryCode: countryCode,
            selected: countryCode == selectedCountryCode,
            onPressed: () => AutoRouter.of(context).pop(countryCode),
          );
        },
      ),
    );
  }
}

class _CountryCodeRow extends HookWidget {
  final CountryCode countryCode;
  final bool selected;
  final Function() onPressed;

  const _CountryCodeRow({
    required this.countryCode,
    required this.selected,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final colors = useAppThemeColors();

    return InkWell(
      onTap: onPressed,
      child: Row(
        children: [
          Image.network(
            countryFlagUrl(countryCode, true),
            width: 36,
          ),
          const SizedBox(width: AppDimens.m),
          Expanded(
            flex: 1,
            child: Text(
              '+${countryCode.code}',
              style: typography.info2.copyWith(color: colors.labelText),
            ),
          ),
          const SizedBox(width: AppDimens.xxl),
          Expanded(
            flex: 3,
            child: Text(
              countryCode.country,
              style: typography.body1,
            ),
          ),
          Visibility(
            visible: selected,
            maintainState: true,
            maintainAnimation: true,
            maintainSize: true,
            child: const Icon(Icons.check),
          ),
        ],
      ),
    );
  }
}

String countryFlagUrl(CountryCode countryCode, bool big) {
  final size = big ? '32' : '16';
  return 'https://www.countryflags.io/${countryCode.country.toLowerCase()}/flat/$size.png';
}
