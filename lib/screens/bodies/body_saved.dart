import 'package:color_picker_android/commons/colors.dart';
import 'package:color_picker_android/commons/constant.dart';
import 'package:flutter/material.dart';

class BodySaved extends StatefulWidget {
  final Color currentColor;
  final Function(Color color) onColorChange;
  final List<Color> listColorSaved;
  const BodySaved(
      {super.key,
      required this.currentColor,
      required this.onColorChange,
      required this.listColorSaved});

  @override
  State<BodySaved> createState() => _BodySavedState();
}

class _BodySavedState extends State<BodySaved> {
  late Size _size;
  late Color _selectedColor;
  @override
  void initState() {
    super.initState();
    _selectedColor = widget.currentColor;
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.sizeOf(context);
    return _buildSuggestColor();
  }

  Widget _buildSuggestColor() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Wrap(
          children: widget.listColorSaved
              .map(
                (e) => GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = e;
                    });
                    widget.onColorChange(_selectedColor);
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                width: 3,
                                color: _selectedColor == e
                                    ? colorGrey
                                    : transparent)),
                      ),
                      Container(
                        height: 30,
                        width: 30,
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: e,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList()),
    );
  }
}
