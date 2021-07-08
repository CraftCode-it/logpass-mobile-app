import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/presentation/page/reset_account/reset_account_page_cubit.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/bubbles_loader/bubbles_loader.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/error_snackbar.dart';
import 'package:logpass_me/presentation/widget/messenger/messenger.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';

class ResetAccountPage extends HookWidget {
  const ResetAccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ResetAccountPageCubit>();
    final state = useCubitBuilder(cubit);

    final messengerController = useMessengerController();

    useCubitListener<ResetAccountPageCubit, ResetAccountPageState>(
      cubit,
      (cubit, state, context) => _cubitListener(cubit, state, context, messengerController),
    );

    return state.maybeWhen(
      idle: () => _Content(
        controller: messengerController,
        isLoading: false,
        cubit: cubit,
      ),
      processing: () => _Content(
        controller: messengerController,
        isLoading: true,
        cubit: cubit,
      ),
      orElse: () => const SizedBox.shrink(),
    );
  }

  void _cubitListener(
    ResetAccountPageCubit cubit,
    ResetAccountPageState state,
    BuildContext context,
    MessengerController controller,
  ) {
    state.maybeMap(
      accountResetSuccessful: (state) {
        AutoRouter.of(context).pushAndPopUntil(
          const LoginSuccessPageRoute(),
          predicate: (route) => false,
        );
      },
      connectionError: (state) => controller.showError(
        getConnectionErrorString(state.error),
      ),
      error: (state) => controller.showError(
        getConnectionErrorString(GeneralConnectionError.somethingWentWrong()),
      ),
      orElse: () {},
    );
  }
}

class _Content extends HookWidget {
  final MessengerController controller;
  final bool isLoading;
  final ResetAccountPageCubit cubit;

  const _Content({
    required this.controller,
    required this.isLoading,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: isLoading
          ? BubblesLoader()
          : Scaffold(
              backgroundColor: colors.background,
              appBar: CustomAppBar.smallTitle(
                leading: NavigationButton.back(),
                title: LocaleKeys.resetAccount_title.tr(),
              ),
              body: SafeArea(
                child: Messenger(
                  controller: controller,
                  withActionHandler: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                    child: CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              const SizedBox(height: AppDimens.m),
                              const _InfoContent(),
                              const SizedBox(height: AppDimens.m),
                            ],
                          ),
                        ),
                        SliverFillRemaining(
                          fillOverscroll: false,
                          hasScrollBody: false,
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _WarningContent(),
                                  const SizedBox(height: AppDimens.m),
                                  CustomRectangularButton.filled(
                                    text: LocaleKeys.resetAccount_resetAccountButton.tr(),
                                    onPressed: cubit.resetAccount,
                                  ),
                                  const SizedBox(height: AppDimens.xl),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class _WarningContent extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.s),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            LocaleKeys.resetAccount_firstWarningNote.tr(),
            textAlign: TextAlign.center,
            style: typography.body1,
          ),
          const SizedBox(height: AppDimens.m),
          Text(
            LocaleKeys.resetAccount_secondWarningNote.tr(),
            textAlign: TextAlign.center,
            style: typography.body1,
          ),
          const SizedBox(height: AppDimens.s),
          Text(
            LocaleKeys.resetAccount_thirdWarningNote.tr(),
            textAlign: TextAlign.center,
            style: typography.body3.copyWith(color: AppColors.error100),
          ),
        ],
      ),
    );
  }
}

class _InfoContent extends HookWidget {
  const _InfoContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          LocaleKeys.resetAccount_header.tr(),
          style: typography.h6,
        ),
        const SizedBox(height: AppDimens.l),
        Text(
          LocaleKeys.resetAccount_firstParagraph.tr(),
          style: typography.body1,
        ),
        const SizedBox(height: AppDimens.l),
        Text(
          LocaleKeys.resetAccount_secondParagraph.tr(),
          style: typography.body1,
        ),
      ],
    );
  }
}
