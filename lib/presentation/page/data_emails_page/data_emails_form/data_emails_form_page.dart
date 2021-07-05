import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/page/data_emails_page/data_emails_form/data_emails_form_page_cubit.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/error_snackbar.dart';
import 'package:logpass_me/presentation/widget/input_field.dart';
import 'package:logpass_me/presentation/widget/logpass_dialog.dart';
import 'package:logpass_me/presentation/widget/messenger/messenger.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class DataEmailsFormPage extends HookWidget {
  final VoidCallback refreshListOnPagePop;

  const DataEmailsFormPage({
    required this.refreshListOnPagePop,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<DataEmailsFormPageCubit>();
    final state = useCubitBuilder(cubit);

    final colors = useAppThemeColors();
    final messengerController = useMessengerController();

    useCubitListener<DataEmailsFormPageCubit, DataEmailsFormPageState>(
      cubit,
      (cubit, state, context) => _cubitListener(
        cubit,
        state,
        context,
        messengerController,
      ),
    );

    return Scaffold(
      backgroundColor: colors.background,
      appBar: CustomAppBar.smallTitle(
        title: LocaleKeys.yourData_addPersonalDataTitle.tr(),
        leading: NavigationButton.close(
          customAction: () {
            state.maybeMap(
              idle: (state) async {
                if (state.isFieldFilled) {
                  final confirmed = await showTwoOptionsDialog(
                    context,
                    LocaleKeys.yourData_exitDialogTitle.tr(),
                    LocaleKeys.yourData_exitDialogDescription.tr(),
                    LocaleKeys.yourData_leaveOption.tr(),
                    LocaleKeys.yourData_goBackOption.tr(),
                  );
                  if (confirmed) {
                    await AutoRouter.of(context).pop();
                  }
                } else {
                  await AutoRouter.of(context).pop();
                }
              },
              orElse: () => AutoRouter.of(context).pop(),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Messenger(
          controller: messengerController,
          child: state.maybeMap(
            idle: (state) => _Content(
              canSave: state.canSave,
              cubit: cubit,
            ),
            loading: (state) => const Loader(),
            orElse: () => const SizedBox(),
          ),
        ),
      ),
    );
  }

  void _cubitListener(
    DataEmailsFormPageCubit cubit,
    DataEmailsFormPageState state,
    BuildContext context,
    MessengerController controller,
  ) {
    state.maybeMap(
      savedSuccessful: (state) {
        refreshListOnPagePop();
        AutoRouter.of(context).pop();
      },
      connectionError: (state) {
        controller.showError(
          getConnectionErrorString(state.error),
        );
      },
      orElse: () {},
    );
  }
}

class _Content extends StatelessWidget {
  final bool canSave;
  final DataEmailsFormPageCubit cubit;

  const _Content({
    required this.canSave,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimens.m),
          InputField(
            label: LocaleKeys.yourData_emailForm_emailHint.tr(),
            onChanged: cubit.emailChanged,
            inputType: TextInputType.emailAddress,
          ),
          const Spacer(),
          CustomRectangularButton.filled(
            text: LocaleKeys.yourData_saveOption.tr(),
            onPressed: canSave ? cubit.saveEmail : null,
          ),
          const SizedBox(height: AppDimens.xl),
        ],
      ),
    );
  }
}
