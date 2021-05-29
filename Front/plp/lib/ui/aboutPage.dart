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
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: CupertinoNavigationBar(
              automaticallyImplyLeading: true,
              middle: Text(
                "정보",
                style: TextStyle(fontSize: 18),
              ),
            ),
            body: SafeArea(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 30),
                        // ------- logo image -------
                        SizedBox(height: 200, width: 200, child: Container()),
                        // ------- logo image -------
                        SizedBox(height: 20),
                        Container(
                            margin: EdgeInsets.only(bottom: 30),
                            child: Text(
                              appName + " : Version " + appVersion,
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
                    ),
                  ),
                ),
              ),
            )));
  }
}
