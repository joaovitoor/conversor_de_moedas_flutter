import 'package:estudo_flutter/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:estudo_flutter/stateFull.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: Controller.instance,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(

              primarySwatch: Colors.green,
              brightness: Controller.instance.isDartTheme
                  ? Brightness.dark
                  : Brightness.light,

              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: MyHomePage(title: 'Flutter Demo Home Page'),
          );
        }
    );
  }
}