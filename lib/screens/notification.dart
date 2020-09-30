import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;
import 'package:xtech/components/offline.dart';
import 'package:xtech/constants/global.dart';
import 'package:flutter_offline/flutter_offline.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  ScrollController _scrollController = new ScrollController();
  var jsonData;
  var notifi = [];
  var nid = '';
  var isLoading = true;

  fetch() async {
    Map data = {
      'token': '56sdf6s56dfs66sdfvSGDF66sdfsy',
      'action': 'notifications',
      'uid': '14',
      'total': '20',
      'before': nid,
    };
    var response = await http.post(
      globalUrl,
      body: data,
    );
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      for (var i = 0; i < jsonData.length; i++) {
        setState(() {
          notifi.add({
            'title': jsonData[i]['title'],
            'date': jsonData[i]['date'],
            'message': jsonData[i]['message']
          });
          nid = jsonData[i]['nid'];
          isLoading = false;
        });
      }
    } else {
      throw Exception('hata');
    }
  }

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

  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('NOTIFICATION'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  secondColor,
                  mainColor,
                ],
              ),
            ),
          ),
        ),
        body: Offline(
          body: notifi != null
              ? ListView.builder(
                  controller: _scrollController,
                  itemCount: notifi.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: notifi[index] != null
                          ? Card(
                              shape: Border(
                                right: BorderSide(color: mainColor, width: 2),
                                left: BorderSide(color: secondColor, width: 2),
                              ),
                              child: FlatButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  _showDialog(
                                    title: notifi[index]['title'],
                                    message: notifi[index]['message'],
                                  );
                                },
                                child: ListTile(
                                  isThreeLine: true,
                                  leading: Image.asset(
                                      'assets/images/notifications.png'),
                                  title: Text(notifi[index]['title']),
                                  subtitle: Text(notifi[index]['date']),
                                  trailing: IconButton(
                                    icon: Icon(Icons.remove_red_eye),
                                    onPressed: () {
                                      _showDialog(
                                        title: notifi[index]['title'],
                                        message: notifi[index]['message'],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            )
                          : Center(child: CircularProgressIndicator()),
                    );
                  },
                )
              : Center(child: CircularProgressIndicator()),
        ));
  }

  _showDialog({message, title}) {
    slideDialog.showSlideDialog(
      context: context,
      pillColor: Colors.red,
      barrierColor: Colors.white.withOpacity(0.7),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(message),
        ],
      ),
    );
  }
}
