import 'package:color_picker_android/commons/colors.dart';
import 'package:color_picker_android/commons/constants.dart';
import 'package:color_picker_android/helpers/check_hex.dart';
import 'package:color_picker_android/helpers/check_utf16.dart';
import 'package:color_picker_android/helpers/convert.dart';
import 'package:color_picker_android/screens/bodies/body_hsb.dart';
import 'package:color_picker_android/screens/bodies/body_palette.dart';
import 'package:color_picker_android/screens/bodies/body_picker.dart';
import 'package:color_picker_android/screens/bodies/body_saved.dart';
import 'package:color_picker_android/screens/widgets/w_color_picker.dart';
import 'package:color_picker_android/widgets/w_keyboard.dart';
import 'package:flutter/material.dart';

class ColorPickerPhone extends StatefulWidget {
  ///
  final bool isLightMode;

  /// show title "Color"
  final bool isHaveTitle;

  //
  final bool containTransparent;

  /// current color
  /// special case: transparent
  final Color currentColor;

  /// change theme of input, button, segment controls,
  final Color? topicColor;

  /// change color of save icon
  final Color? colorIconSave;

  /// change color of check icon
  final Color? colorIconCheck;

  // background color picker
  final Color? backgroundColor;

  /// color list to render for save tab
  final List<Color> listColorSaved;

  /// additinal widget on the left of title widget ( left of textfield button )
  final Widget? titleWidgetLeft;

  /// additinal widget on the right of title widget ( left of done button )
  final Widget? titleWidgetRight;

  /// call on click to done button
  /// color is null -> transparent color
  final void Function(Color? color) onDone;

  /// call on click to save button
  /// color is null -> transparent color
  final void Function(Color? color)? onColorSave;

  /// call on drag to change color
  /// color is null -> transparent color
  final void Function(Color? color)? onColorChange;

  const ColorPickerPhone({
    super.key,
    required this.currentColor,
    required this.listColorSaved,
    required this.isLightMode,
    required this.onDone,
    this.topicColor,
    this.colorIconSave,
    this.colorIconCheck,
    this.backgroundColor,
    this.onColorSave,
    this.onColorChange,
    this.titleWidgetLeft,
    this.titleWidgetRight,
    this.isHaveTitle = true,
    this.containTransparent = false,
  });

  @override
  State<ColorPickerPhone> createState() => _ColorPickerPhoneState();
}

class _ColorPickerPhoneState extends State<ColorPickerPhone> {
  final TextEditingController _hexController = TextEditingController(text: "");
  final GlobalKey _keyTextField = GlobalKey(debugLabel: "_keyTextField");

  late Size _size;

  bool? _showKeyBoard = false;
  bool _isValid = true;
  bool _isSaved = false;
  late bool isDarkMode;

  int _indexSegment = 0;
  late double _widthColorBody;

  Color? _selectedColor;
  List<Color> _listColorSaved = [];
  late int _maxLengthInput;
  @override
  void initState() {
    super.initState();
    _listColorSaved = List.from(widget.listColorSaved);
    _selectedColor = widget.currentColor;
    if (widget.containTransparent) {
      _maxLengthInput = MAX_LENGTH_INPUT_2;
    } else {
      _maxLengthInput = MAX_LENGTH_INPUT_1;
    }
    if ([null].contains(_selectedColor)) {
      _hexController.text = "";
    } else {
      _hexController.text = convertColorToHexString(_selectedColor!);
    }
  }

  void _handleDisableKeyBoard() {
    _showKeyBoard = null;
    _handleUnFocusKeyBoard();
    setState(() {});
  }

  void _handleUpdateCurrentColor() {
    final lengthOfHexController = _hexController.text.trim().length;
    if (lengthOfHexController < 7) {
      for (int i = 0; i < 7 - lengthOfHexController; i++) {
        _handeInsertText("0");
      }
    }
    String content = _hexController.text.trim();
    final hex6String = content.substring(1, content.length);
    if (_isValid) {
      _selectedColor = convertHexStringToColor(hex6String);
    }
  }

