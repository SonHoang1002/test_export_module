import 'package:color_picker_android/commons/colors.dart';
import 'package:color_picker_android/helpers/check_hex.dart';
import 'package:color_picker_android/helpers/check_utf16.dart';
import 'package:color_picker_android/helpers/convert.dart';
import 'package:color_picker_android/helpers/navigator_route.dart';
import 'package:color_picker_android/screens/bodies/body_hsb.dart';
import 'package:color_picker_android/screens/bodies/body_palette.dart';
import 'package:color_picker_android/screens/bodies/body_picker.dart';
import 'package:color_picker_android/screens/bodies/body_saved.dart';
import 'package:color_picker_android/widgets/w_keyboard.dart';
import 'package:color_picker_android/widgets/w_text_content.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ColorPickerTablet extends StatefulWidget {
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
  final bool isLightMode;
  final double height;
  final double? width;

  const ColorPickerTablet({
    super.key,
    required this.currentColor,
    required this.onDone,
    required this.listColorSaved,
    required this.isLightMode,
    this.height = 520,
    this.width,
    this.onColorSave,
    this.topicColor,
    this.colorIconSave,
    this.colorIconCheck,
    this.barrierColor,
  });
  @override
  State<ColorPickerTablet> createState() => _ColorPickerTabletState();
}

class _ColorPickerTabletState extends State<ColorPickerTablet> {
  final TextEditingController _hexController = TextEditingController(text: "");
  int _indexSegment = 0;
  late Size _size;
  late Color _selectedColor;
  bool? _showKeyBoard = false;
  bool _isSaved = false;
  late double _widthColorBody;
  // disable widget
  final GlobalKey _keyTextField = GlobalKey(debugLabel: "_keyTextField");
  //
  List<Color> _listColorSaved = [];
  int _maxLengthInput = 7;
  bool _isValid = true;
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
    _widthColorBody = (widget.width ?? _size.width) * 0.85;
    _isSaved = _listColorSaved.contains(_selectedColor);
    _isValid = checkHexString(_hexController.text.trim());

