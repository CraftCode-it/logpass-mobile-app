class DeniedConfirmation {
  final String error;
  final String errorDescription;
  final String? state;
  final String redirectUri;

  DeniedConfirmation({
    required this.error,
    required this.errorDescription,
    required this.state,
    required this.redirectUri,
  });
}
