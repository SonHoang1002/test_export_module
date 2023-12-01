import 'package:color_picker_android/commons/colors.dart';
import 'package:color_picker_android/commons/constant.dart';
import 'package:color_picker_android/helpers/check_utf16.dart';
import 'package:color_picker_android/helpers/convert.dart';
import 'package:color_picker_android/screens/bodies/body_hsb.dart';
import 'package:color_picker_android/screens/bodies/body_palette.dart';
import 'package:color_picker_android/screens/bodies/body_picker.dart';
import 'package:color_picker_android/screens/bodies/body_saved.dart';
import 'package:color_picker_android/widgets/w_keyboard.dart';
import 'package:color_picker_android/widgets/w_text_content.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  /// expand height
  final bool? isExpandHeight;
  final Function(bool value)? onExpandeHeight;

  const ColorPicker(
      {super.key,
      required this.currentColor,
      required this.onDone,
      required this.listColorSaved,
      this.onColorSave,
      this.topicColor = colorGrey,
      this.isExpandHeight,
      this.onExpandeHeight});
  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  final Color _segmentInactiveTextColor = const Color.fromRGBO(0, 0, 0, 0.5);

  int _indexSegment = 0;
  late Size _size;
  late Color _selectedColor;
  final TextEditingController _hexController = TextEditingController(text: "");
  bool? _showKeyBoard = false;
  bool _isSaved = false;

  void _onColorChange(Color color) {
    _unFocusKeyBoard();
    setState(() {
      _selectedColor = color;
      _hexController.text = convertColorToHexString(_selectedColor);
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.currentColor;
    _hexController.text = convertColorToHexString(_selectedColor);
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _isSaved = widget.listColorSaved.contains(_selectedColor);
    return Align(
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 480,
            width: _size.width * 0.97,
            decoration: BoxDecoration(
                color: const Color.fromRGBO(249, 249, 249, 1),
                borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                _buildTitleWidget(),
                const SizedBox(height: 20),
                _segmentedControl(),
                _buildBody(),
                // _showKeyBoard == true ? _buildKeyBoard() : const SizedBox()
              ],
            ),
          ),
          _showKeyBoard == true ? _buildKeyBoard() : const SizedBox()
        ],
      ),
    );
  }

  void _onExpandHeight(bool value) {
    widget.onExpandeHeight != null ? widget.onExpandeHeight!(value) : null;
  }

  Widget _buildKeyBoard() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showKeyBoard = null;
          _onExpandHeight(false);
        });
      },
      child: Container(
        color: transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            GestureDetector(
              onTap: () {
                print(
                    "add gesture detector to override GestureDetector parent");
              },
              child: CustomKeyboardWidget(
                onEnter: (value) {
                  if (_hexController.text.trim().length > 6) {
                    setState(() {
                      _showKeyBoard = null;
                      _onExpandHeight(false);
                    });
                    return;
                  }
                  _insertText(value);
                  setState(() {});
                },
                onBackSpace: () {
                  if (_hexController.selection.baseOffset == 1) {
                    return;
                  }
                  _backspace();
                  setState(() {});
                },
                onDone: () {
                  setState(() {
                    final lengthOfHexController =
                        _hexController.text.trim().length;
                    if (lengthOfHexController < 7) {
                      for (int i = 0; i < 7 - lengthOfHexController; i++) {
                        _insertText("0");
                      }
                    }
                    _showKeyBoard = null;
                    String content = _hexController.text.trim();
                    final hex6String = content.substring(1, content.length);
                    _selectedColor = convertHexStringToColor(hex6String);
                    _onExpandHeight(false);
                  });
                },
              ),
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
    if (textSelection.start <= 0) {
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 30,
      child: Stack(
        children: [
          Row(
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
                          setState(() {
                            _showKeyBoard = true;
                            _onExpandHeight(true);
                          });
                        },
                        onChanged: (value) {},
                        maxLength: 7,
                        keyboardType: TextInputType.none,
                        controller: _hexController,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700),
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            counterText: "",
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
                        child: Icon(
                          _isSaved
                              ? FontAwesomeIcons.solidBookmark
                              : FontAwesomeIcons.bookmark,
                          size: 15,
                        )
                        // Image.asset(
                        //   _isSaved
                        //       ? "${PATH_PREFFIX_ICON}icon_save_active.png"
                        //       : "${PATH_PREFFIX_ICON}icon_save_inactive.png",
                        // ),
                        ),
                  ),
                ],
              ),
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
                  child:
                      // const Icon(
                      //         FontAwesomeIcons.check,
                      //       size: 15,
                      //     )
                      Image.asset(
                    "${PATH_PREFFIX_ICON}icon_done.png",
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(),
                WTextContent(value: "Colors"),
                const SizedBox()
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _segmentedControl() {
    return SizedBox(
      width: 360,
      height: 36,
      child: CustomSlidingSegmentedControl<int>(
        isStretch: true,
        innerPadding: const EdgeInsets.all(2),
        children: {
          0: Text(
            "Palette",
            textAlign: TextAlign.center,
            style: TextStyle(
              color:
                  _indexSegment == 0 ? colorBlack : _segmentInactiveTextColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          1: Text(
            "HSB",
            textAlign: TextAlign.center,
            style: TextStyle(
              color:
                  _indexSegment == 1 ? colorBlack : _segmentInactiveTextColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          2: Text(
            "Picker",
            textAlign: TextAlign.center,
            style: TextStyle(
              color:
                  _indexSegment == 2 ? colorBlack : _segmentInactiveTextColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          3: Text(
            "Saved",
            textAlign: TextAlign.center,
            style: TextStyle(
              color:
                  _indexSegment == 3 ? colorBlack : _segmentInactiveTextColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          )
        },
        decoration: BoxDecoration(
          color: widget.topicColor,
          borderRadius: BorderRadius.circular(36),
        ),
        padding: 10,
        thumbDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(36),
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
