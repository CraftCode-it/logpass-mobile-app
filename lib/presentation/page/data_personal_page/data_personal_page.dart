import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/user_data/data/personal_data.dart';
import 'package:logpass_me/presentation/page/data_personal_page/data_personal_page_cubit.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/data_management/user_data_tile.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class DataPersonalPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<DataPersonalPageCubit>();
    final state = useCubitBuilder(cubit);
    final colors = useAppThemeColors();

    useEffect(() {
      cubit.init();
    }, [cubit]);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: CustomAppBar.smallTitle(
        title: LocaleKeys.yourData_personalData.tr(),
        leading: NavigationButton.back(),
      ),
      body: state.maybeWhen(
        idle: (personalDataList) => _Content(
          personalDataList: personalDataList,
        ),
        empty: () => const _Content(personalDataList: null),
        loading: () => const Loader(),
        orElse: () => const SizedBox(),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final List<PersonalData>? personalDataList;

  const _Content({
    required this.personalDataList,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimens.m),
            Expanded(
              child: (personalDataList != null)
                  ? _PersonalDataList(
                      personalDataList: personalDataList!,
                    )
                  : _EmptyListMessage(),
            ),
            const SizedBox(height: AppDimens.l),
            CustomRectangularButton.filled(
              text: LocaleKeys.yourData_personalDataAddButton.tr(),
              onPressed: () {},
            ),
            const SizedBox(height: AppDimens.m),
          ],
        ),
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
        LocaleKeys.yourData_personalDataEmptyList.tr(),
        style: typography.body1.copyWith(color: colors.secondaryText),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _PersonalDataList extends StatelessWidget {
  final List<PersonalData> personalDataList;

  const _PersonalDataList({
    required this.personalDataList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return UserDataTile(
          title: personalDataList[index].toString(),
          isDefault: personalDataList[index].isDefault,
        );
      },
      itemCount: personalDataList.length,
    );
  }
}
