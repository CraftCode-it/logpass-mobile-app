import 'package:injectable/injectable.dart';
import 'package:libphonenumber/libphonenumber.dart';
import 'package:logpass_me/domain/model/phone_number/phone_number.dart';

@Injectable()
class PhoneNumberValidator {
  Future<bool> isValid(PhoneNumber phoneNumber) async {
    if (phoneNumber.number.isEmpty) return false;

    final fullPhoneNumber = phoneNumber.countryCode + phoneNumber.number;

    final isValid = await PhoneNumberUtil.isValidPhoneNumber(
      phoneNumber: fullPhoneNumber,
      isoCode: phoneNumber.country,
    );

    return isValid ?? false;
  }
}
