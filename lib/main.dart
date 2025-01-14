import 'package:color_picker_android/color_picker_flutter.dart';
import 'package:color_picker_android/commons/colors.dart';
import 'package:color_picker_android/commons/constants.dart';
import 'package:color_picker_android/helpers/convert.dart';
import 'package:color_picker_android/helpers/navigator_route.dart';
import 'package:flutter/material.dart';
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
  Color? _currentColor;
  final GlobalKey _keyColorPicker = GlobalKey(debugLabel: "_keyColorPicker");
  @override
  void initState() {
    super.initState();
    // _currentColor = const Color(0xFF5E2FEB);
    // _currentColor = transparent; // const Color(0xFF5E2FEB);
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
        mainAxisAlignment: MainAxisAlignment.center,
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
                  .map((e) => convertHexStringToColor(e))
                  .toList();
              // ignore: use_build_context_synchronously
              showModalBottomSheet(
                context: context,
                builder: (ctx) {
                  return ColorPickerPhone(
                    isLightMode: true,
                    key: _keyColorPicker,
                    currentColor: _currentColor,
                    onDone: (color) {
                      print("onDone: $color");
                      popNavigator(context);
                    },
                    onColorChange: (color) {},
                    listColorSaved: listSavedColor,
                    onColorSave: (Color? color) async {
                      // kiem tra xem co mau do trong list chua
                      if (listSavedColor.contains(color)) {
                        listSavedColor = List.from(listSavedColor
                            .where((element) => element != color)
                            .toList());
                      } else {
                        listSavedColor = [
                          color ?? transparent,
                          ...List.from(listSavedColor)
                        ];
                      }
                      await prefs.setStringList(
                        PREFERENCE_SAVED_COLOR_KEY,
                        listSavedColor
                            .map((e) => convertColorToHexString(e))
                            .toList(),
                      );
                    },
                    containTransparent: false,
                    // maxWidth: 500,
                  );
                },
                backgroundColor: transparent,
                isScrollControlled: true,
                enableDrag: true,
                barrierColor: transparent,
              );
            },
          ),
        ],
      ),
    );
  }
}
