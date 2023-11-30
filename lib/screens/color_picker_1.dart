import 'dart:convert';

import 'package:color_picker_android/commons/colors.dart';
import 'package:color_picker_android/commons/constant.dart';
import 'package:color_picker_android/helpers/check_utf16.dart';
import 'package:color_picker_android/helpers/navigator_route.dart';
import 'package:color_picker_android/screens/bodies/body_hsb.dart';
import 'package:color_picker_android/screens/bodies/body_palette.dart';
import 'package:color_picker_android/screens/bodies/body_picker.dart';
import 'package:color_picker_android/screens/bodies/body_saved.dart';
import 'package:color_picker_android/widgets/w_custom_keyboard.dart';
import 'package:color_picker_android/widgets/w_keyboard_screen.dart';
import 'package:color_picker_android/widgets/w_text_content.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ColorPicker extends StatefulWidget {
  final Color currentColor;

  /// call on click to done button
  final Function(Color color) onDone;

  /// call on click to save button
  final Function(Color color)? onColorSave;

  /// color list to render for save tab
  final List<Color> listColorSaved;

  /// change theme of input, button, segment controls,
  final Color? topicColor;

  // /// used for text of input, title
  // final Color? textColor;

  const ColorPicker({
    super.key,
    required this.currentColor,
    required this.onDone,
    required this.listColorSaved,
    this.onColorSave,
    this.topicColor = colorGrey,
    // this.textColor
  });
  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  int _indexSegment = 0;
  late Size _size;
  late Color _selectedColor;
  final TextEditingController _hexController = TextEditingController(text: "");

  void _onColorChange(Color color) {
    _unFocusKeyBoard();
    setState(() {
      _selectedColor = color;
      _hexController.text = _colorToHexString(_selectedColor);
    });
  }

  String _colorToHexString(Color color) {
    final newHexString = color.value.toRadixString(16).toUpperCase();
    final result = newHexString.substring(2, newHexString.length);
    return '#$result';
  }

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.currentColor;
    _hexController.text = _colorToHexString(_selectedColor);
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: 480,
        width: _size.width * 0.95,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: colorRed.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8)),
        child: Stack(
          children: [
            Column(
              children: [
                _buildTitleWidget(),
                const SizedBox(height: 20),
                _segmentedControl(),
                _buildBody()
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _unFocusKeyBoard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _insertText(String myText) {
    final text = _hexController.text;
    final textSelection = _hexController.selection;
    final newText = text.replaceRange(
      textSelection.start,
      textSelection.end,
      myText,
    );
    final myTextLength = myText.length;
    _hexController.text = newText;
    _hexController.selection = textSelection.copyWith(
      baseOffset: textSelection.start + myTextLength,
      extentOffset: textSelection.start + myTextLength,
    );
  }

  void _backspace() {
    final text = _hexController.text;
    final textSelection = _hexController.selection;
    final selectionLength = textSelection.end - textSelection.start;
    // There is a selection.
    if (selectionLength > 0) {
      final newText = text.replaceRange(
        textSelection.start,
        textSelection.end,
        '',
      );
      _hexController.text = newText;
      _hexController.selection = textSelection.copyWith(
        baseOffset: textSelection.start,
        extentOffset: textSelection.start,
      );
      return;
    }
    // The cursor is at the beginning.
    if (textSelection.start == 0) {
      return;
    }
    // Delete the previous character
    final previousCodeUnit = text.codeUnitAt(textSelection.start - 1);
    final offset = isUtf16Surrogate(previousCodeUnit) ? 2 : 1;
    final newStart = textSelection.start - offset;
    final newEnd = textSelection.start;
    final newText = text.replaceRange(
      newStart,
      newEnd,
      '',
    );
    _hexController.text = newText;
    _hexController.selection = textSelection.copyWith(
      baseOffset: newStart,
      extentOffset: newStart,
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
                  width: 80,
                  decoration: BoxDecoration(
                      color: widget.topicColor,
                      borderRadius: BorderRadius.circular(6.5)),
                  child: TextField(
                    onTap: () {
                      // show keyboard custom here
                      pushCustomVerticalMaterialPageRoute(
                          context,
                          CustomKeyboardScreen(
                              controller: _hexController,
                              onEnter: (value) {
                                _insertText(value);
                                setState(() {});
                              },
                              onBackSpace: () {
                                _backspace();
                                setState(() {});
                              }));
                    },
                    onChanged: (value) {},
                    keyboardType: TextInputType.none,
                    controller: _hexController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(bottom: 17)),
                  )),

              const SizedBox(
                width: 5,
              ),
              // save button
              GestureDetector(
                onTap: () {
                  _unFocusKeyBoard();
                  widget.onColorSave != null
                      ? widget.onColorSave!(_selectedColor)
                      : null;
                },
                child: Container(
                  width: 30,
                  height: 30,
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                      color: widget.topicColor,
                      borderRadius: BorderRadius.circular(6.5)),
                  child: Image.asset(
                    "${PATH_PREFFIX_ICON}icon_save_inactive.png",
                  ),
                ),
              ),
            ],
          ),
          WTextContent(value: "Colors"),
          GestureDetector(
            onTap: () {
              _unFocusKeyBoard();
              widget.onDone(_selectedColor);
            },
            child: Container(
              width: 30,
              height: 30,
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                  color: widget.topicColor,
                  borderRadius: BorderRadius.circular(20)),
              child: Image.asset(
                "${PATH_PREFFIX_ICON}icon_done.png",
              ),
            ),
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
          color: widget.topicColor,
          // color: Color.fromRGBO(0, 0, 0, 0.1),
          borderRadius: BorderRadius.circular(36),
        ),
        padding: 20,
        thumbDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: colorWhite,
        ),
        onValueChanged: (int value) {
          _unFocusKeyBoard();
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
        return BodyPalette(
          currentColor: _selectedColor,
          onColorChange: _onColorChange,
        );
      case 1:
        return BodyHSB(
          currentColor: _selectedColor,
          onColorChange: _onColorChange,
        );
      case 2:
        return BodyPicker(
          currentColor: _selectedColor,
          onColorChange: _onColorChange,
        );
      case 3:
        return BodySaved(
          currentColor: _selectedColor,
          listColorSaved: widget.listColorSaved,
          onColorChange: _onColorChange,
        );
      default:
        return const SizedBox();
    }
  }
}
