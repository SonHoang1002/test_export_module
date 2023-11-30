import 'package:color_picker_android/commons/constant.dart';
import 'package:color_picker_android/widgets/w_text_content.dart';
import 'package:flutter/material.dart';

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
      height: sizeOfKeyboard * 0.7,
      width: sizeOfKeyboard,
      color: const Color.fromRGBO(249, 249, 249, 1),
      padding: const EdgeInsets.all(5),
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
        child: GestureDetector(
          onTap: () {
            onEnter(value);
          },
          child: Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: const Color.fromRGBO(0, 0, 0, 0.05),
                borderRadius: BorderRadius.circular(10)),
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
        child: GestureDetector(
          onTap: () {
            onDone();
          },
          child: Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: const Color.fromRGBO(0, 0, 0, 0.05),
                borderRadius: BorderRadius.circular(10)),
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
      child: GestureDetector(
        onTap: () {
          onBackSpace();
        },
        child: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: const Color.fromRGBO(0, 0, 0, 0.05),
              borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Image.asset(
            "${PATH_PREFFIX_ICON}icon_delete.png",
            height: 20,
            width: 20,
          )),
        ),
      ),
    );
  }
}

  // void _insertText(String myText) {
  //   final text = _controller.text;
  //   final textSelection = _controller.selection;
  //   final newText = text.replaceRange(
  //     textSelection.start,
  //     textSelection.end,
  //     myText,
  //   );
  //   final myTextLength = myText.length;
  //   _controller.text = newText;
  //   _controller.selection = textSelection.copyWith(
  //     baseOffset: textSelection.start + myTextLength,
  //     extentOffset: textSelection.start + myTextLength,
  //   );
  // }

  // void _backspace() {
  //   final text = _controller.text;
  //   final textSelection = _controller.selection;
  //   final selectionLength = textSelection.end - textSelection.start;
  //   // There is a selection.
  //   if (selectionLength > 0) {
  //     final newText = text.replaceRange(
  //       textSelection.start,
  //       textSelection.end,
  //       '',
  //     );
  //     _controller.text = newText;
  //     _controller.selection = textSelection.copyWith(
  //       baseOffset: textSelection.start,
  //       extentOffset: textSelection.start,
  //     );
  //     return;
  //   }
  //   // The cursor is at the beginning.
  //   if (textSelection.start == 0) {
  //     return;
  //   }
  //   // Delete the previous character
  //   final previousCodeUnit = text.codeUnitAt(textSelection.start - 1);
  //   final offset = _isUtf16Surrogate(previousCodeUnit) ? 2 : 1;
  //   final newStart = textSelection.start - offset;
  //   final newEnd = textSelection.start;
  //   final newText = text.replaceRange(
  //     newStart,
  //     newEnd,
  //     '',
  //   );
  //   _controller.text = newText;
  //   _controller.selection = textSelection.copyWith(
  //     baseOffset: newStart,
  //     extentOffset: newStart,
  //   );
  // }

