import 'package:flutter/material.dart';
import 'package:xtech/views/main.dart';
import 'views/login.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> configOneSignal() async {
    OneSignal.shared.init('ec0f816f-359d-43bf-8449-af98f20d7258');
    var status = await OneSignal.shared.getPermissionSubscriptionState();

    var playerId = status.subscriptionStatus.userId;
  }

  void initState() {
    super.initState();
    configOneSignal();
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
