import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
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
    final colors = useAppThemeColors();

    useEffect(
      () {
        cubit.set(initialValue);
      },
      [initialValue],
    );

    return state.map(
      loading: (state) => const Loader(),
      value: (state) => Checkbox(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return colors.primary100;
          } else {
            return colors.background;
          }
        }),
        checkColor: colors.primary100,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        value: state.value,
        onChanged: (value) {
          cubit.set(value ?? initialValue);
          onValueChanged(value ?? initialValue);
        },
      ),
    );
  }
}
