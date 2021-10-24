import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/timed_wrapper/timed_wrapper_cubit.dart';

typedef TimedBuilderCallback = Widget Function(bool timePassed);

class TimedWrapper extends HookWidget {
  final TimedBuilderCallback builder;
  final DateTime timestamp;

  const TimedWrapper({
    required this.builder,
    required this.timestamp,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<TimedWrapperCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(() {
      cubit.initialize(timestamp);
    }, [cubit, timestamp]);

    return state.when(
      loading: () => const SizedBox(),
      ongoing: () => builder(false),
      passed: () => builder(true),
    );
  }
}
