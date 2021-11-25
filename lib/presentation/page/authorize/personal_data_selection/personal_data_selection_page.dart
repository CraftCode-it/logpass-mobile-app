import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/service/data/service.dart';
import 'package:logpass_me/domain/user_data/data/personal_data.dart';
import 'package:logpass_me/exports.dart';
import 'package:logpass_me/presentation/page/authorize/personal_data_selection/personal_data_selection_page_cubit.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/error_snackbar.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/messenger/messenger.dart';
import 'package:logpass_me/presentation/widget/radio_button_tile.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';
import 'package:logpass_me/presentation/widget/service_header.dart';

class PersonalDataSelectionPage extends HookWidget {
  final Service service;
  final PersonalData? personalData;
  final Function(PersonalData) onPagePop;

  const PersonalDataSelectionPage({
    required this.service,
    required this.onPagePop,
    this.personalData,
  });

  void _callOnPagePop(PersonalDataSelectionPageState state) {
    final personalData = state.maybeWhen(
      idle: (addresses, selectedAddress) => selectedAddress,
      orElse: () {},
    );
    if (personalData != null) onPagePop(personalData);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<PersonalDataSelectionPageCubit>();
    final state = useCubitBuilder(cubit);
    final colors = useAppThemeColors();
    final messengerController = useMessengerController();

    useCubitListener<PersonalDataSelectionPageCubit, PersonalDataSelectionPageState>(
      cubit,
      (cubit, state, context) => _cubitListener(
        cubit,
        state,
        context,
        messengerController,
      ),
    );

    useEffect(() {
      cubit.init(personalData);
    }, [cubit]);

    return WillPopScope(
      onWillPop: () {
        _callOnPagePop(state);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: CustomAppBar.smallTitle(
          title: LocaleKeys.authorize_selectProfileData.tr(),
          leading: NavigationButton.back(
            customAction: () {
              _callOnPagePop(state);
              AutoRouter.of(context).pop();
            },
          ),
        ),
        body: SafeArea(
          child: Messenger(
            controller: messengerController,
            child: state.maybeWhen(
              idle: (personalDataList, selectedPersonalData) =>
                  _Content(service, personalDataList, selectedPersonalData, cubit,),
              loading: () => const Loader(),
              empty: () => _NoContent(cubit: cubit),
              orElse: () => const SizedBox(),
            )
          ),
        ),
      )
    );
  }

  void _cubitListener(
      PersonalDataSelectionPageCubit cubit,
      PersonalDataSelectionPageState state,
      BuildContext context,
      MessengerController controller,
      ) {
    state.maybeMap(
      connectionError: (state) async {
        controller.showError(getConnectionErrorString(state.error));
      },
      orElse: () {},
    );
  }
}

class _NoContent extends StatelessWidget {
  final PersonalDataSelectionPageCubit cubit;

  const _NoContent({required this.cubit, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.l),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: CustomRectangularButton.filled(
              text: LocaleKeys.yourData_addNewOption.tr(),
              onPressed: () => AutoRouter.of(context).push(DataPersonalFormPageRoute(
                refreshListOnPagePop: cubit.getPersonalDataList,
              )),
            ),
          ),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final Service service;
  final List<PersonalData> personalDataList;
  final PersonalData selectedPersonalData;
  final PersonalDataSelectionPageCubit cubit;

  const _Content(
    this.service,
    this.personalDataList,
    this.selectedPersonalData,
    this.cubit,
  );

  @override
  Widget build(BuildContext context) {

    return Column(
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
              itemBuilder: (context, index) {
                print('ANDRII isSelected: ${personalDataList[index] == selectedPersonalData}');

                return RadioButtonTile(
                  title: personalDataList[index].toString(),
                  isSelected: personalDataList[index] == selectedPersonalData,
                  onTapAction: () => cubit.selectPersonalData(personalDataList[index]),
                );
              },
              // itemBuilder: (context, index) => RadioButtonTile(
              //   title: personalDataList[index].toString(),
              //   isSelected: personalDataList[index] == selectedPersonalData,
              //   onTapAction: () => cubit.selectPersonalData(personalDataList[index]),
              // ),
              itemCount: personalDataList.length,
            ),
          ),
        ),
      ],
    );
  }
}
