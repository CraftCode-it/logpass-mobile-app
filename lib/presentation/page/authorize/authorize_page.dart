import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/oauth/data/client.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/authorize/authorize_page_cubit.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/error_snackbar.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';
import 'package:url_launcher/url_launcher.dart';

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
      body: state.maybeWhen(
        idle: (canConfirm, client) => _PageContent(
          client: client,
          canConfirm: canConfirm,
          onConfirmCallback: cubit.approveAuthorizeAttempt,
          onDenyCallback: cubit.denyAuthorizeAttempt,
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

class _PageContent extends HookWidget {
  final Client client;
  final bool canConfirm;
  final VoidCallback onConfirmCallback;
  final VoidCallback onDenyCallback;

  const _PageContent({
    required this.client,
    required this.canConfirm,
    required this.onConfirmCallback,
    required this.onDenyCallback,
  });

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                LocaleKeys.authorize_title,
                textAlign: TextAlign.center,
                style: typography.h8.copyWith(),
              ).tr(),
            ),
            const SizedBox(height: AppDimens.xl),
            _ClientHeader(client: client),
            const SizedBox(height: AppDimens.xl),
            Expanded(child: _AuthorizationForm()),
            const SizedBox(height: AppDimens.xl),
            CustomRectangularButton.filled(
              text: LocaleKeys.authorize_confirm_button.tr(),
              onPressed: onConfirmCallback,
            ),
            const SizedBox(height: AppDimens.l),
            CustomRectangularButton.outlined(
              text: LocaleKeys.authorize_reject_button.tr(),
              onPressed: onDenyCallback,
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthorizationForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Placeholder(
        fallbackWidth: double.infinity,
        fallbackHeight: 720,
      ),
    );
  }
}

class _ClientHeader extends StatelessWidget {
  final Client client;

  const _ClientHeader({
    required this.client,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await launch(client.url);
      },
      child: Container(
        height: AppDimens.c,
        decoration: ShapeDecoration(
          shape: Border.all(
            color: Colors.grey,
          ),
        ),
        padding: const EdgeInsets.all(AppDimens.s),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(client.logo),
            const SizedBox(width: AppDimens.m),
            Text(client.name),
          ],
        ),
      ),
    );
  }
}
