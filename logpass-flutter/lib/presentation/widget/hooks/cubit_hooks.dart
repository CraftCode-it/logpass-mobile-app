import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/core/di/di_config.dart';

abstract class BuildState {}

typedef BlocBuilderCondition<S> = bool Function(S current);
typedef BlocListener<BLOC extends Cubit<S>, S> = void Function(BLOC cubit, S current, BuildContext context);

class _CubitDefaults {
  static bool defaultBlocBuilderCondition<S>(S state) => state is BuildState;

  static bool defaultBlocListenCondition<S>(S state) => true;
}

T useCubit<T extends Cubit>([List<dynamic> keys = const <dynamic>[]]) {
  final cubit = useMemoized(() => getIt<T>(), keys);
  useEffect(() => cubit.close, [cubit]);
  return cubit;
}

T useCubitWithParams<T extends Cubit>(param1, param2, [List<dynamic> keys = const <dynamic>[]]) {
  final cubit = useMemoized(() => getIt.get<T>(param1: param1, param2: param2), keys);
  useEffect(() => cubit.close, [cubit]);
  return cubit;
}

S useCubitBuilder<C extends Cubit, S>(
  Cubit<S> cubit, {
  BlocBuilderCondition<S>? buildWhen,
}) {
  final buildWhenConditioner = buildWhen;
  final state = useMemoized(
    () => cubit.stream.where(buildWhenConditioner ?? _CubitDefaults.defaultBlocBuilderCondition),
    [cubit.state],
  );
  return useStream(state, initialData: cubit.state).requireData!;
}

void useCubitListener<BLOC extends Cubit<S>, S>(
  BLOC bloc,
  BlocListener<BLOC, S> listener, {
  BlocBuilderCondition<S>? listenWhen,
}) {
  final context = useContext();
  final listenWhenConditioner = listenWhen;
  useMemoized(() {
    final stream = bloc.stream
        .where(listenWhenConditioner ?? _CubitDefaults.defaultBlocListenCondition)
        .listen((state) => listener(bloc, state, context));
    return stream.cancel;
  }, [bloc]);
}
