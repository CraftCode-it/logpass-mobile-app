import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/exports.dart';
import 'package:logpass_me/presentation/page/data_phone_page/data_phone_number_page_cubit.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

class DataPhoneNumberPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<DataPhoneNumberPageCubit>();
    final state = useCubitBuilder(cubit);
    final colors = useAppThemeColors();

    useEffect(() {
      cubit.initialize();
    }, [cubit]);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: CustomAppBar.smallTitle(
        title: LocaleKeys.yourData_phone.tr(),
        leading: NavigationButton.back(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: state.maybeWhen(
            idle: (phoneNumber) => _UserPhoneTile(title: phoneNumber),
            empty: () => _EmptyPhoneNumberMessage(),
            loading: () => const Loader(),
            orElse: () => const SizedBox(),
          ),
        ),
      ),
    );
  }
}

class _UserPhoneTile extends HookWidget {
  final String title;

  const _UserPhoneTile({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final colors = useAppThemeColors();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        bottom: AppDimens.m,
        left: AppDimens.m,
        right: AppDimens.m,
        top: AppDimens.l,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.dividerLight,
          ),
        ),
      ),
      child: Text(
        title,
        style: typography.body3,
      ),
    );
  }
}

class _EmptyPhoneNumberMessage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final colors = useAppThemeColors();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      child: Text(
        LocaleKeys.yourData_phoneEmpty.tr(),
        style: typography.body1.copyWith(color: colors.secondaryText),
        textAlign: TextAlign.center,
      ),
    );
  }
}