import 'dart:math';

import 'package:color_picker_android/commons/colors.dart';
import 'package:color_picker_android/commons/constant.dart';
import 'package:color_picker_android/helpers/contain_offset.dart';
import 'package:color_picker_android/widgets/w_slider_color.dart';
import 'package:color_picker_android/widgets/w_text_content.dart';
import 'package:flutter/material.dart';

class BodyHSB extends StatefulWidget {
  final Color currentColor;
  final Function(Color color) onColorChange;
  const BodyHSB(
      {super.key, required this.currentColor, required this.onColorChange});

  @override
  State<BodyHSB> createState() => _BodyPickerState();
}

class _BodyPickerState extends State<BodyHSB> {
  double _dotSize = 28;
  late Size _size;
  // keys
  final GlobalKey _keyHue = GlobalKey(debugLabel: "_keyHue");
  final GlobalKey _keySaturation = GlobalKey(debugLabel: "_keySaturation");
  final GlobalKey _keyBrightness = GlobalKey(debugLabel: "_keyBrightness");

  // offsets
  Offset _offsetTrackerHue = const Offset(0, 0);
  Offset _offsetTrackerSaturation = const Offset(0, 0);
  Offset _offsetTrackerBrightness = const Offset(0, 0);

  late RenderBox _renderBoxHue;
  late RenderBox _renderBoxSaturation;
  late RenderBox _renderBoxBrightness;
  // store data
  double _hsbHue = 0;
  double _hsbSaturation = 0;
  // value of hsv Color
  double _hsbBrightness = 0;
  // status
  bool? _isInsideHue;
  bool? _isInsideSaturation;
  bool? _isInsideBrightness;
  //
  late double _widthColorBody;

