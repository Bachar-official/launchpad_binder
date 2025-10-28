class ConditionException implements Exception {
  final String message;
  const ConditionException(this.message);

  @override
  String toString() => message;
}