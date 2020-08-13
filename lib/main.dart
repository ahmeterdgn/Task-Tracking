import 'package:flutter/material.dart';
import 'package:xtech/views/detail.dart';
import 'package:xtech/views/home.dart';
import 'package:xtech/views/jobs.dart';
import 'package:xtech/views/notification.dart';
import 'package:xtech/views/test.dart';
import 'views/login.dart';

Future<void> main() async {
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
      theme: ThemeData(
        accentColor: Colors.red,
        primaryColor: Colors.red,
      ),
      // debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => TestPage(),
        '/home': (context) => MainPage(),
        '/login': (context) => LoginPage(),
        '/jobs': (context) => JopsPage(),
        '/detail': (context) => DetailPage(),
        '/notification': (context) => NotificationPage(),
      },
    );
  }
}
