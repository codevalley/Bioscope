import 'package:flutter/foundation.dart';

/// Provides logging functionality for the application.
///
/// This utility class offers methods to control and perform logging
/// operations. It allows enabling or disabling logging globally and
/// provides a method to log messages when logging is enabled.
class Logger {
  /// Indicates whether logging is currently enabled.
  static bool _loggingEnabled = true;

  /// Enables logging.
  ///
  /// After calling this method, subsequent calls to [log] will output messages.
  static void enable() {
    _loggingEnabled = true;
  }

  /// Disables logging.
  ///
  /// After calling this method, subsequent calls to [log] will not output any messages.
  static void disable() {
    _loggingEnabled = false;
  }

  /// Logs a message if logging is enabled.
  ///
  /// This method checks if logging is enabled and, if so, prints the given [message]
  /// using Flutter's [debugPrint] function. This ensures that logs are only displayed
  /// in debug mode and not in release builds.
  ///
  /// [message] The message to be logged.
  static void log(String message) {
    if (_loggingEnabled) {
      debugPrint(message);
    }
  }
}
