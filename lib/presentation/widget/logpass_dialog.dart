import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';

const _dividerWidth = 35.0;
const _dividerHeight = 2.0;

Future<bool> showTwoOptionsDialog(
  BuildContext context,
  String title,
  String content,
  String topAction,
  String bottomAction,
  AppTypography typography,
  AppThemeColors colors,
) async {
  final result = await showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
        color: colors.secondaryBackground,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: AppDimens.m),
              Center(
                child: Container(
                  height: _dividerHeight,
                  width: _dividerWidth,
                  color: colors.dividerLight,
                ),
              ),
              const SizedBox(height: AppDimens.l),
              Text(
                title,
                style: typography.h8,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimens.m),
              Text(
                content,
                style: typography.body2.copyWith(color: colors.secondaryText),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimens.l),
              CustomRectangularButton.outlined(
                fillColor: colors.secondaryBackground,
                text: topAction,
                onPressed: () => AutoRouter.of(context).pop(true),
              ),
              const SizedBox(height: AppDimens.l),
              CustomRectangularButton.filled(
                text: bottomAction,
                onPressed: () => AutoRouter.of(context).pop(false),
              ),
              const SizedBox(height: AppDimens.l),
            ],
          ),
        ),
      );
    },
  );

  return result == true;
}

Future<void> showCustomContentDialog(
  BuildContext context,
  List<Widget> widgets,
  AppThemeColors colors,
) async {
  await showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
        color: colors.secondaryBackground,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: AppDimens.m),
              Center(
                child: Container(
                  height: _dividerHeight,
                  width: _dividerWidth,
                  color: colors.dividerDark,
                ),
              ),
              const SizedBox(height: AppDimens.l),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return widgets[index];
                },
                separatorBuilder: (context, index) => const SizedBox(height: AppDimens.l),
                itemCount: widgets.length,
              ),
              const SizedBox(height: AppDimens.l),
            ],
          ),
        ),
      );
    },
  );
}
