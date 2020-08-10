import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xtech/views/login.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  all() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var logintrue = sharedPreferences.getString('login');
    print(logintrue);
    if (logintrue != 'ok') {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false);
    }
    setState(() {
      check = true;
    });
  }

  var check = false;

  void initState() {
    super.initState();
    all();
  }

  @override
  Widget build(BuildContext context) {
    return (check)
        ? Scaffold(
            appBar: AppBar(
              title: Text('XTECH'),
            ),
            body: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Card(
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Navigator.pushNamed(context, '/notification');
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset('assets/images/notification.png'),
                            Container(
                              padding: EdgeInsets.all(25),
                              alignment: Alignment.center,
                              child: Text(
                                'NOTİFİCATİON',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Navigator.pushNamed(context, '/jobs');
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset('assets/images/engineer.png'),
                            Container(
                              padding: EdgeInsets.all(25),
                              alignment: Alignment.center,
                              child: Text(
                                'MY JOBS',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ))
        : Scaffold(
            backgroundColor: Colors.white,
            body: Container(),
          );
  }
}
