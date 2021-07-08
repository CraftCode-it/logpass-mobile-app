import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logpass_me/domain/country_code/country_code.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/utils/country_flag.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/separator.dart';

class CountryCodePickerPage extends HookWidget {
  final List<CountryCode> countryCodeList;
  final CountryCode selectedCountryCode;
  final bool includeCountryCodes;

  const CountryCodePickerPage({
    required this.countryCodeList,
    required this.selectedCountryCode,
    required this.includeCountryCodes,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    final groupedCountryList = useMemoized(
      () => groupBy(countryCodeList, (CountryCode value) => value.countryName[0]),
    );

    return Scaffold(
      backgroundColor: colors.background,
      appBar: CustomAppBar.smallTitle(
        title: LocaleKeys.countryCodePicker_title.tr(),
        leading: NavigationButton.back(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
        child: CustomScrollView(
          slivers: [
            ...groupedCountryList.entries
                .map((e) => [
                      e.key,
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final countryCode = e.value[index];
                            return Column(
                              children: [
                                _CountryCodeRow(
                                  countryCode: countryCode,
                                  selected: countryCode == selectedCountryCode,
                                  codeVisible: includeCountryCodes,
                                  onPressed: () => AutoRouter.of(context).pop(countryCode),
                                ),
                                Separator.light(),
                              ],
                            );
                          },
                          childCount: e.value.length,
                        ),
                      ),
                    ])
                .expand(
                  (element) => [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: AppDimens.l),
                        child: Text(
                          element[0] as String,
                          style: typography.body1,
                        ),
                      ),
                    ),
                    element[1] as Widget,
                  ],
                ),
          ],
        ),
      ),
    );
  }
}

class _CountryCodeRow extends HookWidget {
  final CountryCode countryCode;
  final bool selected;
  final Function() onPressed;
  final bool codeVisible;

  const _CountryCodeRow({
    required this.countryCode,
    required this.selected,
    required this.onPressed,
    required this.codeVisible,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final colors = useAppThemeColors();

    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.m),
        child: Row(
          children: [
            Image.network(
              countryFlagUrl(countryCode.country, true),
              width: 36,
              errorBuilder: (context, _, __) => const SizedBox.shrink(),
            ),
            const SizedBox(width: AppDimens.m),
            if (codeVisible) ...[
              Expanded(
                flex: 1,
                child: Text(
                  '+${countryCode.code}',
                  style: typography.info2.copyWith(color: colors.labelText),
                ),
              ),
              const SizedBox(width: AppDimens.m),
            ],
            Expanded(
              flex: 5,
              child: Text(
                countryCode.countryName,
                style: typography.body1,
              ),
            ),
            Visibility(
              visible: selected,
              maintainState: true,
              maintainAnimation: true,
              maintainSize: true,
              child: SvgPicture.asset(AppIcon.check),
            ),
          ],
        ),
      ),
    );
  }
}
