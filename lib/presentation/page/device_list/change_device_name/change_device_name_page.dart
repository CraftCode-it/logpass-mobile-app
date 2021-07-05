import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/device_list/change_device_name/change_device_name_page_cubit.dart';
import 'package:logpass_me/presentation/page/device_list/change_device_name/change_device_name_page_state.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/custom_scaffold.dart';
import 'package:logpass_me/presentation/widget/input_field.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';

typedef OnNameChanged = Function(String name);

class ChangeDeviceNamePage extends HookWidget {
  final String currentName;
  final OnNameChanged onNameChanged;

  const ChangeDeviceNamePage({
    required this.currentName,
    required this.onNameChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ChangeDeviceNamePageCubit>();
    final state = useCubitBuilder(cubit);
    final nameController = useTextEditingController();
    final nameFocus = useFocusNode();

    useCubitListener<ChangeDeviceNamePageCubit, ChangeDeviceNamePageState>(cubit, (cubit, state, context) {
      state.maybeMap(
        initializeName: (state) {
          nameController.text = state.name;
          nameController.selection = TextSelection.fromPosition(TextPosition(offset: currentName.length));
          nameFocus.requestFocus();
        },
        orElse: () {},
      );
    });

    useEffect(() {
      cubit.initialize(currentName);
    }, [cubit]);

    return CustomScaffold(
      appBar: CustomAppBar.smallTitle(
        leading: NavigationButton.back(),
        title: LocaleKeys.changeDeviceName_title.tr(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppDimens.m),
              InputField(
                controller: nameController,
                label: LocaleKeys.changeDeviceName_name.tr(),
                hint: '',
                onChanged: cubit.updateName,
                focusNode: nameFocus,
              ),
              const Spacer(),
              _SaveButton(
                state: state,
                onNameChanged: onNameChanged,
              ),
              const SizedBox(height: AppDimens.m),
            ],
          ),
        ),
      ),
      onTryAgain: () {},
    );
  }
}

class _SaveButton extends StatelessWidget {
  final ChangeDeviceNamePageState state;
  final OnNameChanged onNameChanged;

  const _SaveButton({
    required this.state,
    required this.onNameChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomRectangularButton.filled(
      text: LocaleKeys.common_save.tr(),
      onPressed: _onTap(context, state),
    );
  }

  Function()? _onTap(BuildContext context, ChangeDeviceNamePageState state) {
    return state.maybeMap(
      idle: (state) => state.canSave
          ? () {
              onNameChanged(state.name);
              AutoRouter.of(context).pop();
            }
          : null,
      orElse: () => null,
    );
  }
}
