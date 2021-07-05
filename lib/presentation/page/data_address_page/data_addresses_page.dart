import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/user_data/data/address.dart';
import 'package:logpass_me/presentation/page/data_address_page/data_addresses_page_cubit.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/data_management/show_more_dialog.dart';
import 'package:logpass_me/presentation/widget/data_management/user_data_tile.dart';
import 'package:logpass_me/presentation/widget/error_snackbar.dart';
import 'package:logpass_me/presentation/widget/logpass_dialog.dart';
import 'package:logpass_me/presentation/widget/messenger/messenger.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';

class DataAddressesPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<DataAddressesPageCubit>();
    final state = useCubitBuilder(cubit);

    final colors = useAppThemeColors();
    final messengerController = useMessengerController();

    useCubitListener<DataAddressesPageCubit, DataAddressesPageState>(
      cubit,
      (cubit, state, context) => _cubitListener(
        cubit,
        state,
        context,
        messengerController,
      ),
    );

    useEffect(() {
      cubit.init();
    }, [cubit]);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: CustomAppBar.smallTitle(
        title: LocaleKeys.yourData_addresses.tr(),
        leading: NavigationButton.back(),
      ),
      body: SafeArea(
        child: Messenger(
          controller: messengerController,
          child: state.maybeWhen(
            idle: (addressList) => _Content(
              addressList: addressList,
              cubit: cubit,
            ),
            empty: () => _Content(
              addressList: null,
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
    DataAddressesPageCubit cubit,
    DataAddressesPageState state,
    BuildContext context,
    MessengerController controller,
  ) {
    state.maybeMap(
      addressRemoved: (state) async {
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
        );
        if (confirmed) {
          await cubit.deleteAddress(state.address);
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
  final List<Address>? addressList;
  final DataAddressesPageCubit cubit;

  const _Content({
    required this.addressList,
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
            child: (addressList != null)
                ? _AddressList(
                    addressList: addressList!,
                    cubit: cubit,
                  )
                : _EmptyListMessage(),
          ),
          const SizedBox(height: AppDimens.l),
          CustomRectangularButton.filled(
            text: LocaleKeys.yourData_addNewOption.tr(),
            onPressed: () => AutoRouter.of(context).push(DataAddressesFormPageRoute(
              refreshListOnPagePop: cubit.getAddressList,
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
        LocaleKeys.yourData_addressesEmptyList.tr(),
        style: typography.body1.copyWith(color: colors.secondaryText),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _AddressList extends HookWidget {
  final List<Address> addressList;
  final DataAddressesPageCubit cubit;

  const _AddressList({
    required this.addressList,
    required this.cubit,
  });

  String _formatAddressDetails(Address address) {
    if (address.apartmentNumber != null) {
      return '${address.street} ${address.buildingNumber}/${address.apartmentNumber}\n${address.postCode} ${address.city}';
    }
    return '${address.street} ${address.buildingNumber}\n${address.postCode} ${address.city}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    return ListView.builder(
      itemBuilder: (context, index) {
        return UserDataTile(
          title: addressList[index].name,
          isDefault: addressList[index].isDefault,
          content: _formatAddressDetails(addressList[index]),
          onMoreTapped: () => showMore<Address>(
            context,
            addressList[index],
            typography,
            colors,
            cubit.ensureRemoval,
            cubit.setAddressAsDefault,
          ),
        );
      },
      itemCount: addressList.length,
    );
  }
}
