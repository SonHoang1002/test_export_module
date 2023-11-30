import 'package:color_picker_android/commons/colors.dart';
import 'package:color_picker_android/commons/constant.dart';
import 'package:color_picker_android/screens/color_picker_1.dart';
import 'package:color_picker_android/tests/custom_keyboard.dart';
import 'package:color_picker_android/tests/custom_keyboard_1.dart';
import 'package:color_picker_android/widgets/w_custom_keyboard.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: ColorPicker(
          currentColor: colorWhite,
          onDone: (color) {
            // set color
          },
          listColorSaved: ALL_COLORS,
          onColorSave: (Color color) {},
        ));
    // CustomKeyboardWidget(
    //   onEnter: (value) {},
    //   onBackSpace: () {},
    //   onDone: () {},
    // )
    // KeyboardDemo()
    // ColorPicker(
    //   currentColor: colorWhite,
    //   onDone: (color) {
    //     // set color
    //   },
    //   listColorSaved: ALL_COLORS,
    //   onColorSave: (Color color) {},
    // )
  }
}
