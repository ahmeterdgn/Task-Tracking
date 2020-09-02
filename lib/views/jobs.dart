import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:commons/commons.dart';
import 'package:xtech/widget/listtext.dart';

class JobsPage extends StatefulWidget {
  @override
  _JobsPageState createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  List<Map> jobs = new List();
  ScrollController _scrollController = new ScrollController();
  var tid = '';
  var isLoading = true;
  bool isAcitve = true;
  bool isFinished = true;
  bool isNoStarted = true;

  secilenler(veri) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.getBool(veri);
  }

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
        isLoading = true;
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
    var response = await http.get(
        'http://xtech-ks.info/mapi?token=56sdf6s56dfs66sdfvSGDF66sdfsy&action=tasks&uid=14&total=7&before=$tid&not_started=${isNoStarted == true ? 1 : 0}&active=${isAcitve == true ? 1 : 0}&finished=${isFinished == true ? 1 : 0}');

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      for (var i = 0; i < jsonData.length; i++) {
        setState(() {
          jobs.add({
            'title': jsonData[i]['title'],
            'parents': jsonData[i]['parents'],
            'status': jsonData[i]['status'],
            'description': jsonData[i]['description'],
            'tid': jsonData[i]['tid'],
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
      body: !isLoading
          ? ListView.builder(
              controller: _scrollController,
              itemCount: jobs.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: jobs[index] != null
                      ? Card(
                          color: (jobs[index]['status'] == "active" ||
                                  jobs[index]['status'] == "paused")
                              ? Colors.white70
                              : jobs[index]['status'] == "finished"
                                  ? Colors.green[600]
                                  : Colors.grey[800],
                          child: FlatButton(
                            onPressed: () {
                              _detaylibilgiler(
                                baslik: jobs[index]['title'],
                                icerik: jobs[index]['description'],
                              );
                            },
                            child: ListTile(
                                title: ListText(
                                  parents: jobs[index]['title'],
                                  status: jobs[index]['status'],
                                  fontSize: 20,
                                ),
                                subtitle: ListText(
                                  parents: jobs[index]['parents'],
                                  status: jobs[index]['status'],
                                ),
                                trailing: jobs[index]['status'] != "finished"
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                            jobs[index]['status'] == "active"
                                                ? Row(
                                                    children: [
                                                      iconButtons(
                                                        color: Colors.orange,
                                                        icons: Icons.pause,
                                                        index: index,
                                                        onPressed: () {
                                                          changeStatus(
                                                            tids: jobs[index]
                                                                    ['tid']
                                                                .toString(),
                                                            opr: 'pause',
                                                          );
                                                        },
                                                      ),
                                                      iconButtons(
                                                        color: Colors.red,
                                                        icons: Icons.stop,
                                                        index: index,
                                                        onPressed: () {
                                                          sonlandir(
                                                            context,
                                                            index,
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  )
                                                : jobs[index]['status'] ==
                                                        "paused"
                                                    ? Row(
                                                        children: [
                                                          iconButtons(
                                                            color: Colors.green,
                                                            icons: Icons
                                                                .play_arrow,
                                                            index: index,
                                                            onPressed: () {
                                                              changeStatus(
                                                                tids: jobs[index]
                                                                        ['tid']
                                                                    .toString(),
                                                                opr: 'start',
                                                              );
                                                            },
                                                          ),
                                                          iconButtons(
                                                            color: Colors.red,
                                                            icons: Icons.stop,
                                                            index: index,
                                                            onPressed: () {
                                                              sonlandir(
                                                                context,
                                                                index,
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      )
                                                    : IconButton(
                                                        onPressed: () {
                                                          changeStatus(
                                                            tids: jobs[index]
                                                                    ['tid']
                                                                .toString(),
                                                            opr: 'start',
                                                          );
                                                        },
                                                        icon: Icon(
                                                          Icons.play_arrow,
                                                          color: Colors.green,
                                                        ),
                                                        iconSize: 40,
                                                      ),
                                          ])
                                    : Text('')),
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
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

  sonlandir(BuildContext context, int index) {
    confirmationDialog(
      context,
      '',
      confirm: false,
      title: 'Are you sure',
      positiveText: "Okey",
      positiveAction: () {
        changeStatus(
          tids: jobs[index]['tid'].toString(),
          opr: 'end',
        );
      },
    );
  }

  IconButton iconButtons({int index, onPressed, icons, color}) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icons,
        color: color,
      ),
      iconSize: 40,
    );
  }

  changeStatus({String tids, String opr}) async {
    Map data = {
      'tid': tids,
      'opr': opr,
      'token': '56sdf6s56dfs66sdfvSGDF66sdfsy',
      'action': 'task_update'
    };
    var jsonData;
    var response = await http.post('http://xtech-ks.info/mapi', body: data);
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      if (jsonData['result'] == "success") {
        setState(() {
          isLoading = true;
          tid = '';
          jobs.clear();
          fetch();
        });
      } else {}
    } else {}
  }

  _detaylibilgiler({baslik, icerik}) {
    slideDialog.showSlideDialog(
      barrierColor: Colors.white.withOpacity(0.7),
      context: context,
      pillColor: Colors.red,
      child: Expanded(
        flex: 1,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Text(
                baslik,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: Html(
                  data: "<section>$icerik</section>",
                  style: {
                    "section": Style(padding: EdgeInsets.all(15)),
                  },
                ),
              ),
            ],
          ),
        ),
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
                        jobs.clear();
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
}
