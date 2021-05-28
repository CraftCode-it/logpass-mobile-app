import 'package:freezed_annotation/freezed_annotation.dart';

part 'phone_number.freezed.dart';

@freezed
class PhoneNumber with _$PhoneNumber {
  factory PhoneNumber({
    required String countryCode,
    required String number,
    required String country,
  }) = _PhoneNumber;
}
