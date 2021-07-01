import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/user_data/data/personal_data.dart';
import 'package:logpass_me/presentation/page/data_personal_page/data_personal_page_cubit.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/data_management/user_data_tile.dart';
import 'package:logpass_me/presentation/widget/error_snackbar.dart';
import 'package:logpass_me/presentation/widget/logpass_dialog.dart';
import 'package:logpass_me/presentation/widget/messenger/messenger.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';

class DataPersonalPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<DataPersonalPageCubit>();
    final state = useCubitBuilder(cubit);

    final colors = useAppThemeColors();
    final typography = useAppTypography();
    final messengerController = useMessengerController();

    useCubitListener<DataPersonalPageCubit, DataPersonalPageState>(
      cubit,
      (cubit, state, context) => _cubitListener(
        cubit,
        state,
        context,
        colors,
        typography,
        messengerController,
      ),
    );

    useEffect(() {
      cubit.init();
    }, [cubit]);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: CustomAppBar.smallTitle(
        title: LocaleKeys.yourData_personalData.tr(),
        leading: NavigationButton.back(),
      ),
      body: SafeArea(
        child: Messenger(
          controller: messengerController,
          child: state.maybeWhen(
            idle: (personalDataList) => _Content(
              personalDataList: personalDataList,
              cubit: cubit,
            ),
            empty: () => _Content(
              personalDataList: null,
              cubit: cubit,
            ),
            loading: () => const Loader(),
            orElse: () => const SizedBox(),
          ),
        ),
      ),
    );
  }

  void _cubitListener(
    DataPersonalPageCubit cubit,
    DataPersonalPageState state,
    BuildContext context,
    AppThemeColors colors,
    AppTypography typography,
    MessengerController controller,
  ) {
    state.maybeMap(
      dataRemoved: (state) async {
        controller.showError(
          LocaleKeys.yourData_dataRemoved.tr(),
        );
      },
      removalConfirmationNeeded: (state) async {
        final confirmed = await showTwoOptionsDialog(
          context,
          LocaleKeys.yourData_removeDialogTitle.tr(),
          LocaleKeys.yourData_removeDialogDescription.tr(),
          LocaleKeys.yourData_removeOption.tr(),
          LocaleKeys.yourData_goBackOption.tr(),
          typography,
          colors,
        );
        if (confirmed) {
          await cubit.deletePersonalData(state.data);
        }
      },
      connectionError: (state) async {
        controller.showError(
          getConnectionErrorString(state.error),
        );
      },
      orElse: () {},
    );
  }
}

class _Content extends StatelessWidget {
  final List<PersonalData>? personalDataList;
  final DataPersonalPageCubit cubit;

  const _Content({
    required this.personalDataList,
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
          Expanded(
            child: (personalDataList != null)
                ? _PersonalDataList(
                    personalDataList: personalDataList!,
                    cubit: cubit,
                  )
                : _EmptyListMessage(),
          ),
          const SizedBox(height: AppDimens.l),
          CustomRectangularButton.filled(
            text: LocaleKeys.yourData_personalDataAddButton.tr(),
            onPressed: () => AutoRouter.of(context).push(DataPersonalFormPageRoute(
              refreshListOnPagePop: cubit.getPersonalDataList,
            )),
          ),
          const SizedBox(height: AppDimens.xl),
        ],
      ),
    );
  }
}

class _EmptyListMessage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final colors = useAppThemeColors();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      child: Text(
        LocaleKeys.yourData_personalDataEmptyList.tr(),
        style: typography.body1.copyWith(color: colors.secondaryText),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _PersonalDataList extends HookWidget {
  final List<PersonalData> personalDataList;
  final DataPersonalPageCubit cubit;

  const _PersonalDataList({
    required this.personalDataList,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    return ListView.builder(
      itemBuilder: (context, index) {
        return UserDataTile(
          title: personalDataList[index].toString(),
          isDefault: personalDataList[index].isDefault,
          onMoreTapped: () => _showMore(
            context,
            personalDataList[index],
            typography,
            colors,
            cubit.ensureDataRemoval,
            cubit.setDefaultPersonalData,
          ),
        );
      },
      itemCount: personalDataList.length,
    );
  }

  Future<void> _showMore(
    BuildContext context,
    PersonalData data,
    AppTypography typography,
    AppThemeColors colors,
    Function(PersonalData) onRemoveCallback,
    Function(PersonalData) onSetDefaultCallback,
  ) async {
    if (data.isDefault) {
      await showCustomContentDialog(
        context,
        [
          CustomRectangularButton.filled(
            text: LocaleKeys.yourData_removeOption.tr(),
            fillColor: AppColors.error100,
            borderColor: AppColors.error100,
            onPressed: () {
              AutoRouter.of(context).pop();
              onRemoveCallback(data);
            },
            leadingIconPath: AppIcon.bin,
          ),
        ],
        colors,
      );
    } else {
      await showCustomContentDialog(
        context,
        [
          CustomRectangularButton.filled(
            text: LocaleKeys.yourData_setDefaultOption.tr(),
            fillColor: AppColors.success100,
            borderColor: AppColors.success100,
            onPressed: () {
              AutoRouter.of(context).pop();
              onSetDefaultCallback(data);
            },
            leadingIconPath: AppIcon.star,
          ),
          CustomRectangularButton.outlined(
            text: LocaleKeys.yourData_removeOption.tr(),
            onPressed: () {
              AutoRouter.of(context).pop();
              onRemoveCallback(data);
            },
          ),
        ],
        colors,
      );
    }
  }
}
