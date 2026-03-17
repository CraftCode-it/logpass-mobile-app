import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logpass_me/domain/theme/theme_brightness.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/widget/checkbox/custom_checkbox_cubit.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

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
        cubit.init(initialValue);
      },
      [initialValue],
    );

    return state.map(
      loading: (state) => const SizedBox.shrink(),
      value: (state) => _Checkbox(
        value: state.value,
        brightness: _getBrightness(context, state.brightness),
        onChanged: (value) {
          cubit.set(value);
          onValueChanged(value);
        },
      ),
    );
  }

  Brightness _getBrightness(BuildContext context, ThemeBrightness themeBrightness) {
    final systemBrightness = MediaQuery.of(context).platformBrightness;

    switch (themeBrightness) {
      case ThemeBrightness.light:
        return Brightness.light;
      case ThemeBrightness.dark:
        return Brightness.dark;
      case ThemeBrightness.system:
        return systemBrightness;
    }
  }
}

class _Checkbox extends StatelessWidget {
  final bool value;
  final Function(bool value) onChanged;
  final Brightness brightness;

  const _Checkbox({
    required this.value,
    required this.onChanged,
    required this.brightness,
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
          child: brightness == Brightness.light ? _IconLightMode(value: value) : _IconDarkMode(value: value),
        ),
      ),
    );
  }
}

class _IconLightMode extends StatelessWidget {
  final bool value;

  const _IconLightMode({
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      value ? AppIcon.checkboxFilled : AppIcon.checkboxEmpty,
    );
  }
}

class _IconDarkMode extends StatelessWidget {
  final bool value;

  const _IconDarkMode({
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      value ? AppIcon.checkboxFilledDark : AppIcon.checkboxEmptyDark,
    );
  }
}
