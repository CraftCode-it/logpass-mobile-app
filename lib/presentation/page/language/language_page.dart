import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logpass_me/domain/language/language_code.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/language/language_page_cubit.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/separator.dart';

class LanguagePage extends HookWidget {
  const LanguagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<LanguagePageCubit>();
    final state = useCubitBuilder(cubit);
    final colors = useAppThemeColors();

    useEffect(() {
      cubit.initialize();
    }, [cubit]);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: CustomAppBar.smallTitle(
        leading: NavigationButton.back(),
        title: LocaleKeys.language_title.tr(),
      ),
      body: state.maybeMap(
        loading: (_) => const Loader(),
        idle: (state) => _Content(
          onLanguageTap: (language) => cubit.changeLanguage(language),
          selectedLanguageCode: state.languageCode,
        ),
        orElse: () => const SizedBox(),
      ),
    );
  }
}

class _Content extends HookWidget {
  final Function(String languageCode) onLanguageTap;
  final String selectedLanguageCode;

  const _Content({
    required this.onLanguageTap,
    required this.selectedLanguageCode,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final availableLanguages = useMemoized(
      () => availableLocales.entries.map(_Language.fromEntry).toList(growable: false),
      [],
    );

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l, vertical: AppDimens.m),
      itemBuilder: (context, index) => _LanguageRow(
        language: availableLanguages[index],
        selected: availableLanguages[index].code == selectedLanguageCode,
        onTap: () {
          EasyLocalization.of(context)?.setLocale(Locale(availableLanguages[index].code));
          onLanguageTap(availableLanguages[index].code);
        },
      ),
      itemCount: availableLanguages.length,
    );
  }
}

class _LanguageRow extends HookWidget {
  final _Language language;
  final bool selected;
  final Function() onTap;

  const _LanguageRow({
    required this.language,
    required this.selected,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: selected ? null : onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppDimens.l),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    language.name,
                    style: typography.body1,
                  ),
                ),
                if (selected) SvgPicture.asset(AppIcon.check),
              ],
            ),
          ),
        ),
        Separator.light(),
      ],
    );
  }
}

class _Language {
  final String name;
  final String code;

  _Language._(this.name, this.code);

  static _Language fromEntry(MapEntry<LanguageCode, Locale> entry) {
    return _Language._(_mapCodeToLanguageName(entry.key), entry.value.languageCode);
  }

  static String _mapCodeToLanguageName(LanguageCode code) {
    switch (code) {
      case LanguageCode.en:
        return LocaleKeys.language_supportedLanguages_english.tr();
      case LanguageCode.pl:
        return LocaleKeys.language_supportedLanguages_polish.tr();
    }
  }
}
