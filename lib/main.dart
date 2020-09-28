import 'package:flutter/material.dart';
import 'package:xtech/screens/home.dart';
import 'package:xtech/screens/login.dart';
import 'package:xtech/screens/notification.dart';
import 'package:xtech/screens/task.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/notification': (context) => NotificationPage(),
        '/task': (context) => TaskPage(),
      },
    );
  }
}
