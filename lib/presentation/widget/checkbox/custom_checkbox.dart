import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/widget/checkbox/custom_checkbox_cubit.dart';
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
      loading: (state) => const Center(
        child: CircularProgressIndicator(),
      ),
      value: (state) => Checkbox(
        value: state.value,
        onChanged: (value) {
          cubit.set(value ?? initialValue);
          onValueChanged(value ?? initialValue);
        },
      ),
    );
  }
}
