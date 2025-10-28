import 'package:logger/logger.dart';

import 'package:launchpad_binder/entity/interface/has_deps.dart';

mixin LoggerMixin on HasDeps {
  Logger get logger => deps.logger;

  void debug(String message) => logger.d(message);
  void warning(String message) => logger.w(message);
  void error({required String message, required Object exception, StackTrace? stacktrace}) => logger.e(message, error: exception, stackTrace: stacktrace);
  void success(String message) => logger.i(message);
}