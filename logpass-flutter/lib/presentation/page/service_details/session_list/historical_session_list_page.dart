import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/service/data/service.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/service_details/session_list/session_list_view.dart';
import 'package:logpass_me/presentation/page/service_details/session_list/session_list_view_cubit.dart';
import 'package:logpass_me/presentation/page/service_details/session_list/session_list_view_state.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/custom_scaffold.dart';
import 'package:logpass_me/presentation/widget/messenger/messenger.dart';

class HistoricalSessionListPage extends HookWidget {
  final Service service;

  const HistoricalSessionListPage({required this.service, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<SessionListViewCubit>();
    final state = useCubitBuilder(cubit);
    final messengerController = useMessengerController();

    useCubitListener<SessionListViewCubit, SessionListViewState>(
      cubit,
      (cubit, state, context) => cubitEventListener(cubit, state, context, messengerController),
    );

    useEffect(() {
      cubit.initialize(false, service);
    }, [cubit]);

    return CustomScaffold(
      appBar: CustomAppBar.smallTitle(
        title: LocaleKeys.pastSessionsList_title.tr(),
        leading: NavigationButton.back(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
        child: SessionListBuilder(
          cubit: cubit,
          state: state,
        ),
      ),
      onErrorActionTapped: () => cubit.initialize(false, service),
    );
  }
}
