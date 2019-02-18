import 'package:flutter/material.dart';
import 'package:sl/app/screen/home/HomeScreenWidget.dart';
import 'package:sl/ui/Application.dart';

void main() => runApp(new MyApp());

class MyApp extends Application {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomeScreenWidget(title: 'Flutter Demo Home Page'),
    );
  }
}
