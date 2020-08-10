import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
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
    );
  }
}
