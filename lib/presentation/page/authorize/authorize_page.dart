import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/service/data/service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logpass_me/domain/model/scope.dart';
import 'package:logpass_me/domain/service/data/service_agreement.dart';
import 'package:logpass_me/domain/user_data/data/email.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/authorize/authorize_page_cubit.dart';
import 'package:logpass_me/presentation/page/authorize/scope_element.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/error_snackbar.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';
import 'package:logpass_me/presentation/widget/service_header.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';

const _arrowIconSize = 24.0;
const _elemenetIconSize = 20.0;

class AuthorizePage extends HookWidget {
  final String authorizationAttemptId;

  const AuthorizePage(this.authorizationAttemptId);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<AuthorizePageCubit>();
    final state = useCubitBuilder(cubit);
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    useCubitListener<AuthorizePageCubit, AuthorizePageState>(
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
      cubit.init(authorizationAttemptId);
    }, [cubit]);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: CustomAppBar.smallTitleOnly(
        title: LocaleKeys.authorize_title.tr(),
      ),
      body: state.maybeWhen(
        idle: (
          canConfirm,
          service,
          scopes,
          agreements,
        ) =>
            _PageContent(
          service: service,
          canConfirm: canConfirm,
          onConfirmCallback: cubit.approveAuthorizeAttempt,
          onDenyCallback: cubit.denyAuthorizeAttempt,
          scopeElements: scopes,
          agreementList: agreements,
        ),
        loading: () => const Loader(),
        orElse: () => const SizedBox(),
      ),
    );
  }

  void _cubitListener(
    AuthorizePageCubit cubit,
    AuthorizePageState state,
    BuildContext context,
    AppThemeColors colors,
    AppTypography typography,
  ) {
    state.maybeMap(
      confirmed: (state) async {
        await _redirect(state.redirectUri);
        await AutoRouter.of(context).pop();
      },
      denied: (state) async {
        await _redirect(state.redirectUri);
        await AutoRouter.of(context).pop();
      },
      biometricVerificationFailed: (state) async {
        showLocalErrorSnackBar(
          contentText: LocaleKeys.authorize_biometricVerificationFailed.tr(),
          context: context,
          colors: colors,
          typography: typography,
        );
      },
      connectionError: (state) async {
        showConnectionErrorSnackBar(
          error: state.error,
          context: context,
          colors: colors,
          typography: typography,
        );
        await AutoRouter.of(context).pop();
      },
      orElse: () {},
    );
  }

  Future<void> _redirect(String? redirectUri) async {
    if (redirectUri != null) {
      if (await canLaunch(redirectUri)) {
        await launch(redirectUri);
      }
    }
  }
}

class _PageContent extends StatelessWidget {
  final Service service;
  final bool canConfirm;
  final VoidCallback onConfirmCallback;
  final VoidCallback onDenyCallback;
  final List<ScopeElement> scopeElements;
  final List<ServiceAgreement> agreementList;

  const _PageContent({
    required this.service,
    required this.canConfirm,
    required this.onConfirmCallback,
    required this.onDenyCallback,
    required this.scopeElements,
    required this.agreementList,
  });

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
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _Form(
                      service,
                      scopeElements,
                      agreementList,
                    ),
                  ),
                  const SizedBox(height: AppDimens.xl),
                  CustomRectangularButton.filled(
                    text: LocaleKeys.authorize_confirm_button.tr(),
                    onPressed: canConfirm ? onConfirmCallback : null,
                  ),
                  const SizedBox(height: AppDimens.l),
                  CustomRectangularButton.outlined(
                    text: LocaleKeys.authorize_reject_button.tr(),
                    onPressed: onDenyCallback,
                  ),
                  const SizedBox(height: AppDimens.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Form extends StatelessWidget {
  final Service service;
  final List<ScopeElement> scopeElements;
  final List<ServiceAgreement> agreements;

  const _Form(this.service, this.scopeElements, this.agreements);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _ServiceRulesElement(agreements),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return _ScopeFormElement(
                scopeElements[index],
                service,
              );
            },
            itemCount: scopeElements.length,
          ),
          _TrustLevelElement(),
        ],
      ),
    );
  }
}

class _TrustLevelElement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _FormElement(
      title: LocaleKeys.authorize_trustLevelName.tr(),
      content: LocaleKeys.authorize_trustLevelDescription.tr(),
      imagePath: AppIcon.lock,
      contentHasError: false,
    );
  }
}

class _ServiceRulesElement extends StatelessWidget {
  final List<ServiceAgreement> agreements;

  const _ServiceRulesElement(this.agreements);

  @override
  Widget build(BuildContext context) {
    return _FormElement(
      title: LocaleKeys.authorize_serviceRules.tr(),
      imagePath: AppIcon.serviceRules,
      onTapAction: () {
        // TODO: handle navigation to service rules
      },
    );
  }
}

class _ScopeFormElement extends StatelessWidget {
  final ScopeElement element;
  final Service service;

  const _ScopeFormElement(this.element, this.service);

  @override
  Widget build(BuildContext context) {
    return _FormElement(
      title: element.name,
      imagePath: element.imagePath,
      onTapAction: _getOnTapAction(context, service),
      content: _getItemDescription(element),
      contentHasError: !element.isEligible,
    );
  }

  String _getItemDescription(ScopeElement element) {
    if (element.filledDescription != null) return element.filledDescription!;

    return (element.isEligible) ? element.hint : element.requiredHint;
  }

  VoidCallback? _getOnTapAction(BuildContext context, Service service) {
    switch (element.scope) {
      case Scope.address:
        return () async {
          final result = await AutoRouter.of(context).push<Email>(EmailSelectionPageRoute(service: service));
          if (result != null) {
            // TODO: handle picked address
          }
        };
      case Scope.email:
        return () async {
          final result = await AutoRouter.of(context).push<Email>(EmailSelectionPageRoute(service: service));
          if (result != null) {
            // TODO: handle picked email
          }
        };
      case Scope.invoice:
        return () async {
          final result = await AutoRouter.of(context).push<Email>(InvoiceDataSelectionPageRoute(service: service));
          if (result != null) {
            // TODO: handle picked invoice data
          }
        };
      default:
        break;
    }
  }
}

class _FormElement extends HookWidget {
  final String title;
  final String imagePath;
  final VoidCallback? onTapAction;
  final String? content;
  final bool? contentHasError;

  const _FormElement({
    required this.title,
    required this.imagePath,
    this.onTapAction,
    this.content,
    this.contentHasError,
  });

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final colors = useAppThemeColors();

    return InkWell(
      onTap: onTapAction,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.m),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: colors.dividerLight,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  imagePath,
                  color: colors.secondaryText,
                  width: _elemenetIconSize,
                  height: _elemenetIconSize,
                ),
                const SizedBox(width: AppDimens.l),
                Expanded(
                  child: Text(
                    title,
                    style: typography.body3,
                  ),
                ),
                SvgPicture.asset(
                  AppIcon.chevronRight,
                  color: colors.text,
                  width: _arrowIconSize,
                  height: _arrowIconSize,
                ),
              ],
            ),
            if (content != null && contentHasError != null) ...[
              const SizedBox(height: AppDimens.s),
              Text(
                content!,
                style: typography.info2.copyWith(
                  color: contentHasError! ? AppColors.requiredElementColor : colors.text,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
