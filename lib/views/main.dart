import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  void initState() {
    super.initState();
    configOneSignal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('WELCOME'),
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
          ],
        ));
  }
}

void configOneSignal() {
  OneSignal.shared.init('f2a81911-f70c-404d-be49-8631e6e53378');
}
