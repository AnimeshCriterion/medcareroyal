

import 'dart:ui';

Color hexToColor(String code) {
  if (code.length != 7 || !code.startsWith('#')) {
    throw ArgumentError("Invalid hex color code. It should be in the format #RRGGBB");
  }
  return Color(int.parse(code.substring(1), radix: 16) + 0xFF000000);
}