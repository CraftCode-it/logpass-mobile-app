import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/page/get_safer/get_safer_cubit.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';

class GetSaferPage extends HookWidget {
  const GetSaferPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<GetSaferCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(() {
      cubit.initialize();
    }, [cubit]);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Get safer'),
      ),
      body: SafeArea(
        child: state.map(
          loading: (_) => const Center(
            child: CircularProgressIndicator(),
          ),
          idle: (state) => _Body(withBiometrics: state.withBiometrics),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final bool withBiometrics;

  const _Body({required this.withBiometrics, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Choose prefered login method to be sure that only you have access to this account.',
          textAlign: TextAlign.center,
        ),
        Spacer(),
        Text(
          'Allow this device to use biometrics for login verification',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimens.m),
        RoundedButton(
          text: 'Use biometric',
          onPressed: () {},
        ),
        const SizedBox(height: AppDimens.xl),
        Text(
          'or simply set unique PIN code ',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimens.m),
        RoundedButton(
          text: 'Set PIN code',
          onPressed: () {},
        ),
        const SizedBox(height: AppDimens.c),
        RoundedButton(
          text: 'Not now',
          onPressed: () {},
        ),
      ],
    );
  }
}
