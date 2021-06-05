import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hive/hive.dart';
import 'package:plp/ui/component.dart';

class ColorPickPage extends StatefulWidget {
  @override
  _ColorPickPageState createState() => _ColorPickPageState();
}

class _ColorPickPageState extends State<ColorPickPage> {
  Color currentColor = Colors.limeAccent;
  List<Color> currentColors = [Colors.limeAccent, Colors.green];

  var setting = Hive.box('setting');

  void changeColor(Color color) => setState(() => currentColor = color);
  void changeColors(List<Color> colors) =>
      setState(() => currentColors = colors);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text("색 설정"),
      ),
      body: SafeArea(
        child: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialPicker(
                pickerColor: currentColor,
                onColorChanged: changeColor,
                enableLabel: true,
              ),
              CircleButton(
                color: Color(currentColor.value),
                textColor: useWhiteForeground(currentColor)
                    ? Colors.white
                    : Colors.black,
                text: "확인",
                onPressed: () {
                  print('${currentColor.value}');
                  print(Colors.deepOrange[50]!.value.toString());
                  setting.put('color', currentColor.value);
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
