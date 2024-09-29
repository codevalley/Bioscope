import 'package:flutter/foundation.dart';

class Logger {
  static bool _loggingEnabled = true;

  static void enable() {
    _loggingEnabled = true;
  }

  static void disable() {
    _loggingEnabled = false;
  }

  static void log(String message) {
    if (_loggingEnabled) {
      debugPrint(message);
    }
  }
}
