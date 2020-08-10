import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map> notifi = new List();
  ScrollController _scrollController = new ScrollController();
  var nid = '';
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetch();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetch();
      }
    });
  }

  var jsonData;
  fetch() async {
    var response = await http.get(
        'http://xtech-ks.info/mapi?token=56sdf6s56dfs66sdfvSGDF66sdfsy&action=notifications&uid=14&total=20&before=$nid');

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);

      for (var i = 0; i < jsonData.length; i++) {
        setState(() {
          notifi.add(
              {'title': jsonData[i]['title'], 'date': jsonData[i]['date']});
          nid = jsonData[i]['nid'];
        });
      }
      print(nid);
    } else {
      throw Exception('hata');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: notifi.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: notifi[index] != null
                ? Card(
                    child: ListTile(
                      leading: Image.asset('assets/images/notification.png'),
                      title: Text(notifi[index]['title']),
                      subtitle: Text(notifi[index]['date']),
                      trailing: Icon(Icons.remove_red_eye),
                    ),
                  )
                : Text('asdasd'),
          );
        },
      ),
    );
  }
}
