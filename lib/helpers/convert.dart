import 'package:color_picker_android/commons/colors.dart';
import 'package:flutter/material.dart';

String convertColorToHexString(Color color) {
  final newHexString = color.value.toRadixString(16).toUpperCase();
  final result = newHexString.substring(2, newHexString.length);
  return '#$result';
}

/// String [value] is format: #7A32BC || 7A32BC
Color convertHexStringToColor(String value) {
  String newValue = value;
  if (value.contains("#")) {
    // delete "#"
    newValue = value.substring(1, value.length);
  }
  return Color(int.parse("0xFF$newValue"));
}
