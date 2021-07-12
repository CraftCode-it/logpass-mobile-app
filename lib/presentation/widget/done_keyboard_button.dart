import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class DoneKeyboardButton extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateColor.resolveWith(
            (states) => colors.text.withOpacity(0.15),
          ),
        ),
        onPressed: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Text(
          LocaleKeys.common_done.tr(),
          style: typography.info1,
        ),
      ),
    );
  }
}
