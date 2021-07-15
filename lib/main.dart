import 'package:flutter/material.dart';

import 'AllScreens/addTaskScreen.dart';
import 'AllScreens/homePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Color color = Color(0xFF6C63FF);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Todo List',
      theme: ThemeData(
        primaryColor: color,
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

