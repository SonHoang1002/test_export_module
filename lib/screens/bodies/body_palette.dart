import 'dart:math';

import 'package:color_picker_android/commons/colors.dart';
import 'package:color_picker_android/commons/constant.dart';
import 'package:color_picker_android/helpers/contain_offset.dart';
import 'package:flutter/material.dart';

class BodyPalette extends StatefulWidget {
  final Color currentColor;
  final Function(Color color) onColorChange;
  const BodyPalette(
      {super.key, required this.currentColor, required this.onColorChange});

  @override
  State<BodyPalette> createState() => _BodyPaletteState();
}

class _BodyPaletteState extends State<BodyPalette> {
  late Color _selectedColor;
  final double _sizeOfColorItem = 30;
  final int _rowOfColorBoard = 10;
  final int _columnOfColorBoard = 12;

  // key
  final GlobalKey _keyColorBoard = GlobalKey(debugLabel: "_keyColorBoard");
  // renderBox
  late RenderBox _renderBoxColorBoard;
  bool? _isInsideColorBoard;
  @override
  void initState() {
    super.initState();
    _selectedColor = widget.currentColor;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _renderBoxColorBoard =
          _keyColorBoard.currentContext?.findRenderObject() as RenderBox;
      setState(() {});
    });
  }

  void _disableInside() {
    setState(() {
      _isInsideColorBoard = null;
    });
  }

  void _updatePositionAndSelectedColor(Offset cursorGlobalPosition) {
    if (_isInsideColorBoard == true) {
      final cursorLocalPosition =
          _renderBoxColorBoard.globalToLocal(cursorGlobalPosition);
      int indexX, indexY;
      // get index x
      // phan nguyen
      int tempIndexX = cursorLocalPosition.dx ~/ _sizeOfColorItem;
      //  phan du
      double residualX = cursorLocalPosition.dx % _sizeOfColorItem;
      if (residualX > 0) {
        indexX = tempIndexX + 1;
      } else if (residualX == 0) {
        indexX = tempIndexX;
      } else {
        indexX = 0;
      }
      // get index y
      // phan nguyen
      int tempIndexY = cursorLocalPosition.dy ~/ _sizeOfColorItem;
      //  phan du
      double residualY = cursorLocalPosition.dy % _sizeOfColorItem;
      if (residualY > 0) {
        indexY = tempIndexY + 1;
      } else if (residualY == 0) {
        indexY = tempIndexY;
      } else {
        indexY = 0;
      }
      indexX = max(0, min(indexX - 1, _columnOfColorBoard - 1));
      indexY = max(0, min(indexY - 1, _rowOfColorBoard - 1));
      int result = max(
          0,
          min((indexY * 12) + indexX,
              _rowOfColorBoard * _columnOfColorBoard - 1));
      setState(() {
        _selectedColor = COLORS_PALETTE[result];
      });
      widget.onColorChange(_selectedColor);
    }
  }

  void _checkInside(Offset cursorGlobalPosition) {
    final gStartOffsetColorBoard =
        _renderBoxColorBoard.localToGlobal(const Offset(0, 0));
    final gEndOffsetColorBoard = gStartOffsetColorBoard.translate(
        _renderBoxColorBoard.size.width, _renderBoxColorBoard.size.height);
    if (containOffset(
        cursorGlobalPosition, gStartOffsetColorBoard, gEndOffsetColorBoard)) {
      setState(() {
        _isInsideColorBoard = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: GestureDetector(
        onPanStart: (details) {
          _checkInside(details.globalPosition);
        },
        onPanUpdate: (details) {
          _updatePositionAndSelectedColor(details.globalPosition);
        },
        onPanEnd: (details) {
          _disableInside();
        },
        child: Container(
          key: _keyColorBoard,
          height: _sizeOfColorItem * _rowOfColorBoard,
          width: _sizeOfColorItem * _columnOfColorBoard,
          decoration: BoxDecoration(
            border: Border.all(width: 0.2, color: colorBlack),
            borderRadius: BorderRadius.circular(10),
          ),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 12),
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = COLORS_PALETTE[index];
                    });
                    widget.onColorChange(_selectedColor);
                  },
                  child: Container(
                    height: _sizeOfColorItem,
                    width: _sizeOfColorItem,
                    decoration: BoxDecoration(
                      color: COLORS_PALETTE[index],
                      borderRadius: _renderBorderRadius(index),
                      border: Border.all(
                          width: 2,
                          color: _selectedColor == COLORS_PALETTE[index]
                              ? _checkInsideArea(index, [0, 0])
                                  ? colorBlack
                                  : colorWhite
                              : transparent),
                    ),
                  ));
            },
            itemCount: COLORS_PALETTE.length,
          ),
        ),
      ),
    );
  }

  BorderRadius? _renderBorderRadius(int index) {
    if (index == 0) {
      return const BorderRadius.only(topLeft: Radius.circular(10));
    }
    if (index == _columnOfColorBoard - 1) {
      return const BorderRadius.only(topRight: Radius.circular(10));
    }
    if (index == _columnOfColorBoard * (_rowOfColorBoard - 1)) {
      return const BorderRadius.only(bottomLeft: Radius.circular(10));
    }
    if (index == _columnOfColorBoard * _rowOfColorBoard - 1) {
      return const BorderRadius.only(bottomRight: Radius.circular(10));
    }
    return null;
  }

  bool _checkInsideArea(int checkedIndex, List<int> area) {
    if (area[0] <= checkedIndex && checkedIndex <= area[1]) {
      return true;
    }
    return false;
  }
}
