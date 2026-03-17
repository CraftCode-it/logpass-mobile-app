import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/service/data/service.dart';
import 'package:logpass_me/domain/user_data/data/invoice_data.dart';
import 'package:logpass_me/exports.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/authorize/invoice_data_selection/invoice_data_selection_page_cubit.dart';
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

@RoutePage()
class InvoiceDataSelectionPage extends HookWidget {
  final Service service;
  final InvoiceData? invoiceData;
  final Function(InvoiceData) onPagePop;

  const InvoiceDataSelectionPage({
    required this.service,
    required this.onPagePop,
    this.invoiceData,
  });

  void _callOnPagePop(InvoiceDataSelectionPageState state) {
    final invoice = state.maybeWhen(
      idle: (invoiceDatas, selectedInvoiceData) => selectedInvoiceData,
      orElse: () {},
    );
    if (invoice != null) onPagePop.call(invoice);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<InvoiceDataSelectionPageCubit>();
    final state = useCubitBuilder(cubit);
    final colors = useAppThemeColors();
    final messengerController = useMessengerController();

    useCubitListener<InvoiceDataSelectionPageCubit, InvoiceDataSelectionPageState>(
      cubit,
      (cubit, state, context) => _cubitListener(
        cubit,
        state,
        context,
        messengerController,
      ),
    );

    useEffect(() {
      cubit.init(invoiceData);
    }, [cubit]);

    return WillPopScope(
      onWillPop: () {
        _callOnPagePop(state);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: CustomAppBar.smallTitle(
          title: LocaleKeys.authorize_selectInvoiceData.tr(),
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
              idle: (
                invoiceDatas,
                selectedInvoiceData,
              ) =>
                  _Content(
                service,
                invoiceDatas,
                selectedInvoiceData,
                cubit,
              ),
              empty: () => _NoContent(
                cubit: cubit,
              ),
              loading: () => const Loader(),
              orElse: () => const SizedBox(),
            ),
          ),
        ),
      ),
    );
  }

  void _cubitListener(
    InvoiceDataSelectionPageCubit cubit,
    InvoiceDataSelectionPageState state,
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
  final InvoiceDataSelectionPageCubit cubit;

  const _NoContent({
    required this.cubit,
    Key? key,
  }) : super(key: key);

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
              onPressed: () => AutoRouter.of(context).push(
                DataInvoiceListFormPageRoute(refreshListOnPagePop: cubit.getInvoiceData),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final Service service;
  final List<InvoiceData> invoiceDatas;
  final InvoiceData selectedInvoiceData;
  final InvoiceDataSelectionPageCubit cubit;

  const _Content(
    this.service,
    this.invoiceDatas,
    this.selectedInvoiceData,
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
              itemBuilder: (context, index) => RadioButtonTile(
                title: '${invoiceDatas[index].name} ${invoiceDatas[index].surname}',
                content: invoiceDatas[index].buildContent(),
                isSelected: invoiceDatas[index] == selectedInvoiceData,
                onTapAction: () => cubit.selectInvoiceData(invoiceDatas[index]),
              ),
              itemCount: invoiceDatas.length,
            ),
          ),
        ),
      ],
    );
  }
}
