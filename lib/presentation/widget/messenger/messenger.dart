import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/messenger/message_view.dart';
import 'package:logpass_me/presentation/widget/messenger/messenger_cubit.dart';
import 'package:logpass_me/presentation/widget/messenger/messenger_state.dart';

part 'messenger_controller.dart';

class Messenger extends HookWidget {
  final MessengerController controller;
  final Widget child;
  final bool floating;

  const Messenger({
    required this.controller,
    required this.child,
    this.floating = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<MessengerCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    useEffect(
      () {
        controller._infoListener = cubit.showInfo;
        controller._errorListener = cubit.showError;
        return controller._clearListeners;
      },
      [controller],
    );

    final message = _getMessage(context, cubit, state);

    return floating
        ? _FloatingMessenger(
            message: message,
            child: child,
          )
        : _FlatMessenger(
            message: message,
            child: child,
          );
  }

  Widget _getMessage(BuildContext context, MessengerCubit cubit, MessengerState state) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: state.map(
        idle: (state) => const SizedBox.shrink(),
        info: (state) => InfoMessage(
          key: ValueKey(state),
          content: state.message,
          onDismiss: cubit.dismissCurrent,
          action: state.action,
          onAction: state.onAction,
        ),
        error: (state) => ErrorMessage(
          key: ValueKey(state),
          content: state.message,
        ),
        action: (state) => InfoMessage(
          key: ValueKey(state),
          content: LocaleKeys.main_newAction.tr(),
          onDismiss: cubit.dismissCurrent,
          action: LocaleKeys.main_openActionLabel.tr(),
          onAction: () {
            AutoRouter.of(context).push(
              AuthorizePageRoute(authorizationAttemptId: state.action.actionId),
            );
          },
        ),
      ),
    );
  }
}

class _FloatingMessenger extends StatelessWidget {
  final Widget child;
  final Widget message;

  const _FloatingMessenger({
    required this.child,
    required this.message,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: message,
        ),
      ],
    );
  }
}

class _FlatMessenger extends StatelessWidget {
  final Widget child;
  final Widget message;

  const _FlatMessenger({
    required this.child,
    required this.message,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: child),
        message,
      ],
    );
  }
}
