import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BodyState();
  }
}

class BodyState extends State<Body> {
  Map<int, Widget> map =
      new Map(); // Cupertino Segmented Control takes children in form of Map.
  List<Widget>
      childWidgets; //The Widgets that has to be loaded when a tab is selected.
  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    loadCupertinoTabs(); //Method to add Tabs to the Segmented Control.
    loadChildWidgets(); //Method to add the Children as user selected.
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CupertinoSegmentedControl(
          onValueChanged: (value) {
//Callback function executed when user changes the Tabs
            setState(() {
              selectedIndex = value;
            });
          },
          groupValue: selectedIndex, //The current selected Index or key
          selectedColor:
              Colors.blue, //Color that applies to selecte key or index
          pressedColor: Colors
              .red, //The color that applies when the user clicks or taps on a tab
          unselectedColor: Colors
              .grey, // The color that applies to the unselected tabs or inactive tabs
          padding: EdgeInsets.all(100),
          children: map, //The tabs which are assigned in the form of map
        ),
        getChildWidget(),
      ],
    );
  }

  void loadCupertinoTabs() {
    map = new Map();
    for (int i = 0; i < 4; i++) {
//putIfAbsent takes a key and a function callback that has return a value to that key.
// In our example, since the Map is of type <int,Widget> we have to return widget.
      map.putIfAbsent(
          i,
          () => Text(
                "Tab $i",
                style: TextStyle(color: Colors.white),
              ));
    }
  }

  void loadChildWidgets() {
    childWidgets = [];
    for (int i = 0; i < 4; i++)
      childWidgets.add(
        Center(
          child: Text("child $i"),
        ),
      );
  }

  Widget getChildWidget() => childWidgets[selectedIndex];
}
