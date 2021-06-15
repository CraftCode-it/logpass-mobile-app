class ApproveAttemptArgs {
  final String email;
  final bool emailVerified;
  final String name;

  ApproveAttemptArgs({
    required this.email,
    required this.emailVerified,
    required this.name,
  });

  // TODO: extend model with objects:
  // Address address
  // Invoice invoice
  // List<Scope> extraScoped
}
