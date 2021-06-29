import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/service/data/service.dart';
import 'package:logpass_me/domain/user_data/data/invoice_data.dart';
import 'package:logpass_me/presentation/page/authorize/invoice_data_selection/invoice_data_selection_page_cubit.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:logpass_me/presentation/widget/error_snackbar.dart';
import 'package:logpass_me/presentation/widget/radio_button_tile.dart';
import 'package:logpass_me/presentation/widget/service_header.dart';

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
    final typography = useAppTypography();

    useCubitListener<InvoiceDataSelectionPageCubit, InvoiceDataSelectionPageState>(
      cubit,
      (cubit, state, context) => _cubitListener(
        cubit,
        state,
        context,
        colors,
        typography,
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
        body: state.maybeWhen(
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
          loading: () => const Loader(),
          orElse: () => const SizedBox(),
        ),
      ),
    );
  }

  void _cubitListener(
    InvoiceDataSelectionPageCubit cubit,
    InvoiceDataSelectionPageState state,
    BuildContext context,
    AppThemeColors colors,
    AppTypography typography,
  ) {
    state.maybeMap(
      connectionError: (state) async {
        showConnectionErrorSnackBar(
          error: state.error,
          context: context,
          colors: colors,
          typography: typography,
        );
      },
      orElse: () {},
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

  String _buildTileContent(InvoiceData data) {
    if (data.apartmentNumber != null) {
      return '${data.street} ${data.buildingNumber}/${data.apartmentNumber}\n${data.postCode} ${data.city}';
    }
    return '${data.street} ${data.buildingNumber}\n${data.postCode} ${data.city}';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
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
                  content: _buildTileContent(invoiceDatas[index]),
                  isSelected: invoiceDatas[index] == selectedInvoiceData,
                  onTapAction: () => cubit.selectInvoiceData(invoiceDatas[index]),
                ),
                itemCount: invoiceDatas.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
