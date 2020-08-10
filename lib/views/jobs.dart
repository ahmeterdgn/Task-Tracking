import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xtech/views/login.dart';

class JopsPage extends StatefulWidget {
  @override
  _JopsPageState createState() => _JopsPageState();
}

class _JopsPageState extends State<JopsPage> {
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
              title: Text('My jobs'),
            ),
            body: ListView(
              children: <Widget>[
                Card(
                  child: ListTile(
                    title: Text('Two-line ListTile'),
                    subtitle: Text('Here is a second line'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.pause,
                          color: Colors.orange,
                        ),
                        Icon(
                          Icons.stop,
                          color: Colors.red,
                        )
                      ],
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text('Two-line ListTile'),
                    subtitle: Text('Here is a second line'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.play_arrow,
                          color: Colors.green,
                        ),
                        Icon(
                          Icons.stop,
                          color: Colors.red,
                        )
                      ],
                    ),
                  ),
                ),
                FlatButton(onPressed: () => {}, child: null)
              ],
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            body: Container(),
          );
  }
}
