import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/country_code/country_code.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';

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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Select your country'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(
          bottom: AppDimens.xc,
          left: AppDimens.xxl,
          right: AppDimens.xxl,
        ),
        itemCount: countryCodeList.length,
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

    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          Image.network('https://www.countryflags.io/${countryCode.country.toLowerCase()}/flat/32.png'),
          const SizedBox(width: AppDimens.m),
          Expanded(
            child: Text(
              '+${countryCode.code}',
              style: typography.primary,
            ),
          ),
          const SizedBox(width: AppDimens.xxl),
          Expanded(
            child: Text(
              countryCode.country,
              style: typography.primary,
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
