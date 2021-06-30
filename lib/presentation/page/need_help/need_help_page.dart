import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logpass_me/domain/need_help/need_help.dart';
import 'package:logpass_me/domain/need_help/need_help_factory.dart';
import 'package:logpass_me/domain/need_help/question.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';
import 'package:logpass_me/presentation/widget/version_info/version_info.dart';

const _arrowIconSize = 24.0;

class NeedHelpPage extends HookWidget {
  const NeedHelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();

    final needHelp = useMemoized(() {
      return NeedHelpFactory.createObject();
    });

    return Scaffold(
      backgroundColor: colors.background,
      appBar: CustomAppBar.smallTitle(
        title: LocaleKeys.needHelp_title.tr(),
        leading: NavigationButton.back(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppDimens.m),
              _AboutSection(needHelp),
              const SizedBox(height: AppDimens.xc),
              _QuestionsSection(needHelp),
              const SizedBox(height: AppDimens.xc),
              _ApplicationVersionInfo(),
              const SizedBox(height: AppDimens.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _ApplicationVersionInfo extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    return Row(
      children: [
        Text(
          LocaleKeys.needHelp_appVersion.tr(),
          style: typography.info2.copyWith(
            color: colors.labelText,
          ),
        ),
        VersionInfo(),
      ],
    );
  }
}

class _QuestionsSection extends StatelessWidget {
  final NeedHelp needHelp;

  const _QuestionsSection(this.needHelp);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return _QuestionSectionItem(needHelp.questions[index]);
      },
      itemCount: needHelp.questions.length,
    );
  }
}

class _QuestionSectionItem extends HookWidget {
  final Question question;

  const _QuestionSectionItem(this.question);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    return InkWell(
      onTap: () => AutoRouter.of(context).push(QuestionPageRoute(question: question)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.m),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: colors.dividerMedium,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                question.title,
                style: typography.body3,
              ),
            ),
            const SizedBox(width: AppDimens.m),
            SvgPicture.asset(
              AppIcon.chevronRight,
              color: colors.text,
              width: _arrowIconSize,
              height: _arrowIconSize,
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutSection extends HookWidget {
  final NeedHelp needHelp;

  const _AboutSection(this.needHelp);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          needHelp.title,
          style: typography.h8,
        ),
        const SizedBox(height: AppDimens.l),
        Text(
          needHelp.description,
          style: typography.body1,
        ),
      ],
    );
  }
}
