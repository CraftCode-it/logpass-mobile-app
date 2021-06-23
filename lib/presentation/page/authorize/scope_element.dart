import 'package:logpass_me/domain/model/scope.dart';

class ScopeElement {
  final Scope scope;
  final String name;
  final String hint;
  final String imagePath;
  final bool isRequired;
  final String? filledDescription;

  bool get isEligible => !isRequired || isRequired && filledDescription != null;
  String get requiredHint => '*$hint';

  ScopeElement({
    required this.scope,
    required this.name,
    required this.isRequired,
    required this.imagePath,
    required this.hint,
    this.filledDescription,
  });
}
