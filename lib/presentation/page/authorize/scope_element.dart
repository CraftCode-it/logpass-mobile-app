import 'package:logpass_me/domain/model/scope.dart';

class ScopeElement {
  final Scope scope;
  final String name;
  final String hint;
  final String imagePath;
  final bool isRequired;
  final Object? scopeObject;

  bool get isEligible => !isRequired || isRequired && scopeObject != null;
  String get requiredHint => '*$hint';

  ScopeElement({
    required this.scope,
    required this.name,
    required this.isRequired,
    required this.imagePath,
    required this.hint,
    this.scopeObject,
  });

  ScopeElement copyWith({
    Scope? scope,
    String? name,
    String? hint,
    String? imagePath,
    bool? isRequired,
    Object? scopeObject,
  }) {
    return ScopeElement(
      scope: scope ?? this.scope,
      name: name ?? this.name,
      hint: hint ?? this.hint,
      imagePath: imagePath ?? this.imagePath,
      isRequired: isRequired ?? this.isRequired,
      scopeObject: scopeObject ?? this.scopeObject,
    );
  }
}
