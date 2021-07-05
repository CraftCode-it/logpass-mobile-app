import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logpass_me/presentation/page/data_address_page/data_addresses_form_page/data_addresses_form_page_cubit.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/input_field.dart';
import 'package:logpass_me/presentation/widget/logpass_dialog.dart';
import 'package:logpass_me/presentation/widget/messenger/messenger.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';

const _arrowIconSize = 24.0;
const _buttonBorderWidth = 1.5;
const _emptySpace = 12.0;

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
    final typography = useAppTypography();
    final messengerController = useMessengerController();
    final scrollController = useScrollController();
    final elevationState = useState(false);

    useEffect(() {
      scrollController.addListener(() {
        if (scrollController.offset > _emptySpace) {
          elevationState.value = true;
        } else {
          elevationState.value = false;
        }
      });
    }, [scrollController]);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: CustomAppBar.smallTitle(
        title: LocaleKeys.yourData_addPersonalDataTitle.tr(),
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
                    typography,
                    colors,
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
            idle: (canSave, areSomeFieldsFilled) => KeyboardVisibilityBuilder(
              builder: (context, keyboardVisible) => _Content(
                canSave: canSave,
                cubit: cubit,
                keyboardVisible: keyboardVisible,
                scrollController: scrollController,
              ),
            ),
            loading: () => const Loader(),
            orElse: () => const SizedBox(),
          ),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final bool canSave;
  final DataAddressesFormPageCubit cubit;
  final bool keyboardVisible;
  final ScrollController scrollController;

  const _Content({
    required this.canSave,
    required this.cubit,
    required this.keyboardVisible,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimens.m),
            InputField(
              label: '*Name',
              onChanged: cubit.nameChanged,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppDimens.l),
            InputField(
              label: '*Street',
              onChanged: cubit.streetChanged,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppDimens.l),
            InputField(
              label: '*Buidling number',
              onChanged: cubit.buildingNumberChanged,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppDimens.l),
            InputField(
              label: 'Apartment number',
              onChanged: cubit.apartmentNumberChanged,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppDimens.l),
            InputField(
              label: '*Postcode',
              onChanged: cubit.postCodeChanged,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppDimens.l),
            InputField(
              label: '*City',
              onChanged: cubit.cityChanged,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: AppDimens.l),
            _CountryFormRow(),
            const SizedBox(height: AppDimens.xxl),
            if (!keyboardVisible) ...[
              CustomRectangularButton.filled(
                text: LocaleKeys.yourData_saveOption.tr(),
                onPressed: canSave ? cubit.saveAddress : null,
              ),
              const SizedBox(height: AppDimens.xl),
            ],
          ],
        ),
      ),
    );
  }
}

class _CountryFormRow extends HookWidget {
  final String? country;

  const _CountryFormRow({this.country});

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final colors = useAppThemeColors();

    return SizedBox(
      width: double.infinity,
      height: AppDimens.xc,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(colors.buttonOutlinedFill),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
              side: BorderSide(
                color: colors.inputBorder,
                width: _buttonBorderWidth,
              ),
            ),
          ),
        ),
        onPressed: () {
          // TODO: handle navigation
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.s),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '*Country',
                style: typography.h9.copyWith(color: colors.labelText),
              ),
              SvgPicture.asset(
                AppIcon.chevronDown,
                color: colors.text,
                width: _arrowIconSize,
                height: _arrowIconSize,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
