import 'package:color_picker_android/commons/colors.dart';
import 'package:color_picker_android/commons/constant.dart';
import 'package:color_picker_android/widgets/w_text_content.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: must_be_immutable
class CustomKeyboardWidget extends StatelessWidget {
  final Function(String value) onEnter;
  final Function() onBackSpace;
  final Function() onDone;

  CustomKeyboardWidget(
      {super.key,
      required this.onEnter,
      required this.onBackSpace,
      required this.onDone});
  late double sizeOfKeyboard;
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.sizeOf(context);
    sizeOfKeyboard = _size.width;
    return Container(
      height: 300,
      width: sizeOfKeyboard, 
      decoration: const BoxDecoration(
          color: Color.fromRGBO(249, 249, 249, 1),
          boxShadow: [
            BoxShadow(
                offset: Offset(1, 2),
                blurRadius: 2,
                spreadRadius: 1,
                color: colorGrey)
          ]),
      padding: EdgeInsets.only(
          top: 5,
          left: 5,
          right: 5,
          bottom: MediaQuery.of(context).padding.bottom+5),
      child: Flex(
        direction: Axis.vertical,
        children: [
          // row 1
          Flexible(
            flex: 1,
            child: Flex(
              direction: Axis.horizontal,
              children:
                  KEYBOARD_ROW_1.map((e) => _buildNormalButton(e)).toList(),
            ),
          ),
          // row 2
          Flexible(
            flex: 1,
            child: Flex(
              direction: Axis.horizontal,
              children:
                  KEYBOARD_ROW_2.map((e) => _buildNormalButton(e)).toList(),
            ),
          ),
          // row 3
          Flexible(
            flex: 2,
            child: Flex(direction: Axis.horizontal, children: [
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
                children: [_buildBackSpaceButton(), _buildDoneButton("Done")],
              ))
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildNormalButton(
    String value,
  ) {
    return Flexible(
        flex: 1,
        child: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: const Color.fromRGBO(0, 0, 0, 0.05),
              borderRadius: BorderRadius.circular(10)),
          child: InkWell(
            onTap: () {
              onEnter(value);
            },
            child: Center(
                child: WTextContent(
              value: value,
            )),
          ),
        ));
  }

  Widget _buildDoneButton(
    String value,
  ) {
    return Flexible(
        flex: 2,
        child: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: const Color.fromRGBO(0, 0, 0, 0.05),
              borderRadius: BorderRadius.circular(10)),
          child: InkWell(
            onTap: () {
              onDone();
            },
            child: Center(
                child: WTextContent(
              value: value,
            )),
          ),
        ));
  }

  Widget _buildBackSpaceButton() {
    return Flexible(
      flex: 1,
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: const Color.fromRGBO(0, 0, 0, 0.05),
            borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          onTap: () {
            onBackSpace();
          },
          child: const Center(
              child: Icon(
            FontAwesomeIcons.deleteLeft,
            size: 20,
            color: Color.fromRGBO(0, 0, 0, 0.7),
          )
              //     Image.asset(
              //   "${PATH_PREFFIX_ICON}icon_delete.png",
              //   height: 20,
              //   width: 20,
              // )
              ),
        ),
      ),
    );
  }
}
