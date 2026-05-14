import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/service/data/service_agreement.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/authorize/agreement_content_preview/agreement_content_preview_page_cubit.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/custom_scaffold.dart';
import 'package:logpass_me/presentation/widget/error_snackbar.dart';
import 'package:logpass_me/presentation/widget/messenger/messenger.dart';
import 'package:pdfx/pdfx.dart';

@RoutePage()
class AgreementContentPreviewPage extends HookWidget {
  final ServiceAgreement serviceAgreement;

  const AgreementContentPreviewPage({required this.serviceAgreement, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<AgreementContentPreviewPageCubit>();
    final state = useCubitBuilder(cubit);
    final messengerController = useMessengerController();

    useCubitListener<AgreementContentPreviewPageCubit, AgreementContentPreviewPageState>(
      cubit,
      (cubit, state, context) => _cubitListener(cubit, state, context, messengerController),
    );

    useEffect(() {
      cubit.init(serviceAgreement);
    }, [cubit]);

    return CustomScaffold(
      appBar: CustomAppBar.smallTitle(
        title: LocaleKeys.agreementDetails_title.tr(),
        leading: NavigationButton.back(),
      ),
      body: Messenger(
        controller: messengerController,
        child: state.maybeMap(
          loading: (_) => const Loader(),
          idle: (state) => PdfView(
            controller: state.pdfDocument,
            scrollDirection: Axis.vertical,
          ),
          orElse: () => const SizedBox(),
        ),
      ),
      onErrorActionTapped: () => cubit.init(serviceAgreement),
      showErrorPage: state.maybeMap(
        error: (_) => true,
        orElse: () => false,
      ),
    );
  }

  void _cubitListener(
    AgreementContentPreviewPageCubit cubit,
    AgreementContentPreviewPageState state,
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
