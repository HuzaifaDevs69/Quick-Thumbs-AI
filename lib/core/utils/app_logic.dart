import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;

class dPrint {
  // Toggle debugging globally
  static const bool _isDebugMode = kDebugMode;

  // Styled debug print method
  static void log(String message, {String? tag, String? color}) {
    if (_isDebugMode) {
      final formattedTag = tag != null ? '[ $tag ] ' : '';
      final styledMessage =
          _applyColor('$formattedTag$message', color ?? 'yellow');
      developer.log(styledMessage);
    }
  }

  // Apply terminal color codes
  static String _applyColor(String text, String color) {
    final colors = {
      'reset': '\x1B[0m',
      'red': '\x1B[31m',
      'green': '\x1B[32m',
      'yellow': '\x1B[33m',
      'blue': '\x1B[34m',
      'magenta': '\x1B[35m',
      'cyan': '\x1B[36m',
      'white': '\x1B[37m',
    };
    return '${colors[color] ?? colors['reset']}$text${colors['reset']}';
  }
}

Color generateRandomColor() {
  final random = Random();
  return Color.fromARGB(
    255,
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
  );
}
