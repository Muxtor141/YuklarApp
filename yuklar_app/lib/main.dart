import 'package:flutter/material.dart';
import 'package:yuklar_app/entry/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SharedPreferences.setMockInitialValues({});
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yuklar Demo',
      theme: ThemeData(
        textTheme: TextTheme(subtitle2: TextStyle(color: Colors.white)),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(child: LoginPage())),
    );
  }
}
