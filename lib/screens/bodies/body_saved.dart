import 'package:color_picker_android/commons/constant.dart';
import 'package:flutter/material.dart';

class BodySaved extends StatefulWidget {
  const BodySaved({super.key});

  @override
  State<BodySaved> createState() => _BodySavedState();
}

class _BodySavedState extends State<BodySaved> {
  late Size _size;
  late Color _selectedColor;
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.sizeOf(context);
    return _buildSuggestColor();
  }

  Widget _buildSuggestColor() {
    return SizedBox(
      // width: _size.width * 0.8,
      child: Wrap(
          children: ALL_COLORS
              .map(
                (e) => GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 42,
                    width: 42,
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: e,
                        borderRadius: BorderRadius.circular(21),
                        border: Border.all()),
                  ),
                ),
              )
              .toList()),
    );
  }
}