    return Container(
      height: double.infinity,
      width: double.infinity,
      color: transparent,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned.fill(child: GestureDetector(
            onTap: () {
              popNavigator(context);
            },
          )),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: widget.height + (_showKeyBoard == true ? 120 : 0),
                width: widget.width ?? _size.width * 0.97,
                decoration: BoxDecoration(
                    color: widget.isLightMode
                        ? const Color.fromRGBO(249, 249, 249, 1)
                        : const Color.fromRGBO(29, 29, 29, 1),
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.only(
                    top: 20, bottom: MediaQuery.of(context).padding.bottom),
                margin: const EdgeInsets.only(bottom: 5),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                            width: _widthColorBody, child: _buildTitleWidget()),
                        const SizedBox(height: 20),
                        _segmentedControl(),
                        Container(width: _widthColorBody, child: _buildBody()),
                      ],
                    ),
                  ],
                ),
              ),
              if (_showKeyBoard == true)
                GestureDetector(
                  onTap: () {
                    _updateCurrentColor();
                    _disableKeyBoard();
                  },
                  onPanStart: (details) {
                    _updateCurrentColor();
                    _disableKeyBoard();
                  },
                ),
              Container(
                  height: widget.height + (_showKeyBoard == true ? 120 : 0),
                  width: _widthColorBody,
                  margin: const EdgeInsets.only(bottom: 5),
                  padding: const EdgeInsets.only(top: 20),
                  child: _buildTextFieldAndButtons()),
              if (_showKeyBoard == true) _buildKeyBoard(),
            ],
          ),
        ],
      ),
    );
  }

  void _disableKeyBoard() {
    _showKeyBoard = null;
    _unFocusKeyBoard();
    setState(() {});
  }

  void _updateCurrentColor() {
    final lengthOfHexController = _hexController.text.trim().length;
    if (lengthOfHexController < 7) {
      for (int i = 0; i < 7 - lengthOfHexController; i++) {
        _insertText("0");
      }
    }
    String content = _hexController.text.trim();
    final hex6String = content.substring(1, content.length);
    if (_isValid) {
      _selectedColor = convertHexStringToColor(hex6String);
    }
  }

  void _unFocusKeyBoard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _insertText(String myText) {
    final text = _hexController.text;
    final textSelection = _hexController.selection;
    String newText = '';
    newText = text.replaceRange(
      textSelection.start,
      textSelection.end,
      myText,
    );
    final myTextLength = myText.length;
    if (textSelection.start == 0 && textSelection.end != 0) {
      _hexController.text = "#$newText";
      _hexController.selection = textSelection.copyWith(
        baseOffset: 2,
        extentOffset: 2,
      );
      return;
    }

    if (textSelection.start == 1 && textSelection.end == _maxLengthInput) {
      _hexController.text = newText;
      _hexController.selection = textSelection.copyWith(
        baseOffset: 2,
        extentOffset: 2,
      );
    } else {
      _hexController.text = newText;
      _hexController.selection = textSelection.copyWith(
        baseOffset: textSelection.start + myTextLength,
        extentOffset: textSelection.start + myTextLength,
      );
    }
  }

  void _backspace() {
    final text = _hexController.text;
    final textSelection = _hexController.selection;
    final selectionLength = textSelection.end - textSelection.start;
    // There is a selection.
    if (selectionLength > 0) {
      String newText = text.replaceRange(
        textSelection.start,
        textSelection.end,
        '',
      );
      if (textSelection.start == 0) {
        newText = "#$newText";
        _hexController.text = newText;
        _hexController.selection = textSelection.copyWith(
          baseOffset: 1,
          extentOffset: 1,
        );
      } else {
        _hexController.text = newText;
        _hexController.selection = textSelection.copyWith(
          baseOffset: textSelection.start,
          extentOffset: textSelection.start,
        );
      }
      return;
    }
    // The cursor is at the beginning.
    if (textSelection.start <= 1) {
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

  Widget _buildKeyBoard() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // 576ABC890
          CustomKeyboardWidget(
            isLightMode: widget.isLightMode,
            onEnter: (value) {
              _insertText(value);
              if (_hexController.text.trim().length > _maxLengthInput - 1) {
                final newText =
                    _hexController.text.trim().substring(0, _maxLengthInput);
                if (checkHexString(newText)) {
                  _selectedColor = convertHexStringToColor(newText);
                }
                _hexController.text = newText;
                _disableKeyBoard();
                return;
              }
              setState(() {});
            },
            onBackSpace: () {
              _backspace();
              setState(() {});
            },
            onDone: () {
              _updateCurrentColor();
              _disableKeyBoard();
            },
          ),
        ],
      ),
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
            WTextContent(
              value: "COLORS",
              textColor: widget.isLightMode ? null : white07,
            ),
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
                      color: widget.isLightMode ? black005 : white01,
                      border:
                          Border.all(color: _isValid ? transparent : colorRed),
                      borderRadius: BorderRadius.circular(6.5)),
                  child: TextField(
                    onTap: () {
                      setState(() {
                        _showKeyBoard = true;
                        final renderBoxTextField = _keyTextField.currentContext
                            ?.findRenderObject() as RenderBox;
                      });
                    },
                    onChanged: (value) {
                      // check case copy and paste
                      // kiem tra xem do dai nhu the nao
                      String newValue = value;
                      List<String> listSplitValue = value.split('');
                      if (listSplitValue[0] != "#") {
                        newValue = "#${newValue.substring(0, newValue.length)}";
                      }
                      _hexController.text = newValue;
                      _isValid = checkHexString(newValue);
                      if (_isValid) {
                        _updateCurrentColor();
                      }
                      setState(() {});
                    },
                    maxLength: _maxLengthInput,
                    keyboardType: TextInputType.none,
                    controller: _hexController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: widget.isLightMode ? black07 : white07,
                        fontSize: 13,
                        fontWeight: FontWeight.w700),
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
                  if (_listColorSaved.contains(_selectedColor)) {
                    _listColorSaved = _listColorSaved
                        .where((element) => element != _selectedColor)
                        .toList();
                  } else {
                    _listColorSaved = [
                      _selectedColor,
                      ...List.from(_listColorSaved)
                    ];
                  }
                  _disableKeyBoard();
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
                        color: widget.topicColor ??
                            (widget.isLightMode ? black005 : white005),
                        borderRadius: BorderRadius.circular(6.5)),
                    child: Icon(
                      _isSaved
                          ? FontAwesomeIcons.solidBookmark
                          : FontAwesomeIcons.bookmark,
                      size: 15,
                      color: widget.colorIconSave ??
                          (widget.isLightMode
                              ? black07
                              : _isSaved
                                  ? white1
                                  : white07),
                    )),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              _disableKeyBoard();
              widget.onDone(_selectedColor);
            },
            child: Container(
                width: 30,
                height: 30,
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                    color: widget.topicColor ??
                        (widget.isLightMode ? black005 : white005),
                    borderRadius: BorderRadius.circular(20)),
                child: Icon(
                  FontAwesomeIcons.check,
                  size: 15,
                  color: widget.colorIconSave ??
                      (widget.isLightMode ? black07 : white07),
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
              color: _getColorSegment(_indexSegment, 0),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          1: Text(
            "HSB",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _getColorSegment(_indexSegment, 1),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          2: Text(
            "Picker",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _getColorSegment(_indexSegment, 2),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          3: Text(
            "Saved",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _getColorSegment(_indexSegment, 3),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          )
        },
        decoration: BoxDecoration(
          color: widget.topicColor ?? (widget.isLightMode ? black005 : white01),
          borderRadius: BorderRadius.circular(11),
        ),
        padding: 10,
        thumbDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
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
            isLightMode: widget.isLightMode);
      case 1:
        return BodyHSB(
            currentColor: _selectedColor,
            onColorChange: _onColorChange,
            isLightMode: widget.isLightMode,
            isShowKeyboard: _showKeyBoard);
      case 2:
        return BodyPicker(
            currentColor: _selectedColor,
            onColorChange: _onColorChange,
            isLightMode: widget.isLightMode,
            isShowKeyboard: _showKeyBoard);
      case 3:
        return BodySaved(
            currentColor: _selectedColor,
            listColorSaved: _listColorSaved,
            onColorChange: _onColorChange,
            isLightMode: widget.isLightMode);
      default:
        return const SizedBox();
    }
  }

  Color _getColorSegment(int indexSegment, int checkValue) {
    if (widget.isLightMode) {
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