  void _handleUnFocusKeyBoard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _handeInsertText(String myText) {
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

  void _handleBackspace() {
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

  void _onTapInput() {
    setState(() {
      _showKeyBoard = true;
    });
  }

  void _onChangedInput(String value) {
    // check case copy and paste
    // kiem tra xem do dai nhu the nao
    String newValue = value;
    List<String> listSplitValue = value.split('');
    if (listSplitValue[0] != "#") {
      newValue = "#${newValue.substring(0, newValue.length)}";
    }
    _hexController.text = newValue;
    _isValid =
        checkHexString(newValue, containTransparent: widget.containTransparent);
    if (_isValid) {
      _handleUpdateCurrentColor();
    }
    setState(() {});
  }

  void _onColorChange(Color? color) {
    _handleUnFocusKeyBoard();
    _selectedColor = color;
    if ([null].contains(_selectedColor)) {
      _hexController.text = "";
    } else {
      _hexController.text = convertColorToHexString(_selectedColor!);
    }
    if (widget.onColorChange != null) {
      widget.onColorChange!(_selectedColor);
    }
    setState(() {});
  }

  void _onSavedColor() {
    if (_listColorSaved.contains(_selectedColor)) {
      _listColorSaved = _listColorSaved
          .where((element) => element != _selectedColor)
          .toList();
    } else {
      _listColorSaved = [
        _selectedColor ?? transparent,
        ...List.from(_listColorSaved)
      ];
    }
    _handleDisableKeyBoard();
    setState(() {});
    widget.onColorSave != null ? widget.onColorSave!(_selectedColor) : null;
  }

  void _onDone() {
    _handleDisableKeyBoard();
    widget.onDone(_selectedColor);
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _widthColorBody = _size.width * 0.85;
    _isSaved = _listColorSaved.contains(_selectedColor);
    _isValid = checkHexString(_hexController.text.trim(),
        containTransparent: widget.containTransparent);
    isDarkMode = !widget.isLightMode;

    return Container(
      height: double.infinity,
      width: double.infinity,
      color: transparent,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          _buildBackground(),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 520 + (_showKeyBoard == true ? 120 : 0),
                width: _size.width * 0.97,
                decoration: BoxDecoration(
                  color: widget.backgroundColor ??
                      (widget.isLightMode
                          ? const Color.fromRGBO(249, 249, 249, 1)
                          : const Color.fromRGBO(29, 29, 29, 1)),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.only(
                  top: 20,
                  bottom: MediaQuery.of(context).padding.bottom,
                ),
                margin: const EdgeInsets.only(bottom: 5),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        _buildTitleWidget(),
                        const SizedBox(height: 20),
                        _buildSegmentedControl(),
                        Expanded(
                          child: _buildBody(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_showKeyBoard == true)
                GestureDetector(
                  onTap: () {
                    _handleUpdateCurrentColor();
                    _handleDisableKeyBoard();
                  },
                  onPanStart: (details) {
                    _handleUpdateCurrentColor();
                    _handleDisableKeyBoard();
                  },
                ),
              Container(
                height: 520 + (_showKeyBoard == true ? 120 : 0),
                width: _size.width * 0.9,
                margin: const EdgeInsets.only(bottom: 5),
                padding: const EdgeInsets.only(top: 20),
                child: _buildTextFieldAndButtons(),
              ),
              _buildKeyBoard(_showKeyBoard == true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return WColorPicker.buildBackground(context);
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
              if (widget.titleWidgetLeft != null) widget.titleWidgetLeft!,
              WColorPicker.buildTextField(
                key: _keyTextField,
                controller: _hexController,
                isLightMode: widget.isLightMode,
                isValid: _isValid,
                onTapInput: _onTapInput,
                onChanged: _onChangedInput,
              ),
              const SizedBox(width: 7),
              _buildSaveButton(),
            ],
          ),
          Row(
            children: [
              if (widget.titleWidgetRight != null) widget.titleWidgetRight!,
              _buildDoneButton()
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitleWidget() {
    return Opacity(
      opacity: widget.isHaveTitle ? 1 : 0,
      child: WColorPicker.buildTitle(widget.isLightMode),
    );
  }

  Widget _buildSegmentedControl() {
    return WColorPicker.buildSegmentedControl(
      width: _widthColorBody,
      isLightMode: widget.isLightMode,
      indexSegment: _indexSegment,
      bgColor: widget.topicColor ?? (widget.isLightMode ? black005 : white01),
      onValueChanged: (int value) {
        _handleUnFocusKeyBoard();
        setState(() {
          _indexSegment = value;
        });
      },
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        BodyPalette(
          currentColor: _selectedColor,
          onColorChange: _onColorChange,
          isLightMode: widget.isLightMode,
          width: _widthColorBody,
          isFocus: _indexSegment == 0,
        ),
        BodyHSB(
          currentColor: _selectedColor!,
          onColorChange: _onColorChange,
          isLightMode: widget.isLightMode,
          isShowKeyboard: _showKeyBoard,
          isFocus: _indexSegment == 1,
        ),
        BodyPicker(
          currentColor: _selectedColor,
          onColorChange: _onColorChange,
          isLightMode: widget.isLightMode,
          isShowKeyboard: _showKeyBoard,
          isFocus: _indexSegment == 2,
        ),
        BodySaved(
          currentColor: _selectedColor,
          listColorSaved: _listColorSaved,
          onColorChange: _onColorChange,
          isLightMode: widget.isLightMode,
          isFocus: _indexSegment == 3,
        )
      ],
    );
  }

  Widget _buildKeyBoard(bool showKeyBoard) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // 576ABC890
          CustomKeyboardWidget(
            showKeyBoard: showKeyBoard,
            width: _size.width,
            isLightMode: widget.isLightMode,
            onEnter: (value) {
              _handeInsertText(value);
              if (_hexController.text.trim().length > _maxLengthInput - 1) {
                final newText =
                    _hexController.text.trim().substring(0, _maxLengthInput);
                if (checkHexString(newText,
                    containTransparent: widget.containTransparent)) {
                  _selectedColor = convertHexStringToColor(newText);
                }
                _hexController.text = newText;
                _handleDisableKeyBoard();
                return;
              }
              setState(() {});
            },
            onBackSpace: () {
              _handleBackspace();
              setState(() {});
            },
            onDone: () {
              _handleUpdateCurrentColor();
              _handleDisableKeyBoard();
            },
          ),
        ],
      ),
    );
  }

  // child
  Widget _buildSaveButton() {
    Color iconColor;
    if (widget.colorIconSave != null) {
      iconColor = widget.colorIconSave!;
    } else {
      if (widget.isLightMode) {
        iconColor = black07;
      } else {
        if (_isSaved) {
          iconColor = white1;
        } else {
          iconColor = white07;
        }
      }
    }
    return WColorPicker.buildSaveButton(
      onSavedColor: _onSavedColor,
      isSaved: _isSaved,
      backgroundColor:
          widget.topicColor ?? (widget.isLightMode ? black005 : white005),
      iconColor: iconColor,
    );
  }

  Widget _buildDoneButton() {
    return WColorPicker.buildDoneButton(
      onTap: _onDone,
      backgroundColor:
          widget.topicColor ?? (widget.isLightMode ? black005 : white005),
      iconColor:
          widget.colorIconSave ?? (widget.isLightMode ? black07 : white07),
    );
  }
}
