import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logpass_me/presentation/page/pin_setup/app_pin_config.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:pinput/pin_put/pin_put.dart';

const _singlePinFieldWidth = 44.0;
const _pinFieldMaxWith = 256.0;

class PinField extends HookWidget {
  final Function(String pin) onPinChanged;
  final bool autoFocus;
  final bool showSideIcon;
  final String? pinErrorText;

  const PinField({
    required this.onPinChanged,
    this.autoFocus = true,
    this.showSideIcon = true,
    this.pinErrorText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();
    final isObscured = useState(true);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: AppDimens.l + AppDimens.xs),
        Container(
          constraints: const BoxConstraints(maxWidth: _pinFieldMaxWith),
          child: Column(
            children: [
              PinPut(
                onChanged: onPinChanged,
                fieldsCount: appPinLength,
                fieldsAlignment: MainAxisAlignment.center,
                autofocus: autoFocus,
                eachFieldMargin: const EdgeInsets.symmetric(horizontal: AppDimens.s),
                selectedFieldDecoration: _inputBorder(colors),
                followingFieldDecoration: _inputBorder(colors),
                submittedFieldDecoration: _inputBorder(colors),
                eachFieldPadding: const EdgeInsets.all(AppDimens.m),
                textStyle: typography.h9,
                eachFieldWidth: _singlePinFieldWidth,
                obscureText: isObscured.value ? '*' : null,
              ),
              if (pinErrorText != null) ...[
                const SizedBox(height: AppDimens.s),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: AppDimens.m),
                    child: Text(
                      pinErrorText!,
                      textAlign: TextAlign.left,
                      style: typography.input.copyWith(color: AppColors.error100),
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: AppDimens.s + AppDimens.xs),
          child: Opacity(
            opacity: showSideIcon ? 1 : 0,
            child: IconButton(
              onPressed: showSideIcon ? () => isObscured.value = !isObscured.value : null,
              padding: const EdgeInsets.all(AppDimens.xs),
              constraints: const BoxConstraints(),
              icon: SvgPicture.asset(
                isObscured.value ? AppIcon.passwordEyeHide : AppIcon.passwordEyeShow,
                width: AppDimens.l,
                height: AppDimens.l,
                color: colors.text,
              ),
            ),
          ),
        ),
      ],
    );
  }

  BoxDecoration _inputBorder(AppThemeColors colors) {
    return BoxDecoration(
      border: Border.all(
        color: pinErrorText != null ? AppColors.error100 : colors.inputFocusedBorder,
        width: 1.0,
      ),
    );
  }
}
