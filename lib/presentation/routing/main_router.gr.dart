// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'main_router.dart';

abstract class _$MainRouter extends RootStackRouter {
  // ignore: unused_element
  _$MainRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AddNewDeviceCodeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AddNewDeviceCodePage(),
      );
    },
    AddNewDeviceRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AddNewDevicePage(),
      );
    },
    AddressSelectionRoute.name: (routeData) {
      final args = routeData.argsAs<AddressSelectionRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AddressSelectionPage(
          service: args.service,
          onPagePop: args.onPagePop,
          address: args.address,
        ),
      );
    },
    AgreementContentPreviewRoute.name: (routeData) {
      final args = routeData.argsAs<AgreementContentPreviewRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AgreementContentPreviewPage(
          serviceAgreement: args.serviceAgreement,
          key: args.key,
        ),
      );
    },
    AgreementDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<AgreementDetailsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AgreementDetailsPage(
          serviceAgreement: args.serviceAgreement,
          key: args.key,
        ),
      );
    },
    AuthorizeRoute.name: (routeData) {
      final args = routeData.argsAs<AuthorizeRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AuthorizePage(args.incomingAction),
      );
    },
    ChangeDeviceNameRoute.name: (routeData) {
      final args = routeData.argsAs<ChangeDeviceNameRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ChangeDeviceNamePage(
          currentName: args.currentName,
          onNameChanged: args.onNameChanged,
          key: args.key,
        ),
      );
    },
    ConfirmRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ConfirmPage(),
      );
    },
    ConfirmPinRoute.name: (routeData) {
      final args = routeData.argsAs<ConfirmPinRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ConfirmPinPage(
          pin: args.pin,
          key: args.key,
        ),
      );
    },
    ConfirmWithPinRoute.name: (routeData) {
      final args = routeData.argsAs<ConfirmWithPinRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ConfirmWithPinPage(
          title: args.title,
          button: args.button,
          key: args.key,
        ),
      );
    },
    CountryCodePickerRoute.name: (routeData) {
      final args = routeData.argsAs<CountryCodePickerRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CountryCodePickerPage(
          countryCodeList: args.countryCodeList,
          selectedCountryCode: args.selectedCountryCode,
          includeCountryCodes: args.includeCountryCodes,
          onCountrySelected: args.onCountrySelected,
          key: args.key,
        ),
      );
    },
    CredentialDetailRoute.name: (routeData) {
      final args = routeData.argsAs<CredentialDetailRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CredentialDetailPage(
          key: args.key,
          credential: args.credential,
        ),
      );
    },
    DataAddressesFormRoute.name: (routeData) {
      final args = routeData.argsAs<DataAddressesFormRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DataAddressesFormPage(
          refreshListOnPagePop: args.refreshListOnPagePop,
          addressToEdit: args.addressToEdit,
          key: args.key,
        ),
      );
    },
    DataAddressesRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DataAddressesPage(),
      );
    },
    DataEmailsFormRoute.name: (routeData) {
      final args = routeData.argsAs<DataEmailsFormRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DataEmailsFormPage(
          refreshListOnPagePop: args.refreshListOnPagePop,
          email: args.email,
          key: args.key,
        ),
      );
    },
    DataEmailsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DataEmailsPage(),
      );
    },
    DataInvoiceListFormRoute.name: (routeData) {
      final args = routeData.argsAs<DataInvoiceListFormRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DataInvoiceListFormPage(
          refreshListOnPagePop: args.refreshListOnPagePop,
          invoiceData: args.invoiceData,
          key: args.key,
        ),
      );
    },
    DataInvoiceListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DataInvoiceListPage(),
      );
    },
    DataPersonalFormRoute.name: (routeData) {
      final args = routeData.argsAs<DataPersonalFormRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DataPersonalFormPage(
          refreshListOnPagePop: args.refreshListOnPagePop,
          personalData: args.personalData,
          key: args.key,
        ),
      );
    },
    DataPersonalRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DataPersonalPage(),
      );
    },
    DataPhoneNumberRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DataPhoneNumberPage(),
      );
    },
    DeviceListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DeviceListPage(),
      );
    },
    EmailSelectionRoute.name: (routeData) {
      final args = routeData.argsAs<EmailSelectionRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EmailSelectionPage(
          service: args.service,
          onPagePop: args.onPagePop,
          email: args.email,
        ),
      );
    },
    EntryRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EntryPage(),
      );
    },
    EventLogRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const EventLogPage(),
      );
    },
    GetSaferRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const GetSaferPage(),
      );
    },
    HistoricalSessionListRoute.name: (routeData) {
      final args = routeData.argsAs<HistoricalSessionListRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: HistoricalSessionListPage(
          service: args.service,
          key: args.key,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomePage(),
      );
    },
    InvoiceDataSelectionRoute.name: (routeData) {
      final args = routeData.argsAs<InvoiceDataSelectionRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: InvoiceDataSelectionPage(
          service: args.service,
          onPagePop: args.onPagePop,
          invoiceData: args.invoiceData,
        ),
      );
    },
    LanguageRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LanguagePage(),
      );
    },
    LoginResetRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginResetPage(),
      );
    },
    LoginSuccessRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginSuccessPage(),
      );
    },
    MainRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MainPage(),
      );
    },
    NeedHelpRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NeedHelpPage(),
      );
    },
    NewPinRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NewPinPage(),
      );
    },
    OTPCodeRoute.name: (routeData) {
      final args = routeData.argsAs<OTPCodeRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: OTPCodePage(
          phoneNumber: args.phoneNumber,
          verification: args.verification,
          key: args.key,
        ),
      );
    },
    OnboardingRoute.name: (routeData) {
      final args = routeData.argsAs<OnboardingRouteArgs>(
          orElse: () => const OnboardingRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: OnboardingPage(
          logoutMessage: args.logoutMessage,
          key: args.key,
        ),
      );
    },
    PersonalDataSelectionRoute.name: (routeData) {
      final args = routeData.argsAs<PersonalDataSelectionRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PersonalDataSelectionPage(
          service: args.service,
          onPagePop: args.onPagePop,
          personalData: args.personalData,
        ),
      );
    },
    PinSuccessRoute.name: (routeData) {
      final args = routeData.argsAs<PinSuccessRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PinSuccessPage(
          route: args.route,
          title: args.title,
          key: args.key,
        ),
      );
    },
    ProofPresentationRoute.name: (routeData) {
      final args = routeData.argsAs<ProofPresentationRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ProofPresentationPage(
          key: args.key,
          credential: args.credential,
          proofData: args.proofData,
        ),
      );
    },
    QrScanRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const QrScanPage(),
      );
    },
    QuestionRoute.name: (routeData) {
      final args = routeData.argsAs<QuestionRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: QuestionPage(
          question: args.question,
          key: args.key,
        ),
      );
    },
    ResetAccountRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ResetAccountPage(),
      );
    },
    SecuredLoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SecuredLoginPage(),
      );
    },
    SecuritySettingsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SecuritySettingsPage(),
      );
    },
    ServiceDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<ServiceDetailsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ServiceDetailsPage(
          service: args.service,
          key: args.key,
        ),
      );
    },
    ServiceListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ServiceListPage(),
      );
    },
    ServiceRulesRoute.name: (routeData) {
      final args = routeData.argsAs<ServiceRulesRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ServiceRulesPage(
          agreements: args.agreements,
          service: args.service,
          onPagePop: args.onPagePop,
        ),
      );
    },
    SettingsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingsPage(),
      );
    },
    StartRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const StartPage(),
      );
    },
    TermsAndConditionsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TermsAndConditionsPage(),
      );
    },
    TrustLevelConfirmationRoute.name: (routeData) {
      final args = routeData.argsAs<TrustLevelConfirmationRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TrustLevelConfirmationPage(
          service: args.service,
          initialTrustLevel: args.initialTrustLevel,
          requiredTrustLevel: args.requiredTrustLevel,
          onPagePop: args.onPagePop,
        ),
      );
    },
    TrustLevelRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TrustLevelPage(),
      );
    },
    VerificationRequestRoute.name: (routeData) {
      final args = routeData.argsAs<VerificationRequestRouteArgs>(
          orElse: () => const VerificationRequestRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: VerificationRequestPage(
          key: args.key,
          requestId: args.requestId,
          verifierName: args.verifierName,
          requestType: args.requestType,
          minAge: args.minAge,
          allowGuardian: args.allowGuardian,
        ),
      );
    },
    WalletHomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const WalletHomePage(),
      );
    },
    YourDataRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const YourDataPage(),
      );
    },
    IdentityRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const IdentityPage(),
      );
    },
    GuardianRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const GuardianPage(),
      );
    },
    GuardianApprovalRoute.name: (routeData) {
      final args = routeData.argsAs<GuardianApprovalRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: GuardianApprovalPage(
          requestId: args.requestId,
          approvalType: args.approvalType,
          guardianName: args.guardianName,
          guardianPhone: args.guardianPhone,
          minorName: args.minorName,
          minorPhone: args.minorPhone,
          serviceName: args.serviceName,
          action: args.action,
          expiresInSeconds: args.expiresInSeconds,
          key: args.key,
        ),
      );
    },
  };
}

