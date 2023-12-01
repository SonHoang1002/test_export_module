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
  double _sizeOfColorItem = 36;
  @override
  void initState() {
    super.initState();
    _selectedColor = widget.currentColor;
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.sizeOf(context);
    return Expanded(child: _buildSuggestColor());
  }

  Widget _buildSuggestColor() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: 380,
      child: GridView.builder(
        itemCount: widget.listColorSaved.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
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
                  height: _sizeOfColorItem + 10,
                  width: _sizeOfColorItem + 10,
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular((_sizeOfColorItem + 10) / 2),
                      border: Border.all(
                          width: 3,
                          color: _selectedColor == data
                              ? const Color.fromRGBO(0, 0, 0, 0.1)
                              : transparent)),
                ),
                Container(
                  height: _sizeOfColorItem,
                  width: _sizeOfColorItem,
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: data,
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
