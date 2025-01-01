import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class DLogger {
  static void log(dynamic message) {
    DebugLogger().log(message, "");
  }

  static void logWarning(dynamic message) {
    DebugLogger().warn(message, "");
  }

  static void logOk(dynamic message) {
    DebugLogger().ok(message, "");
  }

  static void logError(dynamic message, dynamic stack) {
    DebugLogger().error(message, "", stack);
  }

  static void logInfo(dynamic message) {
    DebugLogger().info(message, "");
  }

  static void logFatal(dynamic message, Error e, StackTrace s) {
    DebugLogger().fatal(message, "", e, s);
  }
}

class BaseHelper {
  void log(dynamic message) {
    DebugLogger().log(message, runtimeType.toString());
  }

  void logWarning(dynamic message) {
    DebugLogger().warn(message, runtimeType.toString());
  }

  void logOk(dynamic message) {
    DebugLogger().ok(message, runtimeType.toString());
  }

  void logError(dynamic message, dynamic stack) {
    DebugLogger().error(message, runtimeType.toString(), stack);
  }

  void logInfo(dynamic message) {
    DebugLogger().info(message, runtimeType.toString());
  }

  void logFatal(dynamic message, Error e, StackTrace s) {
    DebugLogger().fatal(message, runtimeType.toString(), e, s);
  }

  static String hiveKey(String type, int id, [int? season, int? episode]) {
    return type == 'movie'
        ? 'movie-$id'
        : episode != null
            ? 'show-${id}s${season}e$episode'
            : 'show-${id}s$season';
  }

  String filesize(dynamic size, [int round = 2]) {
    /** 
   * [size] can be passed as number or as string
   *
   * the optional parameter [round] specifies the number 
   * of digits after comma/point (default is 2)
   */
    var divider = 1024;
    int size0;
    try {
      size0 = int.parse(size.toString());
    } catch (e) {
      throw ArgumentError('Can not parse the size parameter: $e');
    }

    if (size0 < divider) {
      return '$size0 B';
    }

    if (size0 < divider * divider && size0 % divider == 0) {
      return '${(size0 / divider).toStringAsFixed(0)} KB';
    }

    if (size0 < divider * divider) {
      return '${(size0 / divider).toStringAsFixed(round)} KB';
    }

    if (size0 < divider * divider * divider && size0 % divider == 0) {
      return '${(size0 / (divider * divider)).toStringAsFixed(0)} MB';
    }

    if (size0 < divider * divider * divider) {
      return '${(size0 / divider / divider).toStringAsFixed(round)} MB';
    }

    if (size0 < divider * divider * divider * divider && size0 % divider == 0) {
      return '${(size0 / (divider * divider * divider)).toStringAsFixed(0)} GB';
    }

    if (size0 < divider * divider * divider * divider) {
      return '${(size0 / divider / divider / divider).toStringAsFixed(round)} GB';
    }

    if (size0 < divider * divider * divider * divider * divider &&
        size0 % divider == 0) {
      num r = size0 / divider / divider / divider / divider;
      return '${r.toStringAsFixed(0)} TB';
    }

    if (size0 < divider * divider * divider * divider * divider) {
      num r = size0 / divider / divider / divider / divider;
      return '${r.toStringAsFixed(round)} TB';
    }

    if (size0 < divider * divider * divider * divider * divider * divider &&
        size0 % divider == 0) {
      num r = size0 / divider / divider / divider / divider / divider;
      return '${r.toStringAsFixed(0)} PB';
    } else {
      num r = size0 / divider / divider / divider / divider / divider;
      return '${r.toStringAsFixed(round)} PB';
    }
  }
}

class DebugLogger {
  static DebugLogger? _instance;
  static Logger? _logger;
  factory DebugLogger() => _instance ?? DebugLogger._internal();
  String _name = '';

  DebugLogger._internal() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen(_recordHandler);

    _logger = Logger('Blitzcoin ');

    _instance = this;
  }

  void _recordHandler(LogRecord record) {
    if (!kDebugMode) {
      return;
    }
    hierarchicalLoggingEnabled = true;

    var start = '\x1b[90m';
    const end = '\x1b[0m';
    const prefix = '\x1b[38;5;240m';

    var emoji = '';

    switch (record.level.name) {
      case 'FINE':
        start = '\x1b[38;5;2m';
        emoji = '✓ OK';
        break;
      case 'FINEST':
        emoji = '●';
        start = '\x1b[38;5;7m';
        break;
      case 'INFO':
        emoji = '★ INFO';
        start = '\x1b[38;5;6m';
        break;
      case 'WARNING':
        emoji = 'ϟ WARN';
        start = '\x1b[38;5;222m';
        break;
      case 'SEVERE':
        emoji = '✖ SEVERE';
        start = '\x1b[38;5;1m';
        break;
      case 'SHOUT':
        emoji = '❕SHOUT';
        start = '\x1b[48;5;1m\x1b[37m';
        break;
    }

    final message =
        '$prefix${_name.padRight(20)} $end$start ${record.message}$end';
    developer.log(message,
        name: '$start$emoji$end$prefix',
        level: record.level.value,
        time: record.time,
        stackTrace: record.stackTrace);
  }

  void log(dynamic message, String name) {
    _name = name;
    _logger?.finest(message);
  }

  void info(dynamic message, String name) {
    _name = name;
    _logger?.info(message);
  }

  void warn(dynamic message, String name) {
    _name = name;
    _logger?.warning(message);
  }

  void ok(dynamic message, String name) {
    _name = name;
    _logger?.fine(message);
  }

  void error(dynamic message, String name, dynamic stack) {
    _name = name;
    _logger?.severe(message);
    if (stack != null) {
      if (kDebugMode) {
        print(stack);
      }
    }
  }

  void fatal(dynamic message, String name, Error e, StackTrace s) {
    _name = name;
    _logger?.shout(message, e, s);
  }
}
