import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logpass_me/domain/device/device.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/device_list/device_list_page_cubit.dart';
import 'package:logpass_me/presentation/page/device_list/device_menu.dart';
import 'package:logpass_me/presentation/page/device_list/device_row.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/custom_scaffold.dart';
import 'package:logpass_me/presentation/widget/logpass_dialog.dart';
import 'package:logpass_me/presentation/widget/messenger/messenger.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';

@RoutePage()
class DeviceListPage extends HookWidget {
  const DeviceListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<DeviceListPageCubit>();
    final state = useCubitBuilder(cubit);
    final colors = useAppThemeColors();
    final messengerController = useMessengerController();

    useEffect(() {
      cubit.initialize();
    }, [cubit]);

    return CustomScaffold(
      appBar: CustomAppBar.smallTitle(
        leading: NavigationButton.back(),
        title: LocaleKeys.deviceList_title.tr(),
        trailing: IconButton(
          icon: SvgPicture.asset(
            AppIcon.info,
            colorFilter: ColorFilter.mode(colors.buttonFill, BlendMode.srcIn),
          ),
          onPressed: () => AutoRouter.of(context).push(const TrustLevelPageRoute()),
        ),
      ),
      body: SafeArea(
        child: Messenger(
          controller: messengerController,
          child: Column(
            children: [
              Expanded(
                child: state.maybeMap(
                  loading: (_) => const Loader(),
                  idle: (state) => _Content(
                    deviceList: state.deviceList,
                    onMorePressed: (device) => _showDeviceMenu(
                      context,
                      device,
                      cubit,
                    ),
                  ),
                  orElse: () => const SizedBox.shrink(),
                ),
              ),
              _BottomContent(
                onSavePressed: () => cubit.saveChanges(),
                showSaveButton: state.maybeMap(
                  idle: (state) => state.modified,
                  orElse: () => false,
                ),
              ),
            ],
          ),
        ),
      ),
      onErrorActionTapped: () {
        cubit.initialize();
      },
      showErrorPage: state.maybeMap(
        loadingError: (_) => true,
        orElse: () => false,
      ),
    );
  }

  Future<void> _showDeviceMenu(BuildContext context, Device device, DeviceListPageCubit cubit) async {
    final result = await showModalBottomSheet<DeviceMenuItem?>(
      context: context,
      builder: (context) => const DeviceMenu(),
    );

    if (result != null) {
      switch (result) {
        case DeviceMenuItem.changeName:
          await AutoRouter.of(context).push(
            ChangeDeviceNamePageRoute(
              currentName: device.name,
              onNameChanged: (newName) {
                cubit.changeName(device, newName);
              },
            ),
          );
          break;
        case DeviceMenuItem.remove:
          await _showRemoveDialog(context, device, cubit);
          break;
      }
    }
  }

  Future<void> _showRemoveDialog(BuildContext context, Device device, DeviceListPageCubit cubit) async {
    final shouldRemove = await showTwoOptionsDialog(
      context,
      LocaleKeys.deviceList_removeDeviceTitle.tr(),
      LocaleKeys.deviceList_removeDeviceInfo.tr(),
      LocaleKeys.common_remove.tr(),
      LocaleKeys.common_back.tr(),
    );

    if(!shouldRemove) {
      return;
    }

    final success = await AutoRouter.of(context).push(
      ConfirmWithPinPageRoute(
        title: LocaleKeys.deviceList_removeDeviceTitle.tr(),
        button: LocaleKeys.common_remove.tr(),
      ),
    );

    if (success == true) {
      cubit.remove(device);
    }
  }
}

class _Content extends HookWidget {
  final List<Device> deviceList;
  final Function(Device device) onMorePressed;

  const _Content({
    required this.deviceList,
    required this.onMorePressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      itemCount: deviceList.length,
      itemBuilder: (context, index) => DeviceRow(
        device: deviceList[index],
        onMorePressed: () => onMorePressed(deviceList[index]),
      ),
    );
  }
}

class _BottomContent extends HookWidget {
  final Function() onSavePressed;
  final bool showSaveButton;

  const _BottomContent({
    required this.onSavePressed,
    required this.showSaveButton,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    final animationController = useAnimationController(duration: const Duration(milliseconds: 200));
    final animation = CurvedAnimation(parent: animationController, curve: Curves.easeInOut);

    if (showSaveButton) {
      animationController.forward();
    } else {
      animationController.reverse();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: CustomRectangularButton.filled(
            text: LocaleKeys.deviceList_addNewAction.tr(),
            onPressed: () => AutoRouter.of(context).push(const AddNewDeviceCodePageRoute()),
          ),
        ),
        const SizedBox(height: AppDimens.l),
        SizeTransition(
          axis: Axis.vertical,
          axisAlignment: -1,
          sizeFactor: animation,
          child: Container(
            padding: const EdgeInsets.only(
              left: AppDimens.l,
              right: AppDimens.l,
              top: AppDimens.m,
              bottom: AppDimens.l,
            ),
            color: colors.secondaryBackground,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  LocaleKeys.deviceList_saveChangesInfo.tr(),
                  style: typography.body2.copyWith(color: AppColors.error100),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimens.m),
                CustomRectangularButton.filled(
                  text: LocaleKeys.deviceList_saveChanges.tr(),
                  onPressed: onSavePressed,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
