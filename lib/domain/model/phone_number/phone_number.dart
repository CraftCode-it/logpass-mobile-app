import 'package:freezed_annotation/freezed_annotation.dart';

part 'phone_number.freezed.dart';

@freezed
class PhoneNumber with _$PhoneNumber {
  factory PhoneNumber({
    @Default('') String countryCode,
    @Default('') String number,
    @Default('') String country,
  }) = _PhoneNumber;

  const PhoneNumber._();

  String fullPhoneNumber() => '+$countryCode$number';
}
