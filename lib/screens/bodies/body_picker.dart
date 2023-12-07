import 'dart:math';

import 'package:color_picker_android/commons/colors.dart';
import 'package:color_picker_android/commons/constant.dart';
import 'package:color_picker_android/helpers/contain_offset.dart';
import 'package:color_picker_android/widgets/w_slider_color.dart';
import 'package:flutter/material.dart';

class BodyPicker extends StatefulWidget {
  final Color currentColor;
  final bool isLightMode;
  final Function(Color color) onColorChange;
  final bool? isShowKeyboard;
  const BodyPicker(
      {super.key,
      required this.currentColor,
      required this.onColorChange,
      required this.isLightMode,
      this.isShowKeyboard});

  @override
  State<BodyPicker> createState() => _BodyPickerState();
}

class _BodyPickerState extends State<BodyPicker> {
  final double sizeOfPreviewColor = 40;
  late Size _size;
  double _dotSize = 28;
  Offset _offsetTrackerCursor = const Offset(0, 0);
  Offset _offsetDotHSV = const Offset(0, 0);

  final GlobalKey _keySlider = GlobalKey(debugLabel: "keySlider");
  final GlobalKey _keyHSVBoard = GlobalKey(debugLabel: "_keyHSVBoard");

  RenderBox? _renderBoxHSVBoard;
  RenderBox? _renderBoxSlider;
  bool? _isInsideHSVBoard;
  bool? _isInsideSlider;

  // hsv properties
  final double _hsvAlpha = 1.0;
  double _hsvHue = 0.0;
  double _hsvSaturation = 0.0;
  double _hsvValue = 1.0;
  // dùng để thay đổi màu tuong phản của border bảng chọn màu HSV
  List<double> _limitHueForBorderColors = [210, 275];
  //
  late double _widthColorBody;

