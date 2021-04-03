import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CircleButton extends StatelessWidget {
  String text;
  double height = 50;
  double width = 310;
  VoidCallback onPressed;
  Color color = Colors.white;
  Color textColor = Color(0xFF4386F9);

  double marginVertical = 0;

  CircleButton(
      {@required this.text,
      this.height = 50,
      this.width = 310,
      this.onPressed,
      this.marginVertical = 0,
      this.color = Colors.white,
      this.textColor = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: marginVertical),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(26.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.17),
            offset: Offset(0.0, 3.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      height: height,
      width: width,
      child: CupertinoButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 16, color: textColor),
        ),
      ),
    );
  }
}
