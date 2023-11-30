import 'package:color_picker_android/commons/colors.dart';
import 'package:flutter/material.dart';

class SliderColor extends StatelessWidget {
  final double dotSize;
  final List<Color> listGradientColor;
  final double sliderWidth;
  final Offset offsetTracker;
  const SliderColor(
      {super.key,
      required this.dotSize,
      required this.listGradientColor,
      required this.offsetTracker,
      required this.sliderWidth});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // key: key,
      height: dotSize,
      width: sliderWidth,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(width: 0.3, color: colorBlack),
                gradient: LinearGradient(
                    colors: listGradientColor,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight),
                borderRadius: BorderRadius.circular(15)),
          ),
          Positioned(
            left: offsetTracker.dx,
            child: Container(
              height: dotSize,
              width: dotSize,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(dotSize / 2),
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        offset: Offset(0, 2),
                        blurRadius: 10,
                        spreadRadius: 0)
                  ],
                  border: Border.all(width: 3, color: colorWhite)),
            ),
          )
        ],
      ),
    );
    ;
  }
}