  bool _onPanning = false;
  @override
  void initState() {
    super.initState();
    final hsvColor = HSVColor.fromColor(widget.currentColor);
    _hsvHue = hsvColor.hue;
    _hsvSaturation = hsvColor.saturation;
    _hsvValue = hsvColor.value;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _renderBoxHSVBoard =
          _keyHSVBoard.currentContext?.findRenderObject() as RenderBox;
      _renderBoxSlider =
          _keySlider.currentContext?.findRenderObject() as RenderBox;
      _changePositionWithHSVColor(hsvColor);
      setState(() {});
    });
  }

  void _onColorChanged() {
    widget.onColorChange(
        HSVColor.fromAHSV(_hsvAlpha, _hsvHue, _hsvSaturation, _hsvValue)
            .toColor());
  }

  void _changePositionWithHSVColor(HSVColor hsvColor) {
    if (_renderBoxHSVBoard != null) {
      _offsetDotHSV = Offset(
        hsvColor.saturation * (_renderBoxHSVBoard!.size.width - _dotSize),
        (1 - hsvColor.value) * _renderBoxHSVBoard!.size.height,
      );
    }
    if (_renderBoxSlider != null) {
      _offsetTrackerCursor = Offset(
        hsvColor.hue / 360 * (_renderBoxSlider!.size.width - _dotSize),
        _renderBoxSlider!.size.height,
      );
    }
  }

  void _updatePositionAndHSVProperty(Offset cursorGlobalPosition) {
    if (_renderBoxHSVBoard != null && _isInsideHSVBoard == true) {
      Size size = Size(
        _renderBoxHSVBoard!.size.width,
        _renderBoxHSVBoard!.size.height,
      );
      final newOffset = _renderBoxHSVBoard!.globalToLocal(cursorGlobalPosition);
      _offsetDotHSV = Offset(
        max(0, min(newOffset.dx, size.width)),
        max(0, min(newOffset.dy, size.height)),
      );
      _hsvValue = 1 - (_offsetDotHSV.dy) / (size.height);
      _hsvSaturation = (_offsetDotHSV.dx) / (size.width);
    }
    if (_renderBoxSlider != null && _isInsideSlider == true) {
      // khong cho thay doi khi s va v dang o limit
      if (_hsvSaturation != 0 || _hsvValue != 1) {
        Size size = Size(
          _renderBoxSlider!.size.width,
          _renderBoxSlider!.size.height,
        );
        final cursorLocalPosition =
            _renderBoxSlider!.globalToLocal(cursorGlobalPosition);
        Offset newOffset = Offset(
          max(0, min(cursorLocalPosition.dx, size.width - _dotSize)),
          max(0, min(cursorLocalPosition.dy, size.height)),
        );
        final newHue = (newOffset.dx) / (size.width - _dotSize) * 360;
        _hsvHue = newHue;
        _offsetTrackerCursor = newOffset;
      }
    }
    _onColorChanged();
    setState(() {});
  }

  void _checkInside(Offset cursorGlobalPosition) {
    if (_renderBoxHSVBoard != null) {
      final startOffsetHSVBoard =
          _renderBoxHSVBoard!.localToGlobal(const Offset(0, 0));
      final endOffsetHSVBoard = startOffsetHSVBoard.translate(
          _renderBoxHSVBoard!.size.width, _renderBoxHSVBoard!.size.height);
      if (containOffset(
          cursorGlobalPosition, startOffsetHSVBoard, endOffsetHSVBoard)) {
        _isInsideHSVBoard = true;
        setState(() {});
      }
    }
    if (_renderBoxSlider != null) {
      final startOffsetSlider =
          _renderBoxSlider!.localToGlobal(const Offset(0, 0));
      final endOffsetSlider = startOffsetSlider.translate(
          _renderBoxSlider!.size.width, _renderBoxSlider!.size.height);
      if (containOffset(
          cursorGlobalPosition, startOffsetSlider, endOffsetSlider)) {
        _isInsideSlider = true;
        setState(() {});
      }
    }
  }

  void _disableInside() {
    setState(() {
      _isInsideHSVBoard = null;
      _isInsideSlider = null;
      _onPanning = false;
    });
  }

  Color? _renderBorderColor() {
    if (_renderBoxHSVBoard != null) {
      if (_offsetDotHSV.dx < _renderBoxHSVBoard!.size.width / 3 &&
          _offsetDotHSV.dy < _renderBoxHSVBoard!.size.height / 3) {
        return colorBlack;
      }
      if (_offsetDotHSV.dy >= _renderBoxHSVBoard!.size.height / 2) {
        return colorWhite;
      }
      if (_limitHueForBorderColors[0] < _hsvHue &&
          _hsvHue < _limitHueForBorderColors[1]) {
        return colorWhite;
      } else {
        return colorBlack;
      }
    } else {
      return colorGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.sizeOf(context);
    _widthColorBody = _size.width * 0.85;
    if (!_onPanning) {
      final hsvColor = HSVColor.fromColor(widget.currentColor);
      _hsvHue = hsvColor.hue;
      _hsvSaturation = hsvColor.saturation;
      _hsvValue = hsvColor.value;
      _changePositionWithHSVColor(hsvColor);
    }
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: GestureDetector(
        onTapDown: (details) {
          if (widget.isShowKeyboard == true) {
            return;
          }
          _onPanning = true;
          _checkInside(details.globalPosition);
          _updatePositionAndHSVProperty(details.globalPosition);
        },
        onPanUpdate: (details) {
          _onPanning = true;
          _updatePositionAndHSVProperty(details.globalPosition);
        },
        onPanEnd: (details) {
          _disableInside();
        },
        onTapUp: (details) {
          _disableInside();
        },
        onPanStart: (details) {
          if (widget.isShowKeyboard == true) {
            return;
          }
          _onPanning = true;
          _checkInside(details.globalPosition);
        },
        child: Container(
          width: _size.width,
          margin: const EdgeInsets.only(bottom: 20),
          child: Column(children: [
            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(_dotSize / 2),
                  child: SizedBox(
                    key: _keyHSVBoard,
                    height: _size.height * 0.3,
                    width: _widthColorBody,
                    child: Stack(
                      children: [
                        // S from left to right
                        _buildSaturationBox(),
                        // value from bottom to top
                        _buildValueBox(),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    left: _offsetDotHSV.dx,
                    top: _offsetDotHSV.dy,
                    child: _buildDot(
                        HSVColor.fromAHSV(
                                _hsvAlpha, _hsvHue, _hsvSaturation, _hsvValue)
                            .toColor(),
                        borderWidth: 3,
                        borderColor: _renderBorderColor())),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SliderColor(
                key: _keySlider,
                dotSize: _dotSize,
                listGradientColor: COLOR_SLIDERS,
                offsetTracker: _offsetTrackerCursor,
                sliderWidth: _widthColorBody),
          ]),
        ),
      ),
    );
  }

  Widget _buildSaturationBox() {
    return Container(
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorGrey.withOpacity(0.3), width: 0.2),
        gradient: LinearGradient(colors: [
          colorWhite,
          HSVColor.fromAHSV(1, _hsvHue, 1, 1).toColor(),
        ], begin: Alignment.centerLeft, end: Alignment.centerRight),
      ),
    );
  }

  Widget _buildValueBox() {
    return Container(
      foregroundDecoration: BoxDecoration(
        border: Border.all(color: colorGrey.withOpacity(0.3), width: 0.2),
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(colors: [
          transparent,
          colorBlack,
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
    );
  }

// general
  Widget _buildDot(Color backgroundColor,
      {Color? borderColor = colorBlack, double? borderWidth = 2}) {
    return Container(
      height: _dotSize,
      width: _dotSize,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_dotSize / 2),
          border: Border.all(
            color: borderColor!,
            width: borderWidth!,
          ),
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.2),
                offset: Offset(0, 6),
                blurRadius: 15,
                spreadRadius: 0)
          ],
          color: backgroundColor),
    );
  }
}
