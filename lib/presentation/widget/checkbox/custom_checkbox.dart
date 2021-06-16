import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/widget/checkbox/custom_checkbox_cubit.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

class CustomCheckbox extends HookWidget {
  final bool initialValue;
  final Function(bool value) onValueChanged;

  const CustomCheckbox({
    required this.onValueChanged,
    this.initialValue = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<CustomCheckboxCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(
      () {
        cubit.set(initialValue);
      },
      [initialValue],
    );

    return state.map(
      loading: (state) => const Loader(),
      value: (state) => _Checkbox(
        value: state.value,
        onChanged: (value) {
          cubit.set(value);
          onValueChanged(value);
        },
      ),
    );
  }
}

class _Checkbox extends StatelessWidget {
  final bool value;
  final Function(bool value) onChanged;

  const _Checkbox({
    required this.value,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.xs),
        child: SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset(
            value ? AppIcon.checkboxFilled : AppIcon.checkboxEmpty,
          ),
        ),
      ),
    );
  }
}
