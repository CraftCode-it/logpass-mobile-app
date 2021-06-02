import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/country_code/country_code.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/widget/country_code_picker/country_code_picker_cubit.dart';
import 'package:logpass_me/presentation/widget/country_code_picker/country_code_picker_state.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

class CountryCodePicker extends HookWidget {
  final Function(CountryCode countryCode) onCountryCodeSelected;

  const CountryCodePicker({
    required this.onCountryCodeSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<CountryCodePickerCubit>();
    final state = useCubitBuilder(cubit);

    useCubitListener(cubit, (CountryCodePickerCubit cubit, CountryCodePickerState state, context) {
      state.maybeWhen(
        selectedEvent: onCountryCodeSelected,
        orElse: () {},
      );
    });

    useEffect(() {
      cubit.initialize(_getSystemLocale());
    }, [cubit]);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Prefix'),
        ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: AppDimens.inputHeight,
            maxHeight: AppDimens.inputHeight,
            minWidth: AppDimens.minCodeInputWidth,
          ),
          child: GestureDetector(
            onTap: _onPressed(state, context, cubit),
            child: Container(
              height: AppDimens.inputHeight,
              child: Align(
                alignment: Alignment.centerLeft,
                child: state.maybeMap(
                  loading: (state) => const Center(child: CircularProgressIndicator()),
                  selected: (state) => Text('+${state.countryCode.code}'),
                  orElse: () {},
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Function()? _onPressed(CountryCodePickerState state, BuildContext context, CountryCodePickerCubit cubit) {
    return state.maybeMap(
      selected: (state) {
        return () async {
          final selectedCountry = await AutoRouter.of(context).push<CountryCode?>(
            CountryCodePickerPageRoute(
              countryCodeList: state.countryCodeList,
              selectedCountryCode: state.countryCode,
            ),
          );

          if (selectedCountry != null) {
            cubit.select(selectedCountry);
          }
        };
      },
      orElse: () => null,
    );
  }
}

String _getSystemLocale() {
  try {
    return Platform.localeName.split('_').last;
  } catch (e, s) {
    Fimber.e('Getting system locale failed', ex: e, stacktrace: s);
    return 'PL';
  }
}
