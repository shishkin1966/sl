import 'package:flutter/material.dart';
import 'package:sl/app/screen/home/HomeScreenState.dart';

class HomeScreenWidget extends StatefulWidget {
  HomeScreenWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  HomeScreenState createState() => new HomeScreenState();
}
