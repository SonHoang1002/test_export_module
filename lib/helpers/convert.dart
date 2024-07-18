import 'package:flutter/material.dart';

String convertColorToHexString(Color color) {
  final newHexString = color.value.toRadixString(16).toUpperCase();
  String result;
  if (newHexString.length > 2) {
    result = newHexString.substring(2, newHexString.length);
  } else {
    throw Exception("convertColorToHexString error: newHexString length invalid !!");
  }

  return '#$result';
}

/// String [value] is format: #7A32BC || 7A32BC
Color convertHexStringToColor(String value) {
  String newValue = value;
  if (value.contains("#")) {
    newValue = value.substring(1, value.length);
  }
  return Color(int.parse("0xFF$newValue"));
}
