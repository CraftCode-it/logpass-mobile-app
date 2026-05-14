import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/logpass_dialog_base.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';

Future<bool> showTwoOptionsDialog(
  BuildContext context,
  String title,
  String content,
  String topAction,
  String bottomAction,
) async {
  final result = await showModalBottomSheet(
    context: context,
    builder: (context) {
      return LogpassDialogBase(
        child: TwoOptionsDialog(
          title: title,
          content: content,
          topAction: topAction,
          bottomAction: bottomAction,
        ),
      );
    },
  );

  return result == true;
}

class TwoOptionsDialog extends HookWidget {
  final String title;
  final String content;
  final String topAction;
  final String bottomAction;

  const TwoOptionsDialog({
    required this.title,
    required this.content,
    required this.topAction,
    required this.bottomAction,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final colors = useAppThemeColors();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
          fillColor: colors.dialogBackground,
          text: topAction,
          onPressed: () => AutoRouter.of(context).maybePop(true),
        ),
        const SizedBox(height: AppDimens.l),
        CustomRectangularButton.filled(
          text: bottomAction,
          onPressed: () => AutoRouter.of(context).maybePop(false),
        ),
      ],
    );
  }
}

class CustomContentDialog extends StatelessWidget {
  final List<Widget> widgets;

  const CustomContentDialog({required this.widgets, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return widgets[index];
      },
      separatorBuilder: (context, index) => const SizedBox(height: AppDimens.l),
      itemCount: widgets.length,
    );
  }
}
