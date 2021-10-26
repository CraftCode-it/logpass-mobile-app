import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/service/data/service.dart';
import 'package:logpass_me/domain/user_data/data/email.dart';
import 'package:logpass_me/exports.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/authorize/email_selection/email_selection_page_cubit.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/error_snackbar.dart';
import 'package:logpass_me/presentation/widget/messenger/messenger.dart';
import 'package:logpass_me/presentation/widget/radio_button_tile.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';
import 'package:logpass_me/presentation/widget/service_header.dart';

class EmailSelectionPage extends HookWidget {
  final Service service;
  final Email? email;
  final Function(Email) onPagePop;

  const EmailSelectionPage({
    required this.service,
    required this.onPagePop,
    this.email,
  });

  void _callOnPagePop(EmailSelectionPageState state) {
    final selectedEmail = state.maybeWhen(
      idle: (emails, selectedEmail) => selectedEmail,
      orElse: () {},
    );
    if (selectedEmail != null) onPagePop.call(selectedEmail);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<EmailSelectionPageCubit>();
    final state = useCubitBuilder(cubit);
    final colors = useAppThemeColors();
    final messengerController = useMessengerController();

    useCubitListener<EmailSelectionPageCubit, EmailSelectionPageState>(
      cubit,
          (cubit, state, context) =>
          _cubitListener(
            cubit,
            state,
            context,
            messengerController,
          ),
    );

    useEffect(() {
      cubit.init(email);
    }, [cubit]);

    return WillPopScope(
      onWillPop: () {
        _callOnPagePop(state);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: CustomAppBar.smallTitle(
          title: LocaleKeys.authorize_selectEmailTitle.tr(),
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
              idle: (emails,
                  selectedEmail,) =>
                  _Content(
                    service,
                    emails,
                    selectedEmail,
                    cubit,
                  ),
              loading: () => const Loader(),
              empty: () => _NoContent(cubit: cubit),
              orElse: () => const SizedBox(),
            ),
          ),
        ),
      ),
    );
  }

  void _cubitListener(EmailSelectionPageCubit cubit,
      EmailSelectionPageState state,
      BuildContext context,
      MessengerController controller,) {
    state.maybeMap(
      connectionError: (state) async {
        controller.showError(getConnectionErrorString(state.error));
      },
      orElse: () {},
    );
  }
}

class _NoContent extends StatelessWidget {
  final EmailSelectionPageCubit cubit;

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
              onPressed: () =>
                  AutoRouter.of(context).push(DataEmailsFormPageRoute(
                    refreshListOnPagePop: cubit.getEmailList,
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
  final List<Email> emails;
  final Email selectedEmail;
  final EmailSelectionPageCubit cubit;

  const _Content(this.service,
      this.emails,
      this.selectedEmail,
      this.cubit,);

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
              itemBuilder: (context, index) =>
                  RadioButtonTile(
                    title: emails[index].value,
                    isSelected: emails[index] == selectedEmail,
                    onTapAction: () => cubit.selectEmail(emails[index]),
                  ),
              itemCount: emails.length,
            ),
          ),
        ),

      ],
    );
  }
}
