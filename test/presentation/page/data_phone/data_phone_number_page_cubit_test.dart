import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/domain/user_data/use_case/get_user_phone_number_use_case.dart';
import 'package:logpass_me/presentation/page/data_phone_page/data_phone_number_page_cubit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'data_phone_number_page_cubit_test.mocks.dart';

@GenerateMocks(
  [
    GetUserPhoneNumberUseCase,
  ],
)
void main() {
  late MockGetUserPhoneNumberUseCase getUserPhoneNumberUseCase;
  late DataPhoneNumberPageCubit cubit;

  setUp(() {
    getUserPhoneNumberUseCase = MockGetUserPhoneNumberUseCase();
    cubit = DataPhoneNumberPageCubit(getUserPhoneNumberUseCase);
  });

  const phoneNumber = '000000000';

  group('initialize', () {
    blocTest<DataPhoneNumberPageCubit, DataPhoneNumberPageState>(
      'initialize not empty phone number',
      build: () {
        when(getUserPhoneNumberUseCase()).thenAnswer((value) async => phoneNumber);
        return cubit;
      },
      act: (cubit) => cubit.initialize(),
      expect: () =>
      [
        DataPhoneNumberPageState.idle(phoneNumber),
      ],
    );

    blocTest<DataPhoneNumberPageCubit, DataPhoneNumberPageState>(
      'initialize empty phone number',
      build: () {
        when(getUserPhoneNumberUseCase()).thenAnswer((value) async => null);
        return cubit;
      },
      act: (cubit) => cubit.initialize(),
      expect: () =>
      [
        DataPhoneNumberPageState.empty(),
      ],
    );
  });

}