import 'package:flutter/material.dart';

const int MAX_LENGTH_INPUT_1 = 7;
const int MAX_LENGTH_INPUT_2 = 9;

const Duration DURATION_ANIMATED = Duration(milliseconds: 300);
// ignore: non_constant_identifier_names
final List<Color> COLOR_SLIDERS = [
  const HSVColor.fromAHSV(1.0, 0.0, 1.0, 1.0).toColor(),
  const HSVColor.fromAHSV(1.0, 30.0, 1.0, 1.0).toColor(),
  const HSVColor.fromAHSV(1.0, 60.0, 1.0, 1.0).toColor(),
  const HSVColor.fromAHSV(1.0, 90.0, 1.0, 1.0).toColor(),
  const HSVColor.fromAHSV(1.0, 120.0, 1.0, 1.0).toColor(),
  const HSVColor.fromAHSV(1.0, 150.0, 1.0, 1.0).toColor(),
  const HSVColor.fromAHSV(1.0, 180.0, 1.0, 1.0).toColor(),
  const HSVColor.fromAHSV(1.0, 210.0, 1.0, 1.0).toColor(),
  const HSVColor.fromAHSV(1.0, 240.0, 1.0, 1.0).toColor(),
  const HSVColor.fromAHSV(1.0, 270.0, 1.0, 1.0).toColor(),
  const HSVColor.fromAHSV(1.0, 300.0, 1.0, 1.0).toColor(),
  const HSVColor.fromAHSV(1.0, 330.0, 1.0, 1.0).toColor(),
  const HSVColor.fromAHSV(1.0, 360.0, 1.0, 1.0).toColor(),
];
const HSVColor HSVCOLOR_TRANPARENT =   HSVColor.fromAHSV(0, 0, 0, 0);
// ignore: constant_identifier_names
const List<Color> ALL_COLORS = [
  Colors.amber,
  Colors.amberAccent,
  Colors.black,
  Colors.blue,
  Colors.blueAccent,
  Colors.blueGrey,
  Colors.brown,
  Colors.cyan,
  Colors.cyanAccent,
  Colors.deepOrange,
  Colors.deepOrangeAccent,
  Colors.deepPurple,
  Colors.deepPurpleAccent,
  Colors.green,
  Colors.greenAccent,
  Colors.grey,
  Colors.indigo,
  Colors.indigoAccent,
  Colors.lightBlue,
  Colors.lightBlueAccent,
  Colors.lightGreen,
  Colors.lightGreenAccent,
  Colors.lime,
  Colors.limeAccent,
  Colors.orange,
  Colors.orangeAccent,
  Colors.pink,
  Colors.pinkAccent,
  Colors.purple,
  Colors.purpleAccent,
  Colors.red,
  Colors.redAccent,
  Colors.teal,
  Colors.tealAccent,
  Colors.yellow,
  Colors.yellowAccent,
  Colors.white,
];

