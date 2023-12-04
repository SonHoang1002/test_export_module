import 'package:color_picker_android/commons/colors.dart';
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

  final Color? colorIconSave;

  final Color? colorIconCheck;

  final Color? barrierColor;

  const ColorPicker(
      {super.key,
      required this.currentColor,
      required this.onDone,
      required this.listColorSaved,
      this.onColorSave,
      this.topicColor = colorGrey,
      this.colorIconSave,
      this.colorIconCheck,
      this.barrierColor});
  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  final Color _segmentInactiveTextColor = const Color.fromRGBO(0, 0, 0, 0.5);
  final TextEditingController _hexController = TextEditingController(text: "");
  int _indexSegment = 0;
  late Size _size;
  late Color _selectedColor;
  bool? _showKeyBoard = false;
  bool _isSaved = false;
  late double _widthColorBody;
  // disable widget
  final GlobalKey _keyTextField = GlobalKey(debugLabel: "_keyTextField");
  Offset? _offsetDisable;
    List<Color> _listColorSaved = [];

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
    _listColorSaved = List.from(widget.listColorSaved);
    _selectedColor = widget.currentColor;
    _hexController.text = convertColorToHexString(_selectedColor);
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _widthColorBody = _size.width * 0.85;
    _isSaved = _listColorSaved.contains(_selectedColor);
    return Container(
      alignment: Alignment.center,
      color: widget.barrierColor,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 480,
            width: _size.width * 0.97,
            decoration: BoxDecoration(
                color: const Color.fromRGBO(249, 249, 249, 1),
                borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.only(top: 20),
            child: Stack(
              children: [
                Column(
                  children: [
                    _buildTitleWidget(),
                    const SizedBox(height: 20),
                    _segmentedControl(),
                    _buildBody(),
                  ],
                ),
              ],
            ),
          ),
          if (_showKeyBoard == true)
            GestureDetector(
              onTap: () {
                setState(() {
                  _showKeyBoard = null;
                });
              },
            ),
          Container(
              height: 480,
              width: _size.width * 0.9,
              padding: const EdgeInsets.only(top: 20),
              child: _buildTextFieldAndButtons()),
          if (_showKeyBoard == true) _buildKeyBoard(),
        ],
      ),
    );
  }

  void _disableKeyBoard() {
    _showKeyBoard = null;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {});
  }

  Widget _buildKeyBoard() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomKeyboardWidget(
            onEnter: (value) {
              if (_hexController.text.trim().length > 6) {
                _selectedColor =
                    convertHexStringToColor(_hexController.text.trim());
                _disableKeyBoard();
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
              final lengthOfHexController = _hexController.text.trim().length;
              if (lengthOfHexController < 7) {
                for (int i = 0; i < 7 - lengthOfHexController; i++) {
                  _insertText("0");
                }
              }
              String content = _hexController.text.trim();
              final hex6String = content.substring(1, content.length);
              _selectedColor = convertHexStringToColor(hex6String);
              _disableKeyBoard();
            },
          ),
        ],
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
      child: SizedBox(
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
      ),
    );
  }

  Widget _buildTextFieldAndButtons() {
    return Align(
      alignment: Alignment.topCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // preview value hex string color
              Container(
                  key: _keyTextField,
                  height: 30,
                  width: 80,
                  decoration: BoxDecoration(
                      color: widget.topicColor,
                      borderRadius: BorderRadius.circular(6.5)),
                  child: TextField(
                    onTap: () {
                      setState(() {
                        _showKeyBoard = true;
                        final renderBoxTextField = _keyTextField.currentContext
                            ?.findRenderObject() as RenderBox;
                        _offsetDisable = renderBoxTextField
                            .localToGlobal(const Offset(0, 0));
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
                width: 7,
              ),
              // save button
              GestureDetector(
                onTap: () {
                  _showKeyBoard = null;
                  _unFocusKeyBoard(); 
                  if (_listColorSaved.contains(_selectedColor)) {
                    _listColorSaved = _listColorSaved
                        .where((element) => element != _selectedColor)
                        .toList();
                  } else {
                    _listColorSaved = [_selectedColor,...List.from(_listColorSaved)];
                  }
                  setState(() {});
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
                      color: widget.colorIconSave ?? colorBlack,
                    )),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _showKeyBoard = null;
                _unFocusKeyBoard();
              });
              widget.onDone(_selectedColor);
            },
            child: Container(
                width: 30,
                height: 30,
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                    color: widget.topicColor,
                    borderRadius: BorderRadius.circular(20)),
                child: Icon(
                  FontAwesomeIcons.check,
                  size: 15,
                  color: widget.colorIconSave ?? colorBlack,
                )),
          ),
        ],
      ),
    );
  }

  Widget _segmentedControl() {
    return SizedBox(
      width: _widthColorBody,
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
          listColorSaved: _listColorSaved,
          onColorChange: _onColorChange,
        );
      default:
        return const SizedBox();
    }
  }
}
