import 'package:flutter/material.dart';
import 'package:xtech/views/main.dart';
import 'views/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ignore: must_call_super
  void initState() {
    // all();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/main': (context) => MainPage(),
      },
    );
  }

  // all() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   final logintrue = sharedPreferences.getString('login');
  //   if (logintrue == 'ok') {
  //     Navigator.push(
  //       context,
  //       new MaterialPageRoute(builder: (context) => new MainPage()),
  //     );
  //   }
  // }
}