// ignore: constant_identifier_names
const List<Color> COLORS_PALETTE = [
  Color(0xFFFFFFFF),
  Color(0xFFEBEBEB),
  Color(0xFFD6D6D6),
  Color(0xFFC2C2C2),
  Color(0xFFADADAD),
  Color(0xFF999999),
  Color(0xFF858585),
  Color(0xFF707070),
  Color(0xFF5C5C5C),
  Color(0xFF474747),
  Color(0xFF333333),
  Color(0xFF000000),
  Color(0xFF03374B),
  Color(0xFF021C56),
  Color(0xFF11053C),
  Color(0xFF2E053C),
  Color(0xFF3B081A),
  Color(0xFF5C0702),
  Color(0xFF5A1D00),
  Color(0xFF573300),
  Color(0xFF573D00),
  Color(0xFF666100),
  Color(0xFF4F5604),
  Color(0xFF263E10),
  Color(0xFF004D65),
  Color(0xFF012F7B),
  Color(0xFF1A0B51),
  Color(0xFF450E58),
  Color(0xFF541029),
  Color(0xFF821101),
  Color(0xFF7A2A00),
  Color(0xFF7B4B00),
  Color(0xFF785900),
  Color(0xFF8C8605),
  Color(0xFF70760C),
  Color(0xFF385718),
  Color(0xFF006E8E),
  Color(0xFF0042A7),
  Color(0xFF2B0977),
  Color(0xFF61187C),
  Color(0xFF781A3E),
  Color(0xFFB51A00),
  Color(0xFFAD3D00),
  Color(0xFFA96900),
  Color(0xFFA67A02),
  Color(0xFFC2BC00),
  Color(0xFF9AA40B),
  Color(0xFF4E7A28),
  Color(0xFF008CB4),
  Color(0xFF0255D5),
  Color(0xFF371A93),
  Color(0xFF7A219E),
  Color(0xFF982450),
  Color(0xFFE22403),
  Color(0xFFD95100),
  Color(0xFFD28101),
  Color(0xFFD19C02),
  Color(0xFFF3EC01),
  Color(0xFFC2D013),
  Color(0xFF679C32),
  Color(0xFF01A0D8),
  Color(0xFF0062FE),
  Color(0xFF4E22B3),
  Color(0xFF982ABB),
  Color(0xFFBA2C5D),
  Color(0xFFFF4017),
  Color(0xFFFF6A03),
  Color(0xFFFDAA02),
  Color(0xFFFCC800),
  Color(0xFFFDFB43),
  Color(0xFFD8EC37),
  Color(0xFF75BC3F),
  Color(0xFF03C7FB),
  Color(0xFF3C87FD),
  Color(0xFF5E2FEB),
  Color(0xFFBE37F3),
  Color(0xFFE63B7B),
  Color(0xFFFF614E),
  Color(0xFFFF8647),
  Color(0xFFFEB43F),
  Color(0xFFFDCB3F),
  Color(0xFFFEF769),
  Color(0xFFE3EE64),
  Color(0xFF96D35F),
  Color(0xFF54D6FA),
  Color(0xFF74A6FF),
  Color(0xFF864EFD),
  Color(0xFFD257FD),
  Color(0xFFEE719E),
  Color(0xFFFD8C81),
  Color(0xFFFFA57D),
  Color(0xFFFEC776),
  Color(0xFFFED976),
  Color(0xFFFFF893),
  Color(0xFFEAF18F),
  Color(0xFFB1DC8B),
  Color(0xFF92E2FB),
  Color(0xFFA8C6FF),
  Color(0xFFB08DFC),
  Color(0xFFE391FD),
  Color(0xFFF4A4C0),
  Color(0xFFFFB5AE),
  Color(0xFFFEC5AB),
  Color(0xFFFFD9A8),
  Color(0xFFFDE3A8),
  Color(0xFFFDFBB9),
  Color(0xFFF1F5B5),
  Color(0xFFCCE8B4),
  Color(0xFFCBEFFE),
  Color(0xFFD3E1FF),
  Color(0xFFD9C7FD),
  Color(0xFFEECAFF),
  Color(0xFFF8D3DE),
  Color(0xFFFFDAD8),
  Color(0xFFFFE3D5),
  Color(0xFFFEEBD2),
  Color(0xFFFEF2D4),
  Color(0xFFFDFCDB),
  Color(0xFFF5F9DB),
  Color(0xFFDEEDD5),
];

// ignore: constant_identifier_names
const String PATH_PREFFIX_ICON = 'lib/assets/icons/';
// ignore: constant_identifier_names
const List<String> KEYBOARD_ROW_1 = ["7", "8", "9", "A", "B", "C"];
// ignore: constant_identifier_names
const List<String> KEYBOARD_ROW_2 = ["4", "5", "6", "D", "E", "F"];
// ignore: constant_identifier_names
const List<String> KEYBOARD_ROW_31 = ["1", "2", "3"];
// ignore: constant_identifier_names
const double HEIGHT_OF_KEYBOARD = 300;

// ignore: constant_identifier_names
const String PREFERENCE_SAVED_COLOR_KEY = "saved_color";
// ignore: constant_identifier_names
const Curve CUBIC_CURVE = Cubic(0.25, 0, 0, 1);