/// generated route for
/// [AddNewDeviceCodePage]
class AddNewDeviceCodeRoute extends PageRouteInfo<void> {
  const AddNewDeviceCodeRoute({List<PageRouteInfo>? children})
      : super(
          AddNewDeviceCodeRoute.name,
          initialChildren: children,
        );

  static const String name = 'AddNewDeviceCodeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AddNewDevicePage]
class AddNewDeviceRoute extends PageRouteInfo<void> {
  const AddNewDeviceRoute({List<PageRouteInfo>? children})
      : super(
          AddNewDeviceRoute.name,
          initialChildren: children,
        );

  static const String name = 'AddNewDeviceRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AddressSelectionPage]
class AddressSelectionRoute extends PageRouteInfo<AddressSelectionRouteArgs> {
  AddressSelectionRoute({
    required Service service,
    required dynamic Function(Address) onPagePop,
    Address? address,
    List<PageRouteInfo>? children,
  }) : super(
          AddressSelectionRoute.name,
          args: AddressSelectionRouteArgs(
            service: service,
            onPagePop: onPagePop,
            address: address,
          ),
          initialChildren: children,
        );

  static const String name = 'AddressSelectionRoute';

  static const PageInfo<AddressSelectionRouteArgs> page =
      PageInfo<AddressSelectionRouteArgs>(name);
}

class AddressSelectionRouteArgs {
  const AddressSelectionRouteArgs({
    required this.service,
    required this.onPagePop,
    this.address,
  });

  final Service service;

  final dynamic Function(Address) onPagePop;

  final Address? address;

