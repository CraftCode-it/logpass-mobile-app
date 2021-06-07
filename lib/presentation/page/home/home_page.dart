import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/page/home/home_cubit.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

class HomePage extends HookWidget {
  bool _shouldBuild(HomeState state) => state is LoadInProgress || state is Idle || state is Error;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<HomeCubit>();
    final state = useCubitBuilder(cubit, buildWhen: _shouldBuild);

    useEffect(() {
      cubit.init();
      return;
    }, [cubit]);

    return Scaffold(
      body: state.maybeWhen(
        idle: (oneTimeCode) {
          return Center(
            child: Text(oneTimeCode.code),
          );
        },
        loadInProgress: () => const Center(
          child: CircularProgressIndicator(),
        ),
        orElse: () => const Text('orElse'),
      ),
    );
  }
}
