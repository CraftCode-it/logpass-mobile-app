import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/service/data/service.dart';
import 'package:logpass_me/domain/user_data/data/address.dart';
import 'package:logpass_me/presentation/page/authorize/address_selection/address_selection_page_cubit.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:logpass_me/presentation/widget/error_snackbar.dart';
import 'package:logpass_me/presentation/widget/radio_button_tile.dart';
import 'package:logpass_me/presentation/widget/service_header.dart';

class AddressSelectionPage extends HookWidget {
  final Service service;
  final Address? address;
  final Function(Address) onPagePop;

  const AddressSelectionPage({
    required this.service,
    required this.onPagePop,
    this.address,
  });

  void _callOnPagePop(AddressSelectionPageState state) {
    final address = state.maybeWhen(
      idle: (addresses, selectedAddress) => selectedAddress,
      orElse: () {},
    );
    if (address != null) onPagePop.call(address);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<AddressSelectionPageCubit>();
    final state = useCubitBuilder(cubit);
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    useCubitListener<AddressSelectionPageCubit, AddressSelectionPageState>(
      cubit,
      (cubit, state, context) => _cubitListener(
        cubit,
        state,
        context,
        colors,
        typography,
      ),
    );

    useEffect(() {
      cubit.init(address);
    }, [cubit]);

    return WillPopScope(
      onWillPop: () {
        _callOnPagePop(state);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: CustomAppBar.smallTitle(
          title: LocaleKeys.authorize_selectAddressTitle.tr(),
          leading: NavigationButton.back(
            customAction: () {
              _callOnPagePop(state);
              AutoRouter.of(context).pop();
            },
          ),
        ),
        body: state.maybeWhen(
          idle: (
            addresses,
            selectedAddress,
          ) =>
              _Content(
            service,
            addresses,
            selectedAddress,
            cubit,
          ),
          loading: () => const Loader(),
          orElse: () => const SizedBox(),
        ),
      ),
    );
  }

  void _cubitListener(
    AddressSelectionPageCubit cubit,
    AddressSelectionPageState state,
    BuildContext context,
    AppThemeColors colors,
    AppTypography typography,
  ) {
    state.maybeMap(
      connectionError: (state) async {
        showConnectionErrorSnackBar(
          error: state.error,
          context: context,
          colors: colors,
          typography: typography,
        );
      },
      orElse: () {},
    );
  }
}

class _Content extends StatelessWidget {
  final Service service;
  final List<Address> addresses;
  final Address selectedAddress;
  final AddressSelectionPageCubit cubit;

  const _Content(
    this.service,
    this.addresses,
    this.selectedAddress,
    this.cubit,
  );

  String _buildTileContent(Address address) {
    if (address.apartmentNumber != null) {
      return '${address.street} ${address.buildingNumber}/${address.apartmentNumber}\n${address.postCode} ${address.city}';
    }
    return '${address.street} ${address.buildingNumber}\n${address.postCode} ${address.city}';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          ServiceHeader(
            name: service.name,
            logoPath: service.logo,
            serviceUrl: service.url,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.l),
              child: ListView.builder(
                itemBuilder: (context, index) => RadioButtonTile(
                  title: addresses[index].name,
                  content: _buildTileContent(addresses[index]),
                  isSelected: addresses[index] == selectedAddress,
                  onTapAction: () => cubit.selectAddress(addresses[index]),
                ),
                itemCount: addresses.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
