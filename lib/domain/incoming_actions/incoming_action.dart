class IncomingAction {
  final String link;

  IncomingAction(this.link);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is IncomingAction && runtimeType == other.runtimeType && link == other.link;

  @override
  int get hashCode => link.hashCode;
}
