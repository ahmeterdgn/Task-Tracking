import 'package:flutter/material.dart';
import 'package:xtech/components/task.dart';
import 'package:xtech/constants/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List<Map> task = new List();
  ScrollController _scrollController = new ScrollController();
  var tid = '';
  var isLoading = true;
  var isAcitve = "1";
  var isFinished = "1";
  var isNoStarted = "1";

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
      isAcitve = (prefs.getString('isAcitve') ?? "1");
      isFinished = (prefs.getString('isFinished') ?? "1");
      isNoStarted = (prefs.getString('isNoStarted') ?? "1");
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
      'not_started': isNoStarted,
      'active': isAcitve,
      'finished': isFinished,
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
      body: !isLoading
          ? body
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  secilenler(veri) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(veri);
  }

  Widget get body => ListView.builder(
        itemCount: task.length,
        itemBuilder: (context, index) {
          return TaskWidget(
            onTap: () {
              setState(() {
                print('a');
              });
            },
            subtitle: task[index]['parents'],
            title: task[index]['title'],
            index: index,
            status: task[index]['status'],
          );
        },
      );
}
