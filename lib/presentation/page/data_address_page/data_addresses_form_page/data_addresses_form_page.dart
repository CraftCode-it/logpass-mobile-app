import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/page/data_address_page/data_addresses_form_page/data_addresses_form_page_cubit.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/country_code_picker/country_code_wide_picker.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/error_snackbar.dart';
import 'package:logpass_me/presentation/widget/input_field.dart';
import 'package:logpass_me/presentation/widget/logpass_dialog.dart';
import 'package:logpass_me/presentation/widget/messenger/messenger.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';

const _scrollThreshold = 12.0;

class DataAddressesFormPage extends HookWidget {
  final VoidCallback refreshListOnPagePop;

  const DataAddressesFormPage({
    required this.refreshListOnPagePop,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<DataAddressesFormPageCubit>();
    final state = useCubitBuilder(cubit);

    final colors = useAppThemeColors();
    final messengerController = useMessengerController();
    final scrollController = useScrollController();
    final elevationState = useState(false);

    useCubitListener<DataAddressesFormPageCubit, DataAddressesFormPageState>(
      cubit,
      (cubit, state, context) => _cubitListener(
        cubit,
        state,
        context,
        messengerController,
      ),
    );

    useEffect(() {
      scrollController.addListener(() {
        if (scrollController.offset > _scrollThreshold) {
          elevationState.value = true;
        } else {
          elevationState.value = false;
        }
      });
    }, [scrollController]);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: CustomAppBar.smallTitle(
        title: LocaleKeys.yourData_addAddressTitle.tr(),
        hasElevation: elevationState.value,
        leading: NavigationButton.close(
          customAction: () {
            state.maybeMap(
              idle: (state) async {
                if (state.areSomeFieldsFilled) {
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
          child: state.maybeWhen(
            idle: (canSave, areSomeFieldsFilled) => _Content(
              canSave: canSave,
              cubit: cubit,
              scrollController: scrollController,
            ),
            loading: () => const Loader(),
            orElse: () => const SizedBox(),
          ),
        ),
      ),
    );
  }

  void _cubitListener(
    DataAddressesFormPageCubit cubit,
    DataAddressesFormPageState state,
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
      duplicatedEntry: (_) {
        controller.showError(LocaleKeys.yourData_duplicatedEntry.tr());
      },
      orElse: () {},
    );
  }
}

class _Content extends StatelessWidget {
  final bool canSave;
  final DataAddressesFormPageCubit cubit;
  final ScrollController scrollController;

  const _Content({
    required this.canSave,
    required this.cubit,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      controller: scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimens.m),
          InputField(
            label: LocaleKeys.yourData_addressForm_nameHint.tr(),
            onChanged: cubit.nameChanged,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: AppDimens.l),
          InputField(
            label: LocaleKeys.yourData_addressForm_streetHint.tr(),
            onChanged: cubit.streetChanged,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: AppDimens.l),
          InputField(
            label: LocaleKeys.yourData_addressForm_buildingHint.tr(),
            onChanged: cubit.buildingNumberChanged,
            inputType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppDimens.l),
          InputField(
            label: LocaleKeys.yourData_addressForm_apartmentHint.tr(),
            onChanged: cubit.apartmentNumberChanged,
            inputType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppDimens.l),
          InputField(
            label: LocaleKeys.yourData_addressForm_postCodeHint.tr(),
            onChanged: cubit.postCodeChanged,
            inputType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppDimens.l),
          InputField(
            label: LocaleKeys.yourData_addressForm_cityHint.tr(),
            onChanged: cubit.cityChanged,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: AppDimens.l),
          CountryCodeWidePicker(
            onCountryCodeSelected: (code) => cubit.countyChanged(code.countryName),
          ),
          const SizedBox(height: AppDimens.xxxl),
          CustomRectangularButton.filled(
            text: LocaleKeys.yourData_saveOption.tr(),
            onPressed: canSave ? cubit.saveAddress : null,
          ),
          const SizedBox(height: AppDimens.l),
        ],
      ),
    );
  }
}
