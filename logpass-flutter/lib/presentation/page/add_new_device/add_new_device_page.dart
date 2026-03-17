import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/add_new_device/add_new_device_page_cubit.dart';
import 'package:logpass_me/presentation/page/add_new_device/add_new_device_page_state.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/bubbles_loader/bubbles_loader.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/custom_scaffold.dart';
import 'package:logpass_me/presentation/widget/done_keyboard_button.dart';
import 'package:logpass_me/presentation/widget/error_snackbar.dart';
import 'package:logpass_me/presentation/widget/input_field.dart';
import 'package:logpass_me/presentation/widget/messenger/messenger.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';

class AddNewDevicePage extends HookWidget {
  const AddNewDevicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<AddNewDevicePageCubit>();
    final state = useCubitBuilder(cubit);

    final messengerController = useMessengerController();
    final codeController = useTextEditingController();
    final codeInputKey = useMemoized(() => GlobalKey());

    useCubitListener<AddNewDevicePageCubit, AddNewDevicePageState>(
      cubit,
      (cubit, state, context) => _listener(cubit, state, context, messengerController),
    );

    return CustomScaffold(
      appBar: CustomAppBar.smallTitle(
        leading: NavigationButton.back(),
        title: LocaleKeys.addNewDevice_title.tr(),
      ),
      body: SafeArea(
        child: Messenger(
          controller: messengerController,
          child: KeyboardVisibilityBuilder(
            builder: (BuildContext context, bool isKeyboardVisible) {
              if (isKeyboardVisible) {
                return _PartialContent(
                  state: state,
                  controller: codeController,
                  cubit: cubit,
                  codeInputKey: codeInputKey,
                );
              } else {
                return _FullContent(
                  state: state,
                  controller: codeController,
                  cubit: cubit,
                  codeInputKey: codeInputKey,
                );
              }
            },
          ),
        ),
      ),
      onErrorActionTapped: () {},
    );
  }

  void _listener(
    AddNewDevicePageCubit cubit,
    AddNewDevicePageState state,
    BuildContext context,
    MessengerController controller,
  ) {
    state.maybeMap(
      processing: (_) {},
      orElse: () => AutoRouter.of(context).popUntil((route) => route.settings.name == AddNewDevicePageRoute.name),
    );

    state.maybeMap(
      processing: (_) {
        showGeneralDialog(
          context: context,
          pageBuilder: (context, animation, secondaryAnimation) => BubblesLoader(),
        );
      },
      deviceAdded: (_) {
        AutoRouter.of(context).pushAndPopUntil(
          const LoginSuccessPageRoute(),
          predicate: (route) => false,
        );
      },
      connectionError: (state) => controller.showError(
        getConnectionErrorString(state.error),
      ),
      orElse: () {},
    );
  }
}

class _PartialContent extends StatelessWidget {
  final TextEditingController controller;
  final AddNewDevicePageState state;
  final AddNewDevicePageCubit cubit;
  final Key codeInputKey;

  const _PartialContent({
    required this.controller,
    required this.state,
    required this.cubit,
    required this.codeInputKey,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppDimens.m),
                _CodeContent(
                  key: codeInputKey,
                  state: state,
                  controller: controller,
                  cubit: cubit,
                ),
                const Spacer(),
                _ContinueButton(
                  state: state,
                  cubit: cubit,
                ),
                const SizedBox(height: AppDimens.m),
              ],
            ),
          ),
        ),
        if (Platform.isIOS) DoneKeyboardButton(),
      ],
    );
  }
}

class _FullContent extends StatelessWidget {
  final TextEditingController controller;
  final AddNewDevicePageState state;
  final AddNewDevicePageCubit cubit;
  final Key codeInputKey;

  const _FullContent({
    required this.controller,
    required this.state,
    required this.cubit,
    required this.codeInputKey,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: AppDimens.m),
                const _InfoContent(),
                const SizedBox(height: AppDimens.xc),
                _CodeContent(
                  key: codeInputKey,
                  state: state,
                  controller: controller,
                  cubit: cubit,
                ),
              ],
            ),
          ),
          SliverFillRemaining(
            fillOverscroll: false,
            hasScrollBody: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.only(bottom: AppDimens.m),
                width: double.infinity,
                child: _ContinueButton(
                  state: state,
                  cubit: cubit,
                ),
              ),
            ),
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
          LocaleKeys.addNewDevice_header.tr(),
          style: typography.h6,
        ),
        const SizedBox(height: AppDimens.l),
        Text(
          LocaleKeys.addNewDevice_content.tr(),
          style: typography.body1,
        ),
      ],
    );
  }
}

class _CodeContent extends HookWidget {
  final TextEditingController controller;
  final AddNewDevicePageState state;
  final AddNewDevicePageCubit cubit;

  const _CodeContent({
    required this.controller,
    required this.state,
    required this.cubit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final active = state.maybeMap(
      processing: (_) => false,
      orElse: () => true,
    );

    final typography = useAppTypography();
    final mask = useMemoized(() => MaskTextInputFormatter(mask: '###-###'));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          LocaleKeys.addNewDevice_codeInstruction.tr(),
          style: typography.body1,
        ),
        const SizedBox(height: AppDimens.s),
        Text(
          LocaleKeys.addNewDevice_codeInstructionNavigation.tr(),
          style: typography.h8,
        ),
        const SizedBox(height: AppDimens.xl),
        Text(
          LocaleKeys.addNewDevice_codeInsert.tr(),
          style: typography.body1,
        ),
        const SizedBox(height: AppDimens.m),
        InputField(
          label: LocaleKeys.addNewDevice_codeLabel.tr(),
          hint: LocaleKeys.addNewDevice_codeHint.tr(),
          onChanged: cubit.updateCode,
          controller: controller,
          inputType: TextInputType.number,
          enabled: active,
          formatters: [
            mask,
          ],
        ),
      ],
    );
  }
}

class _ContinueButton extends StatelessWidget {
  final AddNewDevicePageState state;
  final AddNewDevicePageCubit cubit;

  const _ContinueButton({
    required this.state,
    required this.cubit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final active = state.maybeMap(
      idle: (state) => state.isCodeValid,
      orElse: () => false,
    );

    return CustomRectangularButton.filled(
      text: LocaleKeys.common_continue.tr(),
      onPressed: active ? () => cubit.addNewDevice() : null,
    );
  }
}
