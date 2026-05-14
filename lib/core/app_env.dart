class AppEnv {
  static const devName = 'dev';
  static const prodName = 'prod';

  static const apiUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://logpass.me/api/',
  );

  final String name;

  AppEnv._(this.name);

  factory AppEnv.development() {
    return AppEnv._(devName);
  }

  factory AppEnv.production() {
    return AppEnv._(prodName);
  }
}