  @override
  String toString() {
    return 'AddressSelectionRouteArgs{service: $service, onPagePop: $onPagePop, address: $address}';
  }
}

/// generated route for
/// [AgreementContentPreviewPage]
class AgreementContentPreviewRoute
    extends PageRouteInfo<AgreementContentPreviewRouteArgs> {
  AgreementContentPreviewRoute({
    required ServiceAgreement serviceAgreement,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          AgreementContentPreviewRoute.name,
          args: AgreementContentPreviewRouteArgs(
            serviceAgreement: serviceAgreement,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'AgreementContentPreviewRoute';

  static const PageInfo<AgreementContentPreviewRouteArgs> page =
      PageInfo<AgreementContentPreviewRouteArgs>(name);
}

class AgreementContentPreviewRouteArgs {
  const AgreementContentPreviewRouteArgs({
    required this.serviceAgreement,
    this.key,
  });

  final ServiceAgreement serviceAgreement;

  final Key? key;

  @override
  String toString() {
    return 'AgreementContentPreviewRouteArgs{serviceAgreement: $serviceAgreement, key: $key}';
  }
}

/// generated route for
/// [AgreementDetailsPage]
class AgreementDetailsRoute extends PageRouteInfo<AgreementDetailsRouteArgs> {
  AgreementDetailsRoute({
    required ServiceAgreement serviceAgreement,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          AgreementDetailsRoute.name,
          args: AgreementDetailsRouteArgs(
            serviceAgreement: serviceAgreement,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'AgreementDetailsRoute';

  static const PageInfo<AgreementDetailsRouteArgs> page =
      PageInfo<AgreementDetailsRouteArgs>(name);
}

class AgreementDetailsRouteArgs {
  const AgreementDetailsRouteArgs({
    required this.serviceAgreement,
    this.key,
  });

  final ServiceAgreement serviceAgreement;

  final Key? key;

  @override
  String toString() {
    return 'AgreementDetailsRouteArgs{serviceAgreement: $serviceAgreement, key: $key}';
  }
}

/// generated route for
/// [AuthorizePage]
class AuthorizeRoute extends PageRouteInfo<AuthorizeRouteArgs> {
  AuthorizeRoute({
    required IncomingAction incomingAction,
    List<PageRouteInfo>? children,
  }) : super(
          AuthorizeRoute.name,
          args: AuthorizeRouteArgs(incomingAction: incomingAction),
          initialChildren: children,
        );

  static const String name = 'AuthorizeRoute';

  static const PageInfo<AuthorizeRouteArgs> page =
      PageInfo<AuthorizeRouteArgs>(name);
}

class AuthorizeRouteArgs {
  const AuthorizeRouteArgs({required this.incomingAction});

  final IncomingAction incomingAction;

  @override
  String toString() {
    return 'AuthorizeRouteArgs{incomingAction: $incomingAction}';
  }
}

/// generated route for
/// [ChangeDeviceNamePage]
class ChangeDeviceNameRoute extends PageRouteInfo<ChangeDeviceNameRouteArgs> {
  ChangeDeviceNameRoute({
    required String currentName,
    required dynamic Function(String) onNameChanged,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ChangeDeviceNameRoute.name,
          args: ChangeDeviceNameRouteArgs(
            currentName: currentName,
            onNameChanged: onNameChanged,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ChangeDeviceNameRoute';

  static const PageInfo<ChangeDeviceNameRouteArgs> page =
      PageInfo<ChangeDeviceNameRouteArgs>(name);
}

class ChangeDeviceNameRouteArgs {
  const ChangeDeviceNameRouteArgs({
    required this.currentName,
    required this.onNameChanged,
    this.key,
  });

  final String currentName;

  final dynamic Function(String) onNameChanged;

  final Key? key;

  @override
  String toString() {
    return 'ChangeDeviceNameRouteArgs{currentName: $currentName, onNameChanged: $onNameChanged, key: $key}';
  }
}

/// generated route for
/// [ConfirmPage]
class ConfirmRoute extends PageRouteInfo<void> {
  const ConfirmRoute({List<PageRouteInfo>? children})
      : super(
          ConfirmRoute.name,
          initialChildren: children,
        );

  static const String name = 'ConfirmRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ConfirmPinPage]
class ConfirmPinRoute extends PageRouteInfo<ConfirmPinRouteArgs> {
  ConfirmPinRoute({
    required String pin,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ConfirmPinRoute.name,
          args: ConfirmPinRouteArgs(
            pin: pin,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ConfirmPinRoute';

  static const PageInfo<ConfirmPinRouteArgs> page =
      PageInfo<ConfirmPinRouteArgs>(name);
}

class ConfirmPinRouteArgs {
  const ConfirmPinRouteArgs({
    required this.pin,
    this.key,
  });

  final String pin;

  final Key? key;

  @override
  String toString() {
    return 'ConfirmPinRouteArgs{pin: $pin, key: $key}';
  }
}

/// generated route for
/// [ConfirmWithPinPage]
class ConfirmWithPinRoute extends PageRouteInfo<ConfirmWithPinRouteArgs> {
  ConfirmWithPinRoute({
    required String title,
    required String button,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ConfirmWithPinRoute.name,
          args: ConfirmWithPinRouteArgs(
            title: title,
            button: button,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ConfirmWithPinRoute';

  static const PageInfo<ConfirmWithPinRouteArgs> page =
      PageInfo<ConfirmWithPinRouteArgs>(name);
}

class ConfirmWithPinRouteArgs {
  const ConfirmWithPinRouteArgs({
    required this.title,
    required this.button,
    this.key,
  });

  final String title;

  final String button;

  final Key? key;

  @override
  String toString() {
    return 'ConfirmWithPinRouteArgs{title: $title, button: $button, key: $key}';
  }
}

/// generated route for
/// [CountryCodePickerPage]
class CountryCodePickerRoute extends PageRouteInfo<CountryCodePickerRouteArgs> {
  CountryCodePickerRoute({
    required List<CountryCode> countryCodeList,
    required CountryCode selectedCountryCode,
    required bool includeCountryCodes,
    required dynamic Function(CountryCode) onCountrySelected,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          CountryCodePickerRoute.name,
          args: CountryCodePickerRouteArgs(
            countryCodeList: countryCodeList,
            selectedCountryCode: selectedCountryCode,
            includeCountryCodes: includeCountryCodes,
            onCountrySelected: onCountrySelected,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'CountryCodePickerRoute';

  static const PageInfo<CountryCodePickerRouteArgs> page =
      PageInfo<CountryCodePickerRouteArgs>(name);
}

class CountryCodePickerRouteArgs {
  const CountryCodePickerRouteArgs({
    required this.countryCodeList,
    required this.selectedCountryCode,
    required this.includeCountryCodes,
    required this.onCountrySelected,
    this.key,
  });

  final List<CountryCode> countryCodeList;

  final CountryCode selectedCountryCode;

  final bool includeCountryCodes;

  final dynamic Function(CountryCode) onCountrySelected;

  final Key? key;

  @override
  String toString() {
    return 'CountryCodePickerRouteArgs{countryCodeList: $countryCodeList, selectedCountryCode: $selectedCountryCode, includeCountryCodes: $includeCountryCodes, onCountrySelected: $onCountrySelected, key: $key}';
  }
}

/// generated route for
/// [CredentialDetailPage]
class CredentialDetailRoute extends PageRouteInfo<CredentialDetailRouteArgs> {
  CredentialDetailRoute({
    Key? key,
    required Credential credential,
    List<PageRouteInfo>? children,
  }) : super(
          CredentialDetailRoute.name,
          args: CredentialDetailRouteArgs(
            key: key,
            credential: credential,
          ),
          initialChildren: children,
        );

  static const String name = 'CredentialDetailRoute';

  static const PageInfo<CredentialDetailRouteArgs> page =
      PageInfo<CredentialDetailRouteArgs>(name);
}

class CredentialDetailRouteArgs {
  const CredentialDetailRouteArgs({
    this.key,
    required this.credential,
  });

  final Key? key;

  final Credential credential;

  @override
  String toString() {
    return 'CredentialDetailRouteArgs{key: $key, credential: $credential}';
  }
}

/// generated route for
/// [DataAddressesFormPage]
class DataAddressesFormRoute extends PageRouteInfo<DataAddressesFormRouteArgs> {
  DataAddressesFormRoute({
    required void Function() refreshListOnPagePop,
    Address? addressToEdit,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          DataAddressesFormRoute.name,
          args: DataAddressesFormRouteArgs(
            refreshListOnPagePop: refreshListOnPagePop,
            addressToEdit: addressToEdit,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'DataAddressesFormRoute';

  static const PageInfo<DataAddressesFormRouteArgs> page =
      PageInfo<DataAddressesFormRouteArgs>(name);
}

class DataAddressesFormRouteArgs {
  const DataAddressesFormRouteArgs({
    required this.refreshListOnPagePop,
    this.addressToEdit,
    this.key,
  });

  final void Function() refreshListOnPagePop;

  final Address? addressToEdit;

  final Key? key;

  @override
  String toString() {
    return 'DataAddressesFormRouteArgs{refreshListOnPagePop: $refreshListOnPagePop, addressToEdit: $addressToEdit, key: $key}';
  }
}

/// generated route for
/// [DataAddressesPage]
class DataAddressesRoute extends PageRouteInfo<void> {
  const DataAddressesRoute({List<PageRouteInfo>? children})
      : super(
          DataAddressesRoute.name,
          initialChildren: children,
        );

  static const String name = 'DataAddressesRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DataEmailsFormPage]
class DataEmailsFormRoute extends PageRouteInfo<DataEmailsFormRouteArgs> {
  DataEmailsFormRoute({
    required void Function() refreshListOnPagePop,
    Email? email,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          DataEmailsFormRoute.name,
          args: DataEmailsFormRouteArgs(
            refreshListOnPagePop: refreshListOnPagePop,
            email: email,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'DataEmailsFormRoute';

  static const PageInfo<DataEmailsFormRouteArgs> page =
      PageInfo<DataEmailsFormRouteArgs>(name);
}

class DataEmailsFormRouteArgs {
  const DataEmailsFormRouteArgs({
    required this.refreshListOnPagePop,
    this.email,
    this.key,
  });

  final void Function() refreshListOnPagePop;

  final Email? email;

  final Key? key;

  @override
  String toString() {
    return 'DataEmailsFormRouteArgs{refreshListOnPagePop: $refreshListOnPagePop, email: $email, key: $key}';
  }
}

/// generated route for
/// [DataEmailsPage]
class DataEmailsRoute extends PageRouteInfo<void> {
  const DataEmailsRoute({List<PageRouteInfo>? children})
      : super(
          DataEmailsRoute.name,
          initialChildren: children,
        );

  static const String name = 'DataEmailsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DataInvoiceListFormPage]
class DataInvoiceListFormRoute
    extends PageRouteInfo<DataInvoiceListFormRouteArgs> {
  DataInvoiceListFormRoute({
    required void Function() refreshListOnPagePop,
    InvoiceData? invoiceData,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          DataInvoiceListFormRoute.name,
          args: DataInvoiceListFormRouteArgs(
            refreshListOnPagePop: refreshListOnPagePop,
            invoiceData: invoiceData,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'DataInvoiceListFormRoute';

  static const PageInfo<DataInvoiceListFormRouteArgs> page =
      PageInfo<DataInvoiceListFormRouteArgs>(name);
}

class DataInvoiceListFormRouteArgs {
  const DataInvoiceListFormRouteArgs({
    required this.refreshListOnPagePop,
    this.invoiceData,
    this.key,
  });

  final void Function() refreshListOnPagePop;

  final InvoiceData? invoiceData;

  final Key? key;

  @override
  String toString() {
    return 'DataInvoiceListFormRouteArgs{refreshListOnPagePop: $refreshListOnPagePop, invoiceData: $invoiceData, key: $key}';
  }
}

/// generated route for
/// [DataInvoiceListPage]
class DataInvoiceListRoute extends PageRouteInfo<void> {
  const DataInvoiceListRoute({List<PageRouteInfo>? children})
      : super(
          DataInvoiceListRoute.name,
          initialChildren: children,
        );

  static const String name = 'DataInvoiceListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DataPersonalFormPage]
class DataPersonalFormRoute extends PageRouteInfo<DataPersonalFormRouteArgs> {
  DataPersonalFormRoute({
    required void Function() refreshListOnPagePop,
    PersonalData? personalData,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          DataPersonalFormRoute.name,
          args: DataPersonalFormRouteArgs(
            refreshListOnPagePop: refreshListOnPagePop,
            personalData: personalData,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'DataPersonalFormRoute';

  static const PageInfo<DataPersonalFormRouteArgs> page =
      PageInfo<DataPersonalFormRouteArgs>(name);
}

class DataPersonalFormRouteArgs {
  const DataPersonalFormRouteArgs({
    required this.refreshListOnPagePop,
    this.personalData,
    this.key,
  });

  final void Function() refreshListOnPagePop;

  final PersonalData? personalData;

  final Key? key;

  @override
  String toString() {
    return 'DataPersonalFormRouteArgs{refreshListOnPagePop: $refreshListOnPagePop, personalData: $personalData, key: $key}';
  }
}

/// generated route for
/// [DataPersonalPage]
class DataPersonalRoute extends PageRouteInfo<void> {
  const DataPersonalRoute({List<PageRouteInfo>? children})
      : super(
          DataPersonalRoute.name,
          initialChildren: children,
        );

  static const String name = 'DataPersonalRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DataPhoneNumberPage]
class DataPhoneNumberRoute extends PageRouteInfo<void> {
  const DataPhoneNumberRoute({List<PageRouteInfo>? children})
      : super(
          DataPhoneNumberRoute.name,
          initialChildren: children,
        );

  static const String name = 'DataPhoneNumberRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DeviceListPage]
class DeviceListRoute extends PageRouteInfo<void> {
  const DeviceListRoute({List<PageRouteInfo>? children})
      : super(
          DeviceListRoute.name,
          initialChildren: children,
        );

  static const String name = 'DeviceListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [EmailSelectionPage]
class EmailSelectionRoute extends PageRouteInfo<EmailSelectionRouteArgs> {
  EmailSelectionRoute({
    required Service service,
    required dynamic Function(Email) onPagePop,
    Email? email,
    List<PageRouteInfo>? children,
  }) : super(
          EmailSelectionRoute.name,
          args: EmailSelectionRouteArgs(
            service: service,
            onPagePop: onPagePop,
            email: email,
          ),
          initialChildren: children,
        );

  static const String name = 'EmailSelectionRoute';

  static const PageInfo<EmailSelectionRouteArgs> page =
      PageInfo<EmailSelectionRouteArgs>(name);
}

class EmailSelectionRouteArgs {
  const EmailSelectionRouteArgs({
    required this.service,
    required this.onPagePop,
    this.email,
  });

  final Service service;

  final dynamic Function(Email) onPagePop;

  final Email? email;

  @override
  String toString() {
    return 'EmailSelectionRouteArgs{service: $service, onPagePop: $onPagePop, email: $email}';
  }
}

/// generated route for
/// [EntryPage]
class EntryRoute extends PageRouteInfo<void> {
  const EntryRoute({List<PageRouteInfo>? children})
      : super(
          EntryRoute.name,
          initialChildren: children,
        );

  static const String name = 'EntryRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [EventLogPage]
class EventLogRoute extends PageRouteInfo<void> {
  const EventLogRoute({List<PageRouteInfo>? children})
      : super(
          EventLogRoute.name,
          initialChildren: children,
        );

  static const String name = 'EventLogRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [GetSaferPage]
class GetSaferRoute extends PageRouteInfo<void> {
  const GetSaferRoute({List<PageRouteInfo>? children})
      : super(
          GetSaferRoute.name,
          initialChildren: children,
        );

  static const String name = 'GetSaferRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HistoricalSessionListPage]
class HistoricalSessionListRoute
    extends PageRouteInfo<HistoricalSessionListRouteArgs> {
  HistoricalSessionListRoute({
    required Service service,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          HistoricalSessionListRoute.name,
          args: HistoricalSessionListRouteArgs(
            service: service,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'HistoricalSessionListRoute';

  static const PageInfo<HistoricalSessionListRouteArgs> page =
      PageInfo<HistoricalSessionListRouteArgs>(name);
}

class HistoricalSessionListRouteArgs {
  const HistoricalSessionListRouteArgs({
    required this.service,
    this.key,
  });

  final Service service;

  final Key? key;

  @override
  String toString() {
    return 'HistoricalSessionListRouteArgs{service: $service, key: $key}';
  }
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [InvoiceDataSelectionPage]
class InvoiceDataSelectionRoute
    extends PageRouteInfo<InvoiceDataSelectionRouteArgs> {
  InvoiceDataSelectionRoute({
    required Service service,
    required dynamic Function(InvoiceData) onPagePop,
    InvoiceData? invoiceData,
    List<PageRouteInfo>? children,
  }) : super(
          InvoiceDataSelectionRoute.name,
          args: InvoiceDataSelectionRouteArgs(
            service: service,
            onPagePop: onPagePop,
            invoiceData: invoiceData,
          ),
          initialChildren: children,
        );

  static const String name = 'InvoiceDataSelectionRoute';

  static const PageInfo<InvoiceDataSelectionRouteArgs> page =
      PageInfo<InvoiceDataSelectionRouteArgs>(name);
}

class InvoiceDataSelectionRouteArgs {
  const InvoiceDataSelectionRouteArgs({
    required this.service,
    required this.onPagePop,
    this.invoiceData,
  });

  final Service service;

  final dynamic Function(InvoiceData) onPagePop;

  final InvoiceData? invoiceData;

  @override
  String toString() {
    return 'InvoiceDataSelectionRouteArgs{service: $service, onPagePop: $onPagePop, invoiceData: $invoiceData}';
  }
}

/// generated route for
/// [LanguagePage]
class LanguageRoute extends PageRouteInfo<void> {
  const LanguageRoute({List<PageRouteInfo>? children})
      : super(
          LanguageRoute.name,
          initialChildren: children,
        );

  static const String name = 'LanguageRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginResetPage]
class LoginResetRoute extends PageRouteInfo<void> {
  const LoginResetRoute({List<PageRouteInfo>? children})
      : super(
          LoginResetRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginResetRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginSuccessPage]
class LoginSuccessRoute extends PageRouteInfo<void> {
  const LoginSuccessRoute({List<PageRouteInfo>? children})
      : super(
          LoginSuccessRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginSuccessRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MainPage]
class MainRoute extends PageRouteInfo<void> {
  const MainRoute({List<PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NeedHelpPage]
class NeedHelpRoute extends PageRouteInfo<void> {
  const NeedHelpRoute({List<PageRouteInfo>? children})
      : super(
          NeedHelpRoute.name,
          initialChildren: children,
        );

  static const String name = 'NeedHelpRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NewPinPage]
class NewPinRoute extends PageRouteInfo<void> {
  const NewPinRoute({List<PageRouteInfo>? children})
      : super(
          NewPinRoute.name,
          initialChildren: children,
        );

  static const String name = 'NewPinRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [OTPCodePage]
class OTPCodeRoute extends PageRouteInfo<OTPCodeRouteArgs> {
  OTPCodeRoute({
    required String phoneNumber,
    required SignUpVerification verification,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          OTPCodeRoute.name,
          args: OTPCodeRouteArgs(
            phoneNumber: phoneNumber,
            verification: verification,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'OTPCodeRoute';

  static const PageInfo<OTPCodeRouteArgs> page =
      PageInfo<OTPCodeRouteArgs>(name);
}

class OTPCodeRouteArgs {
  const OTPCodeRouteArgs({
    required this.phoneNumber,
    required this.verification,
    this.key,
  });

  final String phoneNumber;

  final SignUpVerification verification;

  final Key? key;

  @override
  String toString() {
    return 'OTPCodeRouteArgs{phoneNumber: $phoneNumber, verification: $verification, key: $key}';
  }
}

/// generated route for
/// [OnboardingPage]
class OnboardingRoute extends PageRouteInfo<OnboardingRouteArgs> {
  OnboardingRoute({
    String? logoutMessage,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          OnboardingRoute.name,
          args: OnboardingRouteArgs(
            logoutMessage: logoutMessage,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'OnboardingRoute';

  static const PageInfo<OnboardingRouteArgs> page =
      PageInfo<OnboardingRouteArgs>(name);
}

class OnboardingRouteArgs {
  const OnboardingRouteArgs({
    this.logoutMessage,
    this.key,
  });

  final String? logoutMessage;

  final Key? key;

  @override
  String toString() {
    return 'OnboardingRouteArgs{logoutMessage: $logoutMessage, key: $key}';
  }
}

/// generated route for
/// [PersonalDataSelectionPage]
class PersonalDataSelectionRoute
    extends PageRouteInfo<PersonalDataSelectionRouteArgs> {
  PersonalDataSelectionRoute({
    required Service service,
    required dynamic Function(PersonalData) onPagePop,
    PersonalData? personalData,
    List<PageRouteInfo>? children,
  }) : super(
          PersonalDataSelectionRoute.name,
          args: PersonalDataSelectionRouteArgs(
            service: service,
            onPagePop: onPagePop,
            personalData: personalData,
          ),
          initialChildren: children,
        );

  static const String name = 'PersonalDataSelectionRoute';

  static const PageInfo<PersonalDataSelectionRouteArgs> page =
      PageInfo<PersonalDataSelectionRouteArgs>(name);
}

class PersonalDataSelectionRouteArgs {
  const PersonalDataSelectionRouteArgs({
    required this.service,
    required this.onPagePop,
    this.personalData,
  });

  final Service service;

  final dynamic Function(PersonalData) onPagePop;

  final PersonalData? personalData;

  @override
  String toString() {
    return 'PersonalDataSelectionRouteArgs{service: $service, onPagePop: $onPagePop, personalData: $personalData}';
  }
}

/// generated route for
/// [PinSuccessPage]
class PinSuccessRoute extends PageRouteInfo<PinSuccessRouteArgs> {
  PinSuccessRoute({
    required PageRouteInfo<dynamic> route,
    required String title,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          PinSuccessRoute.name,
          args: PinSuccessRouteArgs(
            route: route,
            title: title,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'PinSuccessRoute';

  static const PageInfo<PinSuccessRouteArgs> page =
      PageInfo<PinSuccessRouteArgs>(name);
}

class PinSuccessRouteArgs {
  const PinSuccessRouteArgs({
    required this.route,
    required this.title,
    this.key,
  });

  final PageRouteInfo<dynamic> route;

  final String title;

  final Key? key;

  @override
  String toString() {
    return 'PinSuccessRouteArgs{route: $route, title: $title, key: $key}';
  }
}

/// generated route for
/// [ProofPresentationPage]
class ProofPresentationRoute extends PageRouteInfo<ProofPresentationRouteArgs> {
  ProofPresentationRoute({
    Key? key,
    required Credential credential,
    Map<String, dynamic>? proofData,
    List<PageRouteInfo>? children,
  }) : super(
          ProofPresentationRoute.name,
          args: ProofPresentationRouteArgs(
            key: key,
            credential: credential,
            proofData: proofData,
          ),
          initialChildren: children,
        );

  static const String name = 'ProofPresentationRoute';

  static const PageInfo<ProofPresentationRouteArgs> page =
      PageInfo<ProofPresentationRouteArgs>(name);
}

class ProofPresentationRouteArgs {
  const ProofPresentationRouteArgs({
    this.key,
    required this.credential,
    this.proofData,
  });

  final Key? key;

  final Credential credential;

  final Map<String, dynamic>? proofData;

  @override
  String toString() {
    return 'ProofPresentationRouteArgs{key: $key, credential: $credential, proofData: $proofData}';
  }
}

/// generated route for
/// [QrScanPage]
class QrScanRoute extends PageRouteInfo<void> {
  const QrScanRoute({List<PageRouteInfo>? children})
      : super(
          QrScanRoute.name,
          initialChildren: children,
        );

  static const String name = 'QrScanRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [QuestionPage]
class QuestionRoute extends PageRouteInfo<QuestionRouteArgs> {
  QuestionRoute({
    required Question question,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          QuestionRoute.name,
          args: QuestionRouteArgs(
            question: question,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'QuestionRoute';

  static const PageInfo<QuestionRouteArgs> page =
      PageInfo<QuestionRouteArgs>(name);
}

class QuestionRouteArgs {
  const QuestionRouteArgs({
    required this.question,
    this.key,
  });

  final Question question;

  final Key? key;

  @override
  String toString() {
    return 'QuestionRouteArgs{question: $question, key: $key}';
  }
}

/// generated route for
/// [ResetAccountPage]
class ResetAccountRoute extends PageRouteInfo<void> {
  const ResetAccountRoute({List<PageRouteInfo>? children})
      : super(
          ResetAccountRoute.name,
          initialChildren: children,
        );

  static const String name = 'ResetAccountRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SecuredLoginPage]
class SecuredLoginRoute extends PageRouteInfo<void> {
  const SecuredLoginRoute({List<PageRouteInfo>? children})
      : super(
          SecuredLoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'SecuredLoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SecuritySettingsPage]
class SecuritySettingsRoute extends PageRouteInfo<void> {
  const SecuritySettingsRoute({List<PageRouteInfo>? children})
      : super(
          SecuritySettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SecuritySettingsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ServiceDetailsPage]
class ServiceDetailsRoute extends PageRouteInfo<ServiceDetailsRouteArgs> {
  ServiceDetailsRoute({
    required Service service,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ServiceDetailsRoute.name,
          args: ServiceDetailsRouteArgs(
            service: service,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ServiceDetailsRoute';

  static const PageInfo<ServiceDetailsRouteArgs> page =
      PageInfo<ServiceDetailsRouteArgs>(name);
}

class ServiceDetailsRouteArgs {
  const ServiceDetailsRouteArgs({
    required this.service,
    this.key,
  });

  final Service service;

  final Key? key;

  @override
  String toString() {
    return 'ServiceDetailsRouteArgs{service: $service, key: $key}';
  }
}

/// generated route for
/// [ServiceListPage]
class ServiceListRoute extends PageRouteInfo<void> {
  const ServiceListRoute({List<PageRouteInfo>? children})
      : super(
          ServiceListRoute.name,
          initialChildren: children,
        );

  static const String name = 'ServiceListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ServiceRulesPage]
class ServiceRulesRoute extends PageRouteInfo<ServiceRulesRouteArgs> {
  ServiceRulesRoute({
    required List<ServiceAgreement> agreements,
    required Service service,
    required dynamic Function(List<ServiceAgreement>) onPagePop,
    List<PageRouteInfo>? children,
  }) : super(
          ServiceRulesRoute.name,
          args: ServiceRulesRouteArgs(
            agreements: agreements,
            service: service,
            onPagePop: onPagePop,
          ),
          initialChildren: children,
        );

  static const String name = 'ServiceRulesRoute';

  static const PageInfo<ServiceRulesRouteArgs> page =
      PageInfo<ServiceRulesRouteArgs>(name);
}

class ServiceRulesRouteArgs {
  const ServiceRulesRouteArgs({
    required this.agreements,
    required this.service,
    required this.onPagePop,
  });

  final List<ServiceAgreement> agreements;

  final Service service;

  final dynamic Function(List<ServiceAgreement>) onPagePop;

  @override
  String toString() {
    return 'ServiceRulesRouteArgs{agreements: $agreements, service: $service, onPagePop: $onPagePop}';
  }
}

/// generated route for
/// [SettingsPage]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [StartPage]
class StartRoute extends PageRouteInfo<void> {
  const StartRoute({List<PageRouteInfo>? children})
      : super(
          StartRoute.name,
          initialChildren: children,
        );

  static const String name = 'StartRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TermsAndConditionsPage]
class TermsAndConditionsRoute extends PageRouteInfo<void> {
  const TermsAndConditionsRoute({List<PageRouteInfo>? children})
      : super(
          TermsAndConditionsRoute.name,
          initialChildren: children,
        );

  static const String name = 'TermsAndConditionsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TrustLevelConfirmationPage]
class TrustLevelConfirmationRoute
    extends PageRouteInfo<TrustLevelConfirmationRouteArgs> {
  TrustLevelConfirmationRoute({
    required Service service,
    required int initialTrustLevel,
    required int requiredTrustLevel,
    required dynamic Function(int) onPagePop,
    List<PageRouteInfo>? children,
  }) : super(
          TrustLevelConfirmationRoute.name,
          args: TrustLevelConfirmationRouteArgs(
            service: service,
            initialTrustLevel: initialTrustLevel,
            requiredTrustLevel: requiredTrustLevel,
            onPagePop: onPagePop,
          ),
          initialChildren: children,
        );

  static const String name = 'TrustLevelConfirmationRoute';

  static const PageInfo<TrustLevelConfirmationRouteArgs> page =
      PageInfo<TrustLevelConfirmationRouteArgs>(name);
}

class TrustLevelConfirmationRouteArgs {
  const TrustLevelConfirmationRouteArgs({
    required this.service,
    required this.initialTrustLevel,
    required this.requiredTrustLevel,
    required this.onPagePop,
  });

  final Service service;

  final int initialTrustLevel;

  final int requiredTrustLevel;

  final dynamic Function(int) onPagePop;

  @override
  String toString() {
    return 'TrustLevelConfirmationRouteArgs{service: $service, initialTrustLevel: $initialTrustLevel, requiredTrustLevel: $requiredTrustLevel, onPagePop: $onPagePop}';
  }
}

/// generated route for
/// [TrustLevelPage]
class TrustLevelRoute extends PageRouteInfo<void> {
  const TrustLevelRoute({List<PageRouteInfo>? children})
      : super(
          TrustLevelRoute.name,
          initialChildren: children,
        );

  static const String name = 'TrustLevelRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [VerificationRequestPage]
class VerificationRequestRoute
    extends PageRouteInfo<VerificationRequestRouteArgs> {
  VerificationRequestRoute({
    Key? key,
    String? requestId,
    String? verifierName,
    String? requestType,
    int? minAge,
    bool allowGuardian = false,
    List<PageRouteInfo>? children,
  }) : super(
          VerificationRequestRoute.name,
          args: VerificationRequestRouteArgs(
            key: key,
            requestId: requestId,
            verifierName: verifierName,
            requestType: requestType,
            minAge: minAge,
            allowGuardian: allowGuardian,
          ),
          initialChildren: children,
        );

  static const String name = 'VerificationRequestRoute';

  static const PageInfo<VerificationRequestRouteArgs> page =
      PageInfo<VerificationRequestRouteArgs>(name);
}

class VerificationRequestRouteArgs {
  const VerificationRequestRouteArgs({
    this.key,
    this.requestId,
    this.verifierName,
    this.requestType,
    this.minAge,
    this.allowGuardian = false,
  });

  final Key? key;

  final String? requestId;

  final String? verifierName;

  final String? requestType;

  final int? minAge;

  final bool allowGuardian;

  @override
  String toString() {
    return 'VerificationRequestRouteArgs{key: $key, requestId: $requestId, verifierName: $verifierName, requestType: $requestType, minAge: $minAge, allowGuardian: $allowGuardian}';
  }
}

/// generated route for
/// [WalletHomePage]
class WalletHomeRoute extends PageRouteInfo<void> {
  const WalletHomeRoute({List<PageRouteInfo>? children})
      : super(
          WalletHomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'WalletHomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [YourDataPage]
class YourDataRoute extends PageRouteInfo<void> {
  const YourDataRoute({List<PageRouteInfo>? children})
      : super(
          YourDataRoute.name,
          initialChildren: children,
        );

  static const String name = 'YourDataRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [IdentityPage]
class IdentityRoute extends PageRouteInfo<void> {
  const IdentityRoute({List<PageRouteInfo>? children})
      : super(
          IdentityRoute.name,
          initialChildren: children,
        );

  static const String name = 'IdentityRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [GuardianPage]
class GuardianRoute extends PageRouteInfo<void> {
  const GuardianRoute({List<PageRouteInfo>? children})
      : super(
          GuardianRoute.name,
          initialChildren: children,
        );

  static const String name = 'GuardianRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [GuardianApprovalPage]
class GuardianApprovalRoute
    extends PageRouteInfo<GuardianApprovalRouteArgs> {
  GuardianApprovalRoute({
    Key? key,
    required String requestId,
    required GuardianApprovalType approvalType,
    String guardianName = '',
    String? guardianPhone,
    String? minorName,
    String? minorPhone,
    String? serviceName,
    String? action,
    int expiresInSeconds = 300,
    List<PageRouteInfo>? children,
  }) : super(
          GuardianApprovalRoute.name,
          args: GuardianApprovalRouteArgs(
            key: key,
            requestId: requestId,
            approvalType: approvalType,
            guardianName: guardianName,
            guardianPhone: guardianPhone,
            minorName: minorName,
            minorPhone: minorPhone,
            serviceName: serviceName,
            action: action,
            expiresInSeconds: expiresInSeconds,
          ),
          initialChildren: children,
        );

  static const String name = 'GuardianApprovalRoute';

  static const PageInfo<GuardianApprovalRouteArgs> page =
      PageInfo<GuardianApprovalRouteArgs>(name);
}

class GuardianApprovalRouteArgs {
  const GuardianApprovalRouteArgs({
    this.key,
    required this.requestId,
    required this.approvalType,
    this.guardianName = '',
    this.guardianPhone,
    this.minorName,
    this.minorPhone,
    this.serviceName,
    this.action,
    this.expiresInSeconds = 300,
  });

  final Key? key;
  final String requestId;
  final GuardianApprovalType approvalType;
  final String guardianName;
  final String? guardianPhone;
  final String? minorName;
  final String? minorPhone;
  final String? serviceName;
  final String? action;
  final int expiresInSeconds;

  @override
  String toString() {
    return 'GuardianApprovalRouteArgs{requestId: $requestId, approvalType: $approvalType, guardianName: $guardianName}';
  }
}
