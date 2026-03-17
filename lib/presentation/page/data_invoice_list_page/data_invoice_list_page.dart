import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/user_data/data/invoice_data.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/data_invoice_list_page/data_invoice_list_page_cubit.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/data_management/show_more_dialog.dart';
import 'package:logpass_me/presentation/widget/data_management/user_data_tile.dart';
import 'package:logpass_me/presentation/widget/error_snackbar.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/logpass_dialog.dart';
import 'package:logpass_me/presentation/widget/messenger/messenger.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';

@RoutePage()
class DataInvoiceListPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<DataInvoiceListPageCubit>();
    final state = useCubitBuilder(cubit);

    final colors = useAppThemeColors();
    final messengerController = useMessengerController();

    useCubitListener<DataInvoiceListPageCubit, DataInvoiceListPageState>(
      cubit,
      (cubit, state, context) => _cubitListener(
        cubit,
        state,
        context,
        messengerController,
      ),
    );

    useEffect(() {
      cubit.init();
    }, [cubit]);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: CustomAppBar.smallTitle(
        title: LocaleKeys.yourData_invoiceData.tr(),
        leading: NavigationButton.back(),
      ),
      body: SafeArea(
        child: Messenger(
          controller: messengerController,
          child: state.maybeWhen(
            idle: (invoiceDataList) => _Content(
              invoiceDataList: invoiceDataList,
              cubit: cubit,
            ),
            empty: () => _Content(
              invoiceDataList: null,
              cubit: cubit,
            ),
            loading: () => const Loader(),
            orElse: () => const SizedBox(),
          ),
        ),
      ),
    );
  }

  void _cubitListener(
    DataInvoiceListPageCubit cubit,
    DataInvoiceListPageState state,
    BuildContext context,
    MessengerController controller,
  ) {
    state.maybeMap(
      invoiceDataRemoved: (state) async {
        controller.showError(
          LocaleKeys.yourData_dataRemoved.tr(),
        );
      },
      removalConfirmationNeeded: (state) async {
        final confirmed = await showTwoOptionsDialog(
          context,
          LocaleKeys.yourData_removeDialogTitle.tr(),
          LocaleKeys.yourData_removeDialogDescription.tr(),
          LocaleKeys.yourData_removeOption.tr(),
          LocaleKeys.yourData_goBackOption.tr(),
        );
        if (confirmed) {
          await cubit.deleteInvoiceData(state.invoiceData);
        }
      },
      connectionError: (state) async {
        controller.showError(
          getConnectionErrorString(state.error),
        );
      },
      orElse: () {},
    );
  }
}

class _Content extends StatelessWidget {
  final List<InvoiceData>? invoiceDataList;
  final DataInvoiceListPageCubit cubit;

  const _Content({
    required this.invoiceDataList,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimens.m),
          Expanded(
            child: (invoiceDataList != null)
                ? _InvoiceDataList(
                    invoiceDataList: invoiceDataList!,
                    cubit: cubit,
                  )
                : _EmptyListMessage(),
          ),
          const SizedBox(height: AppDimens.l),
          CustomRectangularButton.filled(
            text: LocaleKeys.yourData_addNewOption.tr(),
            onPressed: () => AutoRouter.of(context).push(DataInvoiceListFormPageRoute(
              refreshListOnPagePop: cubit.getInvoiceDataList,
            )),
          ),
          const SizedBox(height: AppDimens.xl),
        ],
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
        LocaleKeys.yourData_invoiceDataEmptyList.tr(),
        style: typography.body1.copyWith(color: colors.secondaryText),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _InvoiceDataList extends StatelessWidget {
  final List<InvoiceData> invoiceDataList;
  final DataInvoiceListPageCubit cubit;

  const _InvoiceDataList({
    required this.invoiceDataList,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return UserDataTile(
          title: '${invoiceDataList[index].name} ${invoiceDataList[index].surname}',
          isDefault: invoiceDataList[index].isDefault,
          content: invoiceDataList[index].buildContent(),
          onMoreTapped: () => showMore<InvoiceData>(
            context,
            invoiceDataList[index],
            cubit.ensureRemoval,
            cubit.setInvoiceDataAsDefault,
            (v) => _onEdit(context, v),
          ),
        );
      },
      itemCount: invoiceDataList.length,
    );
  }

  void _onEdit(BuildContext context, InvoiceData value) {
    AutoRouter.of(context).push(
      DataInvoiceListFormPageRoute(
        refreshListOnPagePop: cubit.getInvoiceDataList,
        invoiceData: value,
      ),
    );
  }
}
