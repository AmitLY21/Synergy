import 'dart:async';

import 'package:logger/logger.dart';

class LoggerUtil {
  static bool enableLogging = true;

  static Logger log() {
    if (enableLogging) {
      return Logger(
        printer: PrettyPrinter(
          methodCount: 2, // number of method calls to be displayed
          errorMethodCount: 8, // number of method calls if stacktrace is provided
          lineLength: 120, // width of the output
          colors: true, // Colorful log messages
          printEmojis: true, // Print an emoji for each log message
          printTime: true, // Should each log print contain a timestamp
        ),
        filter: MyFilter(),

      );
    } else {
      return NoopLogger();
    }
  }
}

class MyFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}

class NoopLogger extends Logger {
  @override
  void log(Level level, message, [error, StackTrace? stackTrace, Zone? zone]) {}
}
