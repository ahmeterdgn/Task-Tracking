import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:xtech/Animation/FadeAnimation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xtech/views/home.dart';
import 'package:xtech/widget/alert.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  singIN(String email, String password) async {
    Map data = {'mail': email.trim(), 'pass': password};
    var jsonData;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var response = await http.post('http://xtech-ks.info/mobapi', body: data);
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      print(jsonData['result']);
      if (jsonData['result'] == "success") {
        setState(() {
          sharedPreferences.setString('result', jsonData['result']);
          sharedPreferences.setString('login', 'ok');
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MainPage()),
              (Route<dynamic> route) => false);
        });
      } else {
        showAlertDialog(context,
            text: 'E-mail and/or password wrong!', title: 'Error !!');
      }
    } else {}
  }

  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();

  final fromKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: fromKey,
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 400,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/background.png'),
                            fit: BoxFit.fill)),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 30,
                          width: 80,
                          height: 200,
                          child: FadeAnimation(
                              1,
                              Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/light-1.png'))),
                              )),
                        ),
                        Positioned(
                          left: 140,
                          width: 80,
                          height: 150,
                          child: FadeAnimation(
                              1.3,
                              Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/light-2.png'))),
                              )),
                        ),
                        Positioned(
                          right: 40,
                          top: 40,
                          width: 80,
                          height: 150,
                          child: FadeAnimation(
                              1.5,
                              Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/clock.png'))),
                              )),
                        ),
                        Positioned(
                          child: FadeAnimation(
                              1.6,
                              Container(
                                margin: EdgeInsets.only(top: 50),
                                child: Center(
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Column(
                      children: <Widget>[
                        FadeAnimation(
                            1.8,
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Color.fromRGBO(143, 148, 251, .2),
                                        blurRadius: 20.0,
                                        offset: Offset(0, 10))
                                  ]),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[100]))),
                                    child: TextFormField(
                                      controller: emailcontroller,
                                      validator: (val) {
                                        if (val.isEmpty) {
                                          return 'Do not leave blank';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Email or Phone number",
                                          hintStyle: TextStyle(
                                              color: Colors.grey[400])),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: passwordcontroller,
                                      obscureText: true,
                                      validator: (val) {
                                        if (val.length < 2) {
                                          return 'Minimum required 6 or more.';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Password",
                                          hintStyle: TextStyle(
                                              color: Colors.grey[400])),
                                    ),
                                  )
                                ],
                              ),
                            )),
                        SizedBox(
                          height: 30,
                        ),
                        FlatButton(
                          onPressed: () {
                            if (fromKey.currentState.validate()) {
                              singIN(emailcontroller.text,
                                  passwordcontroller.text);
                            } else {
                              print('no');
                            }
                          },
                          child: FadeAnimation(
                              2,
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(colors: [
                                      Color.fromRGBO(143, 148, 251, 1),
                                      Color.fromRGBO(143, 148, 251, .6),
                                    ])),
                                child: Center(
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )),
                        ),
                        // SizedBox(
                        //   height: 70,
                        // ),
                        // FadeAnimation(
                        //     1.5,
                        //     Text(
                        //       "Forgot Password?",
                        //       style: TextStyle(
                        //           color: Color.fromRGBO(143, 148, 251, 1)),
                        //     )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
