import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './gallery/index.dart';
//import './chat/index.dart';
//import './quiz/index.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color.fromRGBO(190, 190, 190, 1), // status bar color
      ),
    );

    return MaterialApp(
      title: 'Admin',
      home: Gallery(),
    );
  }
}
