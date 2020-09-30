import 'package:flutter/material.dart';
import 'package:xtech/components/offline.dart';
import 'package:xtech/components/task.dart';
import 'package:xtech/constants/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List<Map> task = new List();
  ScrollController _scrollController = new ScrollController();
  var tid = '';
  var isLoading = true;
  var isAcitve = true;
  var isFinished = true;
  var isNoStarted = true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _filterChoses();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetch();
      }
    });
  }

  _filterChoses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isAcitve = (prefs.getBool('isAcitve') ?? true);
      isFinished = (prefs.getBool('isFinished') ?? true);
      isNoStarted = (prefs.getBool('isNoStarted') ?? true);
      fetch();
    });
  }

  var jsonData;
  fetch() async {
    Map data = {
      'token': '56sdf6s56dfs66sdfvSGDF66sdfsy',
      'action': 'tasks',
      'uid': '14',
      'total': '20',
      'before': tid,
      'not_started': isNoStarted ? "1" : "0",
      'active': isAcitve ? "1" : "0",
      'finished': isFinished ? "1" : "0",
    };
    var response = await http.post(
      globalUrl,
      body: data,
    );

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      for (var i = 0; i < jsonData.length; i++) {
        setState(
          () {
            task.add({
              'title': jsonData[i]['title'],
              'parents': jsonData[i]['parents'],
              'status': jsonData[i]['status'],
              'description': jsonData[i]['description'],
              'tid': jsonData[i]['tid'],
            });
            tid = jsonData[i]['tid'].toString();
            isLoading = false;
          },
        );
      }
    } else {
      throw Exception('hata');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TASK TRACKING'),
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
      floatingActionButton: buildFloatingActionButton(),
      body: Offline(
        body: !isLoading
            ? body
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => _showDialog(),
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle, // circular shape
          gradient: LinearGradient(
            colors: [
              mainColor,
              secondColor,
            ],
          ),
        ),
        child: Icon(
          Icons.filter_list,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget get body => ListView.builder(
        itemCount: task.length,
        itemBuilder: (context, index) {
          return TaskWidget(
            onTap: (status) {
              setState(() {
                task[index]['status'] = status;
              });
            },
            subtitle: task[index]['parents'],
            title: task[index]['title'],
            index: index,
            status: task[index]['status'],
            tid: task[index]['tid'],
            description: task[index]['description'],
          );
        },
      );

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
                value: isNoStarted,
                activeColor: Colors.green,
                title: Text(
                  "Not Started",
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    isNoStarted = val;
                  });
                },
              ),
              CheckboxListTile(
                value: isAcitve,
                activeColor: Colors.orange,
                title: Text(
                  "Active",
                  style: TextStyle(
                    color: Colors.orange,
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    isAcitve = val;
                  });
                },
              ),
              CheckboxListTile(
                value: isFinished,
                activeColor: Colors.red,
                title: Text(
                  "Finished",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    isFinished = val;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton(
                    child: Row(
                      children: [
                        Icon(Icons.check),
                        Text('Filter'),
                      ],
                    ),
                    onPressed: () {
                      setState(() async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool('isNoStarted', isNoStarted);
                        prefs.setBool('isAcitve', isAcitve);
                        prefs.setBool('isFinished', isFinished);
                        tid = '';
                        task.clear();
                        fetch();
                        Navigator.pop(context);
                      });
                    },
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  secilenler(veri) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(veri);
  }
}
