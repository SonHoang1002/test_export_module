import 'dart:math';

import 'package:color_picker_android/commons/colors.dart';
import 'package:color_picker_android/commons/constant.dart';
import 'package:color_picker_android/helpers/navigator_route.dart';
import 'package:color_picker_android/screens/color_picker_1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart'
    as flutter_colorpicker;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Color _currentColor;
  bool _isExpanded = false;
  double? _colorPickerHeight;
  final GlobalKey _keyColorPicker = GlobalKey(debugLabel: "_keyColorPicker");
  @override
  void initState() {
    super.initState();
    _currentColor = const Color(0xFF5E2FEB);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(color: _currentColor),
      floatingActionButton: Row(
        children: [
          FloatingActionButton(
            heroTag: "f1",
            onPressed: () async {
              // Obtain shared preferences.
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              List<String> listColorString =
                  prefs.getStringList(PREFERENCE_SAVED_COLOR_KEY) ?? [];
              List<Color> listSavedColor = listColorString
                  .map((e) => Color(
                      int.parse(e.split('(0x')[1].split(')')[0], radix: 16)))
                  .toList();
              // ignore: use_build_context_synchronously
              showModalBottomSheet(
                  context: context,
                  builder: (ctx) {
                    return StatefulBuilder(builder: (context, setStatefull) {
                      return ColorPicker(
                        isLightMode: true,
                        key: _keyColorPicker,
                        currentColor: _currentColor,
                        onDone: (color) {
                          setState(() {
                            _currentColor = color;
                          });
                          popNavigator(context);
                        },
                        listColorSaved: listSavedColor,
                        onColorSave: (Color color) async {
                          // kiem tra xem co mau do trong list chua
                          if (listSavedColor.contains(color)) {
                            listSavedColor = List.from(listSavedColor
                                .where((element) => element != color)
                                .toList());
                          } else {
                            listSavedColor = [
                              color,
                              ...List.from(listSavedColor)
                            ];
                          }
                          await prefs.setStringList(PREFERENCE_SAVED_COLOR_KEY,
                              listSavedColor.map((e) => e.toString()).toList());
                        },
                      );
                    });
                  },
                  backgroundColor: transparent,
                  isScrollControlled: true);
            },
          ),
          FloatingActionButton(
            heroTag: "f2",
            onPressed: () async {
              showModalBottomSheet(
                  context: context,
                  builder: (ctx) {
                    return StatefulBuilder(builder: (context, setStatefull) {
                      return Container(height: 600,width:400,
                        child: Center(
                          child: flutter_colorpicker.ColorPicker(
                              pickerColor: colorWhite, onColorChanged: (color) {}),
                        ),
                      );
                    });
                  },
                  backgroundColor: transparent,
                  isScrollControlled: true);
            },
          ),
        ],
      ),
    );
  }
}
