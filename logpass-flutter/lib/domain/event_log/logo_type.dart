import 'package:freezed_annotation/freezed_annotation.dart';

part 'logo_type.freezed.dart';

@freezed
class LogoType with _$LogoType {
  factory LogoType.network(String url) = _LogoTypeNetwork;

  factory LogoType.local(String path) = _LogoTypeLocal;

  factory LogoType.none() = _LogoTypeNone;
}