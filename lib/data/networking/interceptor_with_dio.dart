import 'package:dio/dio.dart';

/// With this approach we are getting rid of circular dependency in interceptor.
/// Extends QueuedInterceptor so requests are serialized (replaces Dio v4 locks).
abstract class InterceptorWithDio extends QueuedInterceptor {
  late Dio dio;

  void set(Dio dio) {
    this.dio = dio;
  }
}
