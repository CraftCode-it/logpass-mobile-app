import 'package:dio/dio.dart';

/// With this approach we are getting rid of circular dependency in interceptor
abstract class InterceptorWithDio extends Interceptor {
  late Dio dio;

  void set(Dio dio) {
    this.dio = dio;
  }
}
