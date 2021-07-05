import 'package:flutter/material.dart';
import 'package:schejo/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[100],
        cardColor: Colors.grey[100],
        primaryColorLight: Colors.grey,
        primaryColor: Colors.teal,
        primaryColorDark: Colors.blueGrey,
        accentColor: Colors.brown,
        primarySwatch: Colors.blueGrey,
      ),
      home: HomePage(),
    );
  }
}
