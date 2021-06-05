import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class AboutPage extends StatelessWidget {
  String appName;
  String appVersion;

  String developers;
  String githubLink;

  AboutPage(
      {required this.appName,
      required this.appVersion,
      required this.developers,
      required this.githubLink});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CupertinoNavigationBar(
          middle: Text(
            "정보",
            style: TextStyle(fontSize: 18),
          ),
        ),
        body: SafeArea(
          child: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      child: Image.asset(
                        'assets/logo/splash.png',
                      ),
                    ),
                    Container(
                      height: 40,
                      child: Image.asset('assets/logo/splashname.png'),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                        margin: EdgeInsets.only(bottom: 30),
                        child: Text(
                          "Version " + appVersion,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        )),
                    Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text("Developers")),
                    Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Text(
                          developers,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black54),
                        )),
                    Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text("GitHub Link")),
                    Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Text(githubLink,
                            style: TextStyle(color: Colors.black54))),
                    Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text("Font Info")),
                    Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Text("레코체 : recipekorea.com",
                            style: TextStyle(color: Colors.black54))),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
