import 'package:color_picker_android/commons/colors.dart';
import 'package:color_picker_android/screens/bodies/body_hsb.dart';
import 'package:color_picker_android/screens/bodies/body_palette.dart';
import 'package:color_picker_android/screens/bodies/body_picker.dart';
import 'package:color_picker_android/screens/bodies/body_saved.dart';
import 'package:color_picker_android/widgets/w_text_content.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';

class ColorPicker1 extends StatefulWidget {
  const ColorPicker1({super.key});

  @override
  State<ColorPicker1> createState() => _ColorPicker1State();
}

class _ColorPicker1State extends State<ColorPicker1> {
  int _indexSegment = 0;
  late Size _size;
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        height: _size.height * 0.75,
        width: _size.width * 0.95,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: colorRed.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            _buildTitleWidget(),
            const SizedBox(height: 20),
            _segmentedControl(),
            _buildBody()
          ],
        ),
      ),
    );
  }

  Widget _buildTitleWidget() {
    return SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // preview value hex string color
              Container(
                height: 30,
                width: 70,
                decoration: BoxDecoration(
                    color: colorGrey, borderRadius: BorderRadius.circular(8)),
                child: Center(child: WTextContent(value: "#D87E37")),
              ),
              const SizedBox(
                width: 10,
              ),
              // save button
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    color: colorGrey, borderRadius: BorderRadius.circular(20)),
              ),
            ],
          ),
          WTextContent(value: "Colors"),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                color: colorGrey, borderRadius: BorderRadius.circular(20)),
          ),
        ],
      ),
    );
  }

  Widget _segmentedControl() {
    return SizedBox(
      width: _size.width * 0.9,
      child: CustomSlidingSegmentedControl<int>(
        isStretch: true,
        innerPadding: const EdgeInsets.all(2),
        children: {
          0: Text(
            "Palette",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _indexSegment == 0 ? colorBlue : colorBlack,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          1: Text(
            "HSB",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _indexSegment == 1 ? colorBlue : colorBlack,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          2: Text(
            "Picker",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _indexSegment == 2 ? colorBlue : colorBlack,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          3: Text(
            "Saved",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _indexSegment == 3 ? colorBlue : colorBlack,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          )
        },
        decoration: BoxDecoration(
          color: colorGrey,
          // color: Color.fromRGBO(0, 0, 0, 0.1),
          borderRadius: BorderRadius.circular(36),
        ),
        padding: 20,
        thumbDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: colorWhite,
        ),
        onValueChanged: (int value) {
          setState(() {
            _indexSegment = value;
          });
        },
      ),
    );
  }

  Widget _buildBody() {
    switch (_indexSegment) {
      case 0:
        return const BodyPalette();
      case 1:
        return const BodyHSB();
      case 2:
        return const BodyPicker();
      case 3:
        return const BodySaved();
      default:
        return const SizedBox();
    }
  }
}
