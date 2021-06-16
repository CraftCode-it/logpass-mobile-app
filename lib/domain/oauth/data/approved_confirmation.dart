class ApprovedConfirmation {
  final String code;
  final String? state;
  final String redirectUri;

  ApprovedConfirmation({
    required this.code,
    required this.state,
    required this.redirectUri,
  });
}
