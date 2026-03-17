import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_exception.freezed.dart';

@freezed
class AuthException with _$AuthException implements Exception {
  factory AuthException.notSignedIn() = AuthExceptionUserNotSignedIn;

  factory AuthException.refreshTokenExpired() = AuthExceptionRefreshTokenExpired;
}
