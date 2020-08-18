import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<Map> jobs = new List();
  ScrollController _scrollController = new ScrollController();
  var tid = '';
  var isLoading = true;
  bool isAcitve = true;
  bool isFinished = true;
  bool isNoStarted = true;

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
        'http://xtech-ks.info/mapi?token=56sdf6s56dfs66sdfvSGDF66sdfsy&action=tasks&uid=14&total=7&before=$tid&not_started=${isNoStarted == true ? 1 : 0}&active=${isAcitve == true ? 1 : 0}&finished=${isFinished == true ? 1 : 0}');

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);

      for (var i = 0; i < jsonData.length; i++) {
        setState(() {
          jobs.add({
            'title': jsonData[i]['title'],
            'parents': jsonData[i]['parents'],
            'status': jsonData[i]['status']
          });
          tid = jsonData[i]['tid'].toString();
          isLoading = false;
        });
      }
      print(tid);
    } else {
      throw Exception('hata');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('data')),
      body: isLoading
          ? Text('asdasd')
          : ListView.builder(
              controller: _scrollController,
              itemCount: jobs.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: jobs[index] != null
                      ? Card(
                          child: ListTile(
                              title: Text(jobs[index]['title']),
                              subtitle: Text(jobs[index]['parents']),
                              trailing: jobs[index]['status'] != "finished"
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                          jobs[index]['status'] == "active"
                                              ? Row(
                                                  children: [
                                                    Icon(
                                                      Icons.pause,
                                                      color: Colors.orange,
                                                    ),
                                                    Icon(
                                                      Icons.stop,
                                                      color: Colors.red,
                                                    )
                                                  ],
                                                )
                                              : Icon(
                                                  Icons.play_arrow,
                                                  color: Colors.green,
                                                )
                                        ])
                                  : Text('')),
                        )
                      : Text('asdasd'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog();
        },
        child: Icon(Icons.filter_list),
        backgroundColor: Colors.green,
      ),
    );
  }

  _showDialog() {
    slideDialog.showSlideDialog(
        barrierColor: Colors.white.withOpacity(0.7),
        context: context,
        pillColor: Colors.red,
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Column(
            children: [
              CheckboxListTile(
                value: isAcitve,
                title: Text("Active"),
                onChanged: (val) {
                  setState(() {
                    isAcitve = val;
                    fetch();
                  });
                },
              ),
              CheckboxListTile(
                value: isFinished,
                title: Text("Finished"),
                onChanged: (val) {
                  setState(() {
                    isFinished = val;
                    fetch();
                  });
                },
              ),
              CheckboxListTile(
                value: isNoStarted,
                title: Text("Not Started"),
                onChanged: (val) {
                  setState(() {
                    isNoStarted = val;

                    fetch();
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton(
                    child: Icon(Icons.check),
                    onPressed: () {
                      setState(() {
                        jobs.clear();
                        tid = '';
                        fetch();

                        Navigator.pop(context);
                      });
                    },
                  ),
                ],
              )
            ],
          );
        }));
  }
}
