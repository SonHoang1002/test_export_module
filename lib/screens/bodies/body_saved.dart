import 'package:color_picker_android/commons/colors.dart';
import 'package:flutter/material.dart';

class BodySaved extends StatefulWidget {
  final Color currentColor;
  final bool isLightMode;
  final Function(Color color) onColorChange;
  final List<Color> listColorSaved;
  const BodySaved(
      {super.key,
      required this.currentColor,
      required this.onColorChange,
      required this.listColorSaved,
      required this.isLightMode});

  @override
  State<BodySaved> createState() => _BodySavedState();
}

class _BodySavedState extends State<BodySaved> {
  late Size _size;
  late Color _selectedColor;
  double _sizeOfColorItem = 30;
  late double _widthColorBody;
  final double paddingEachColorItem = 22;
  final numberItemOnRow = 6;
  @override
  void initState() {
    super.initState();
    _selectedColor = widget.currentColor;
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.sizeOf(context);
    _selectedColor = widget.currentColor;
    _widthColorBody = _size.width * 0.85;
    _sizeOfColorItem = _widthColorBody / numberItemOnRow - paddingEachColorItem;
    return Expanded(child: _buildSuggestColor());
  }

  Widget _buildSuggestColor() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.only(bottom: 20),
      width: _widthColorBody + 20,
      child: GridView.builder(
        itemCount: widget.listColorSaved.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: numberItemOnRow),
        itemBuilder: (context, index) {
          final data = widget.listColorSaved[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedColor = data;
              });
              widget.onColorChange(_selectedColor);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: _sizeOfColorItem + paddingEachColorItem,
                  width: _sizeOfColorItem + paddingEachColorItem,
                  margin: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          (_sizeOfColorItem + paddingEachColorItem) / 2),
                      border: Border.all(
                          width: 3,
                          color: _selectedColor == data
                              ? widget.isLightMode
                                  ? black01
                                  : white03
                              : transparent)),
                ),
                Container(
                  height: _sizeOfColorItem,
                  width: _sizeOfColorItem,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(data.red, data.green, data.blue, 0.9),
                    border: Border.all(color: data, width: 2),
                    borderRadius: BorderRadius.circular(_sizeOfColorItem / 2),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
