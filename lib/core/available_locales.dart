import 'dart:ui';

enum LanguageCode { en, pl }

Map<LanguageCode, Locale> availableLocales = {
  LanguageCode.en: const Locale('en'),
  LanguageCode.pl: const Locale('pl'),
};
