import 'package:flutter/material.dart';

extension HexColor on String {
  Color toColor() {
    final hex = replaceAll("#", "");
    final fullHex = hex.length == 6 ? "FF$hex" : hex; // Add full opacity if missing
    return Color(int.parse(fullHex, radix: 16));
  }
}
