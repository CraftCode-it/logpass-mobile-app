import 'package:bloc/bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    print('SBO Log: ${bloc.runtimeType} has $change');
    super.onChange(bloc, change);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('SBO Log: ${bloc.runtimeType} $error $stackTrace');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    print('SBO Log: ${bloc.runtimeType} closed');
    super.onClose(bloc);
  }

  @override
  void onCreate(BlocBase bloc) {
    print('SBO Log: ${bloc.runtimeType} created');
    super.onCreate(bloc);
  }
}
