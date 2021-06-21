import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/service/data/service.dart';
import 'package:logpass_me/presentation/page/service_details/session_list/session_list_view.dart';
import 'package:logpass_me/presentation/page/service_details/session_list/session_list_view_cubit.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

class HistoricalSessionListPage extends HookWidget {
  final Service service;

  const HistoricalSessionListPage({required this.service, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<SessionListViewCubit>();
    final state = useCubitBuilder(cubit);
    final colors = useAppThemeColors();

    useEffect(() {
      cubit.initialize(false, service);
    }, [cubit]);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: CustomAppBar.smallTitleWithBack(
        title: 'Past sessions',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
        child: SessionListBuilder(
          cubit: cubit,
          state: state,
        ),
      ),
    );
  }
}
