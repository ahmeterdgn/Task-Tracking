import 'package:flutter/material.dart';
import 'package:xtech/views/home.dart';
import 'views/login.dart';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}
