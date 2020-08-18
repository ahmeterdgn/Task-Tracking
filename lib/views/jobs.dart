import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

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
        'http://xtech-ks.info/mapi?token=56sdf6s56dfs66sdfvSGDF66sdfsy&action=tasks&uid=14&total=20&before=$tid&not_started=${isNoStarted == true ? 1 : 0}&active=${isAcitve == true ? 1 : 0}&finished=${isFinished == true ? 1 : 0}');

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);

      for (var i = 0; i < jsonData.length; i++) {
        setState(() {
          jobs.add({
            'title': jsonData[i]['title'],
            'parents': jsonData[i]['parents'],
            'status': jsonData[i]['status'],
            'description': jsonData[i]['description'],
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
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              controller: _scrollController,
              itemCount: jobs.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: jobs[index] != null
                      ? Card(
                          color: jobs[index]['status'] == "active"
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
                                title: Text(
                                  jobs[index]['title'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: jobs[index]['status'] == "active"
                                        ? Colors.black
                                        : jobs[index]['status'] == "finished"
                                            ? Colors.white
                                            : Colors.white,
                                  ),
                                ),
                                subtitle: Text(
                                  jobs[index]['parents'],
                                  style: TextStyle(
                                    color: jobs[index]['status'] == "active"
                                        ? Colors.black
                                        : jobs[index]['status'] == "finished"
                                            ? Colors.white
                                            : Colors.white,
                                  ),
                                ),
                                trailing: jobs[index]['status'] != "finished"
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                            jobs[index]['status'] == "active"
                                                ? Row(
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {},
                                                        icon: Icon(
                                                          Icons.pause,
                                                          color: Colors.orange,
                                                        ),
                                                        iconSize: 40,
                                                      ),
                                                      IconButton(
                                                        onPressed: () {},
                                                        icon: Icon(
                                                          Icons.stop,
                                                          color: Colors.red,
                                                        ),
                                                        iconSize: 40,
                                                      )
                                                    ],
                                                  )
                                                : IconButton(
                                                    onPressed: () {},
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

                    fetch();
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
                    fetch();
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
                    fetch();
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
        },
      ),
    );
  }
}
