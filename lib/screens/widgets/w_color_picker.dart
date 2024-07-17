import 'package:color_picker_android/commons/colors.dart';
import 'package:color_picker_android/commons/constants.dart';
import 'package:color_picker_android/helpers/navigator_route.dart';
import 'package:color_picker_android/screens/helpers/helpers.dart';
import 'package:color_picker_android/widgets/w_text_content.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WColorPicker {
  static Widget buildSegmentedControl({
    required double width,
    required bool isLightMode,
    required int indexSegment,
    required Color bgColor,
    required void Function(int) onValueChanged,
  }) {
    return SizedBox(
      width: width,
      height: 36,
      child: CustomSlidingSegmentedControl<int>(
        isStretch: true,
        innerPadding: const EdgeInsets.all(2),
        children: {
          0: Text(
            "Palette",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorPickerHelpers.getColorSegment(
                isLightMode,
                indexSegment,
                0,
              ),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          1: Text(
            "HSB",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorPickerHelpers.getColorSegment(
                isLightMode,
                indexSegment,
                1,
              ),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          2: Text(
            "Picker",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorPickerHelpers.getColorSegment(
                isLightMode,
                indexSegment,
                2,
              ),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          3: Text(
            "Saved",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorPickerHelpers.getColorSegment(
                isLightMode,
                indexSegment,
                3,
              ),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          )
        },
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(11),
        ),
        padding: 10,
        thumbDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          color: colorWhite,
        ),
        onValueChanged: onValueChanged,
      ),
    );
  }

  static Widget buildBackground(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {
          popNavigator(context);
        },
      ),
    );
  }

  static Widget buildTitle(bool isLightMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SizedBox(
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(),
            WTextContent(
              value: "COLORS",
              textColor: isLightMode ? null : white07,
            ),
            const SizedBox()
          ],
        ),
      ),
    );
  }

  static Widget buildTextField({
    required Key key,
    required TextEditingController controller,
    required bool isLightMode,
    required bool isValid,
    void Function()? onTapInput,
    void Function(String)? onChanged,
  }) {
    return Container(
      key: key, //_keyTextField,
      height: 30,
      width: 80,
      decoration: BoxDecoration(
        color: isLightMode ? black005 : white01,
        border: Border.all(color: isValid ? transparent : colorRed),
        borderRadius: BorderRadius.circular(6.5),
      ),
      child: TextField(
        onTap: onTapInput,

        //  () {
        //   setState(() {
        //     _showKeyBoard = true;
        //   });
        // },
        onChanged: onChanged,
        // (value) {
        //   // check case copy and paste
        //   // kiem tra xem do dai nhu the nao
        //   String newValue = value;
        //   List<String> listSplitValue = value.split('');
        //   if (listSplitValue[0] != "#") {
        //     newValue = "#${newValue.substring(0, newValue.length)}";
        //   }
        //   _hexController.text = newValue;
        //   _isValid = checkHexString(newValue);
        //   if (_isValid) {
        //     _handleUpdateCurrentColor();
        //   }
        //   setState(() {});
        // },
        maxLength: maxLengthInput,
        keyboardType: TextInputType.none,
        controller: controller,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isLightMode ? black07 : white07,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: "",
          contentPadding: EdgeInsets.only(bottom: 17),
        ),
      ),
    );
  }

  static Widget buildSaveButton({
    required void Function() onSavedColor,
    required bool isSaved,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return GestureDetector(
      onTap: onSavedColor,
      child: Container(
        width: 30,
        height: 30,
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(6.5),
        ),
        child: Icon(
          isSaved ? FontAwesomeIcons.solidBookmark : FontAwesomeIcons.bookmark,
          size: 15,
          color: iconColor,
        ),
      ),
    );
  }

  static Widget buildDoneButton({
    required void Function() onTap,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          FontAwesomeIcons.check,
          size: 15,
          color: iconColor,
        ),
      ),
    );
  }
}
