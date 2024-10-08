import 'package:color_picker_android/commons/colors.dart';
import 'package:color_picker_android/commons/constants.dart';
import 'package:color_picker_android/widgets/w_text_content.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: must_be_immutable
class CustomKeyboardWidget extends StatelessWidget {
  final Function(String value) onEnter;
  final Function() onBackSpace;
  final Function() onDone;
  final bool isLightMode;
  final bool showKeyBoard;
  final double width;
  CustomKeyboardWidget({
    super.key,
    required this.onEnter,
    required this.onBackSpace,
    required this.isLightMode,
    required this.onDone,
    required this.showKeyBoard,
    required this.width,
  });
  late double sizeOfKeyboard;

  @override
  Widget build(BuildContext context) {
    Duration duration = const Duration(milliseconds: 300);
    return LayoutBuilder(
      builder: (context, constr) {
        sizeOfKeyboard = width - 12;
        return AnimatedOpacity(
          duration: duration,
          opacity: showKeyBoard == true ? 1 : 0,
          curve: CUBIC_CURVE,
          child: AnimatedContainer(
            width: sizeOfKeyboard,
            height: showKeyBoard == true ? 300 : 0,
            duration: duration,
            curve: CUBIC_CURVE,
            decoration: BoxDecoration(
              color: isLightMode
                  ? const Color.fromRGBO(249, 249, 249, 1)
                  : const Color.fromRGBO(29, 29, 29, 1),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(1, 2),
                  blurRadius: 2,
                  spreadRadius: 1,
                  color: colorGrey,
                )
              ],
            ),
            padding: EdgeInsets.only(
              top: 5,
              left: 5,
              right: 5,
              bottom: MediaQuery.of(context).padding.bottom + 5,
            ),
            child: Flex(
              direction: Axis.vertical,
              children: [
                // row 1
                Flexible(
                  flex: 1,
                  child: Flex(
                    direction: Axis.horizontal,
                    children: KEYBOARD_ROW_1
                        .map(
                          (e) => _buildNormalButton(e),
                        )
                        .toList(),
                  ),
                ),
                // row 2
                Flexible(
                  flex: 1,
                  child: Flex(
                    direction: Axis.horizontal,
                    children: KEYBOARD_ROW_2
                        .map(
                          (e) => _buildNormalButton(e),
                        )
                        .toList(),
                  ),
                ),
                // row 3
                Flexible(
                  flex: 2,
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Flexible(
                        child: Flex(
                          direction: Axis.vertical,
                          children: [
                            Flexible(
                              child: Flex(
                                direction: Axis.horizontal,
                                children: KEYBOARD_ROW_31
                                    .map((e) => _buildNormalButton(e))
                                    .toList(),
                              ),
                            ),
                            _buildNormalButton("0")
                          ],
                        ),
                      ),
                      Flexible(
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            _buildBackSpaceButton(),
                            _buildDoneButton("Done"),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNormalButton(
    String value,
  ) {
    return Flexible(
      flex: 1,
      child: InkWell(
        onTap: () {
          onEnter(value);
        },
        child: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: isLightMode ? black005 : white005,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: WTextContent(
              value: value,
              textColor: isLightMode ? black1 : white1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDoneButton(
    String value,
  ) {
    return Flexible(
      flex: 2,
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: isLightMode ? black005 : white005,
            borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          onTap: () {
            onDone();
          },
          child: Center(
            child: WTextContent(
              value: value,
              textColor: isLightMode ? black1 : white1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackSpaceButton() {
    return Flexible(
      flex: 1,
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: isLightMode ? black005 : white005,
            borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          onTap: () {
            onBackSpace();
          },
          child: Center(
            child: Icon(
              FontAwesomeIcons.deleteLeft,
              size: 20,
              color: isLightMode ? black1 : white1,
            ),
          ),
        ),
      ),
    );
  }
}
