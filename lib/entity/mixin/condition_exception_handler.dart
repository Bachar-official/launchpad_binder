import 'package:launchpad_binder/entity/condition.dart';
import 'package:launchpad_binder/exception/condition_exception.dart';

mixin CEHandler {
  void checkCondition(bool condition, String message) {
    if (condition) {
      throw ConditionException(message);
    }
  }

  void checkConditions(List<Condition> conditions) {
    for (var c in conditions) {
      if (c.throwIf) {
        throw ConditionException(c.message);
      }
    }
  }
}