  @override
  void initState() {
    super.initState();
    final initHsbColor = HSVColor.fromColor(widget.currentColor);
    _hsbHue = initHsbColor.hue;
    _hsbBrightness = initHsbColor.value;
    _hsbSaturation = initHsbColor.saturation;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _renderBoxHue = _keyHue.currentContext?.findRenderObject() as RenderBox;
      _renderBoxSaturation =
          _keySaturation.currentContext?.findRenderObject() as RenderBox;
      _renderBoxBrightness =
          _keyBrightness.currentContext?.findRenderObject() as RenderBox;
      _changePositionWithHSVColor(initHsbColor);
      setState(() {});
    });
  }

  void _changePositionWithHSVColor(HSVColor hsvColor) {
    _offsetTrackerHue = Offset(
      hsvColor.hue / 360 * (_renderBoxHue.size.width - _dotSize),
      0,
    );

    _offsetTrackerSaturation = Offset(
      hsvColor.saturation * (_renderBoxSaturation.size.width - _dotSize),
      0,
    );
    _offsetTrackerBrightness = Offset(
      hsvColor.value * (_renderBoxBrightness.size.width - _dotSize),
      0,
    );
  }

  void _disableInside() {
    setState(() {
      _isInsideBrightness = null;
      _isInsideHue = null;
      _isInsideSaturation = null;
    });
  }

  void _checkInside(Offset cursorGlobalPosition) {
    final gStartOffsetHue = _renderBoxHue.localToGlobal(const Offset(0, 0));
    final gEndOffsetHue = gStartOffsetHue.translate(
        _renderBoxHue.size.width, _renderBoxHue.size.height);
    if (containOffset(cursorGlobalPosition, gStartOffsetHue, gEndOffsetHue)) {
      setState(() {
        _isInsideHue = true;
      });
    }
    // saturation
    final gStartOffsetSaturation =
        _renderBoxSaturation.localToGlobal(const Offset(0, 0));
    final gEndOffsetSaturation = gStartOffsetSaturation.translate(
        _renderBoxSaturation.size.width, _renderBoxSaturation.size.height);
    if (containOffset(
        cursorGlobalPosition, gStartOffsetSaturation, gEndOffsetSaturation)) {
      setState(() {
        _isInsideSaturation = true;
      });
    }
    // brightness
    final gStartOffsetBrightness =
        _renderBoxBrightness.localToGlobal(const Offset(0, 0));
    final gEndOffsetBrightness = gStartOffsetBrightness.translate(
        _renderBoxBrightness.size.width, _renderBoxBrightness.size.height);
    if (containOffset(
        cursorGlobalPosition, gStartOffsetBrightness, gEndOffsetBrightness)) {
      setState(() {
        _isInsideBrightness = true;
      });
    }
  }

  void _updatePositionAndHSBProperties(Offset cursorGlobalPosition) {
    if (_isInsideHue == true) {
      Size size = Size(
        _renderBoxHue.size.width,
        _renderBoxHue.size.height,
      );
      Offset cursorLocalPosition =
          _renderBoxHue.globalToLocal(cursorGlobalPosition);
      Offset newOffsetHue = Offset(
        max(0, min(cursorLocalPosition.dx, size.width - _dotSize)),
        max(0, min(cursorLocalPosition.dy, size.height)),
      );
      double newHue = (newOffsetHue.dx) / (size.width - _dotSize) * 360;
      _hsbHue = newHue;
      _offsetTrackerHue = newOffsetHue;
      setState(() {});
    }
    if (_isInsideSaturation == true) {
      Size size = Size(
        _renderBoxSaturation.size.width,
        _renderBoxSaturation.size.height,
      );
      final newOffset =
          _renderBoxSaturation.globalToLocal(cursorGlobalPosition);
      _offsetTrackerSaturation = Offset(
        max(0, min(newOffset.dx, size.width - _dotSize)),
        max(0, min(newOffset.dy, size.height)),
      );
      _hsbSaturation = (_offsetTrackerSaturation.dx) / (size.width - _dotSize);
      setState(() {});
    }
    if (_isInsideBrightness == true) {
      Size size = Size(
        _renderBoxBrightness.size.width,
        _renderBoxBrightness.size.height,
      );
      final newOffset =
          _renderBoxBrightness.globalToLocal(cursorGlobalPosition);
      _offsetTrackerBrightness = Offset(
        max(0, min(newOffset.dx, size.width - _dotSize)),
        max(0, min(newOffset.dy, size.height)),
      );
      _hsbBrightness = (_offsetTrackerBrightness.dx) / (size.width - _dotSize);
      setState(() {});
    }
    widget.onColorChange(
        HSVColor.fromAHSV(1, _hsbHue, _hsbSaturation, _hsbBrightness)
            .toColor());
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.sizeOf(context);
    _widthColorBody = _size.width * 0.85;
    final initHsbColor = HSVColor.fromColor(widget.currentColor);
    _hsbHue = initHsbColor.hue;
    _hsbBrightness = initHsbColor.value;
    _hsbSaturation = initHsbColor.saturation;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _changePositionWithHSVColor(initHsbColor);
    });
    return GestureDetector(
      onPanStart: (details) {
        _checkInside(details.globalPosition);
      },
      onPanUpdate: (details) {
        _updatePositionAndHSBProperties(details.globalPosition);
      },
      onPanEnd: (details) {
        _disableInside();
      },
      onTapUp: (details) {
        _disableInside();
      },
      onTapDown: (details) {
        _checkInside(details.globalPosition);
        _updatePositionAndHSBProperties(details.globalPosition);
      },
      child: Column(
        children: [
          // hue widget
          _buildTitle("Hue", "${_hsbHue.toStringAsFixed(0)}°"),
          SliderColor(
              key: _keyHue,
              dotSize: _dotSize,
              listGradientColor: COLOR_SLIDERS,
              offsetTracker: _offsetTrackerHue,
              sliderWidth: _widthColorBody),
          // saturation widget
          _buildTitle(
              "Saturation", "${(_hsbSaturation * 100).toStringAsFixed(0)}%"),
          SliderColor(
              key: _keySaturation,
              dotSize: _dotSize,
              listGradientColor: [
                const Color.fromRGBO(216, 216, 216, 1),
                HSVColor.fromAHSV(1, _hsbHue, 1, 1).toColor()
              ],
              offsetTracker: _offsetTrackerSaturation,
              sliderWidth: _widthColorBody),
          // brightness widget
          _buildTitle(
              "Brightness", "${(_hsbBrightness * 100).toStringAsFixed(0)}%"),
          SliderColor(
              key: _keyBrightness,
              dotSize: _dotSize,
              listGradientColor: [
                colorBlack,
                HSVColor.fromAHSV(1, _hsbHue, 1, 1).toColor()
              ],
              offsetTracker: _offsetTrackerBrightness,
              sliderWidth: _widthColorBody),
          _buildPreviewColor()
        ],
      ),
    );
  }

  Widget _buildPreviewColor() {
    return Container(
      height: 60,
      width: 60,
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          color: HSVColor.fromAHSV(1, _hsbHue, _hsbSaturation, _hsbBrightness)
              .toColor(),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(width: 0.2)),
    );
  }

  Widget _buildTitle(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 10),
      width: _widthColorBody,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          WTextContent(value: title),
          WTextContent(value: value),
        ],
      ),
    );
  }
}
