import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/core/app_env.dart';
import 'package:logpass_me/core/di/di_config.config.dart';

final getIt = GetIt.instance;

const dev = Environment(AppEnv.devName);
const prod = Environment(AppEnv.prodName);

@InjectableInit(
  preferRelativeImports: false,
)
Future<void> configureDependencies(String env) => $initGetIt(getIt, environment: env);
