import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';

class Separator extends HookWidget {
  final Color Function(AppThemeColors colors) _colorChooser;

  const Separator._(
    this._colorChooser, {
    Key? key,
  }) : super(key: key);

  factory Separator.dark() => Separator._((colors) => colors.dividerDark);

  factory Separator.medium() => Separator._((colors) => colors.dividerMedium);

  factory Separator.light() => Separator._((colors) => colors.dividerLight);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();

    return Container(
      height: AppDimens.dividerHeight,
      color: _colorChooser(colors),
    );
  }
}
