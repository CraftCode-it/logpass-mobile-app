import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logpass_me/domain/country_code/country_code.dart';
import 'package:logpass_me/exports.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/utils/country_flag.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/input_field.dart';
import 'package:logpass_me/presentation/widget/separator.dart';

const _flagSize = 36.0;
const _rowHeight = 64.0;
const _headerHeight = 48.0;
const _rowWithSeparatorHeight = _rowHeight + 1;

@RoutePage()
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
    final scrollController = useScrollController();
    final searchText = useState('');

    final groupedCountryList = useMemoized(
      () => groupBy(
        countryCodeList.where(
          (element) {
            return element.countryName.toUpperCase().startsWith(
                      searchText.value,
                    ) ||
                element.country.contains(searchText.value);
          },
        ),
        (CountryCode value) => value.countryName[0],
      ),
      [searchText.value],
    );

    useEffect(() {
      final selectedIndex = countryCodeList.indexOf(selectedCountryCode);
      final headers = groupedCountryList.keys.toList();
      final headerIndexIncremented = headers.indexOf(selectedCountryCode.countryName[0]) + 1;
      final scrollOffset = selectedIndex * _rowWithSeparatorHeight + headerIndexIncremented * _headerHeight;

      WidgetsBinding.instance?.addPostFrameCallback((_) {
        scrollController.jumpTo(
          (scrollOffset > MediaQuery.of(context).size.height * 0.5) ? scrollOffset : 0,
        );
      });
    }, [scrollController]);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: CustomAppBar.smallTitle(
        title: LocaleKeys.countryCodePicker_title.tr(),
        leading: NavigationButton.back(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
        child: Column(
          children: [
            const SizedBox(height: AppDimens.s),
            InputField(
              onChanged: (String text) {
                searchText.value = text.toUpperCase();
              },
              label: LocaleKeys.countryCodePicker_search.tr(),
            ),
            const SizedBox(height: AppDimens.s),
            Expanded(
              child: CustomScrollView(
                controller: scrollController,
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
                            child: SizedBox(
                              height: _headerHeight,
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  element[0] as String,
                                  style: typography.body1,
                                ),
                              ),
                            ),
                          ),
                          element[1] as Widget,
                        ],
                      ),
                ],
              ),
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
      child: SizedBox(
        height: _rowHeight,
        child: Row(
          children: [
            Image.asset(
              countryFlagAssetPath(countryCode.country),
              width: _flagSize,
              height: _flagSize,
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
