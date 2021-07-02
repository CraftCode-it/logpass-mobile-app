import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';

const _dividerWidth = 35.0;
const _dividerHeight = 2.0;

class LogpassDialogBase extends HookWidget {
  final Widget child;

  const LogpassDialogBase({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      color: colors.dialogBackground,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimens.m),
            Center(
              child: Container(
                height: _dividerHeight,
                width: _dividerWidth,
                color: colors.modalHandle,
              ),
            ),
            const SizedBox(height: AppDimens.l),
            child,
            const SizedBox(height: AppDimens.l),
          ],
        ),
      ),
    );
  }
}
