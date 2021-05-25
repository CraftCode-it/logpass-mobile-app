import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:logpass_me/core/available_locales.dart';
import 'package:logpass_me/generated/local_keys.g.dart';

class EntryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            final differentLocale = availableLocales.entries
                .where((element) => element.value != context.locale)
                .first
                .value;
            context.setLocale(differentLocale);
          },
          child: const Text(LocaleKeys.appName).tr(),
        ),
      ),
    );
  }
}
