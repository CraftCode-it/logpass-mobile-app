import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/version_info/version_info_cubit.dart';

class VersionInfo extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<VersionInfoCubit>();
    final state = useCubitBuilder(cubit);

    return state.map(
      idle: (state) => _Content(state.versionInfo),
    );
  }
}

class _Content extends HookWidget {
  final String version;

  const _Content(this.version);

  @override
  Widget build(Object context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    return Text(
      'Logpass v.$version',
      style: typography.info1.copyWith(
        color: colors.labelText,
      ),
    );
  }
}
