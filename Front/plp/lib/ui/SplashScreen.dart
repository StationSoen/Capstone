import 'package:flutter/Cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget SplashScreen() {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 10,
            height: 10,
          ),
          Container(
              child: Column(
            children: [
              SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.asset('assets/logo/splash.png')),
              Container(
                height: 37,
                child: Image.asset('assets/logo/splashname.png'),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoActivityIndicator(
                    animating: true,
                  ))
            ],
          )),
          SizedBox(
            width: 10,
            height: 10,
          ),
        ],
      )),
    ),
  );
}
