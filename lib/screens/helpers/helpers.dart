import 'dart:ui';

import 'package:color_picker_android/commons/colors.dart';

class ColorPickerHelpers {
  static Color getColorSegment(bool isLightMode, int indexSegment, int checkValue) {
    if (isLightMode) {
      if (indexSegment == checkValue) {
        return colorBlack;
      } else {
        return black05;
      }
    } else {
      if (indexSegment == checkValue) {
        return colorBlack;
      } else {
        return white05;
      }
    }
  }
}
