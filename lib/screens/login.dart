import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:xtech/components/alert.dart';
import 'package:xtech/components/backgorund.dart';
import 'package:xtech/components/button.dart';
import 'package:xtech/components/inputRadius.dart';
import 'package:xtech/constants/global.dart';
import 'package:xtech/constants/lang.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();
  final fromKey = GlobalKey<FormState>();
  singIN({String email, String password, String playerId}) async {
    Map data = {
      'mail': email.trim(),
      'pass': password,
      'one_signal_id': playerId,
      'token': '56sdf6s56dfs66sdfvSGDF66sdfsy',
      'action': 'login'
    };
    var jsonData;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var response = await http.post(globalUrl, body: data);
    print(response.body);
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      print(jsonData['result']);
      if (jsonData['result'] == "success") {
        setState(() {
          sharedPreferences.setString('result', jsonData['result']);
          sharedPreferences.setString('login', 'ok');
          // Navigator.of(context).pushAndRemoveUntil(
          //     MaterialPageRoute(builder: (context) => LoginPage()),
          //     (Route<dynamic> route) => false);
        });
      } else if (jsonData['result'] == "error") {
        showAlertDialog(context, text: jsonData['message'], title: 'Error !!');
      } else {
        showAlertDialog(context,
            text: 'Unknown error has occurred', title: 'Error !!');
      }
    } else {
      showAlertDialog(context,
          text: 'Unknown error has occurred', title: 'Error !!');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: BacgorundComponents(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/login.png',
              height: size.height * 0.3,
            ),
            Text(
              loginWelcomeEN,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Form(
              key: fromKey,
              child: Column(
                children: [
                  InputRadiusComponents(
                    controller: emailcontroller,
                    hintText: 'Your Email',
                    icon: Icons.person,
                  ),
                  InputRadiusComponents(
                    controller: passwordcontroller,
                    obscureText: true,
                    hintText: 'Your Password',
                    icon: Icons.lock,
                  ),
                  RoundedButton(
                    text: 'LOGİN',
                    onPressed: () {
                      if (fromKey.currentState.validate()) {
                        setState(() {
                          Future<void> configOneSignal() async {
                            OneSignal.shared
                                .init('ec0f816f-359d-43bf-8449-af98f20d7258');
                            var status = await OneSignal.shared
                                .getPermissionSubscriptionState();
                            String playerId = status.subscriptionStatus.userId;
                            singIN(
                              email: emailcontroller.text,
                              password: passwordcontroller.text,
                              playerId: playerId,
                            );
                          }

                          configOneSignal();
                        });
                      } else {
                        print(passwordcontroller);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
