import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:xtech/constants/global.dart';

class TaskWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final Function onTap;
  final index;
  final status;
  final tid;
  const TaskWidget({
    Key key,
    this.title,
    this.subtitle,
    this.onTap,
    this.index,
    this.status,
    this.tid,
  }) : super(key: key);

  @override
  _TaskWidgetState createState() => _TaskWidgetState();

  static Widget _getActionPane(int index) {
    switch (index % 4) {
      case 0:
        return SlidableBehindActionPane();
      case 1:
        return SlidableStrechActionPane();
      case 2:
        return SlidableScrollActionPane();
      case 3:
        return SlidableDrawerActionPane();
      default:
        return null;
    }
  }
}

class _TaskWidgetState extends State<TaskWidget> {
  var isLoading = true;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Slidable(
            actionPane: TaskWidget._getActionPane(widget.index),
            secondaryActions: widget.status == "active"
                ? [
                    IconSlideAction(
                      caption: 'Pause',
                      color: Colors.orange,
                      icon: Icons.pause,
                      onTap: () => _showSnackBar(
                        context,
                        'Pause',
                        'pause',
                        widget.tid.toString(),
                      ),
                    ),
                    IconSlideAction(
                      caption: 'Stop',
                      color: Colors.red,
                      icon: Icons.stop,
                      onTap: () => _showSnackBar(
                        context,
                        'Stop',
                        'stop',
                        widget.tid.toString(),
                      ),
                    ),
                  ]
                : widget.status == "paused"
                    ? [
                        IconSlideAction(
                          caption: 'Start',
                          color: Colors.green,
                          icon: Icons.play_arrow,
                          onTap: () => _showSnackBar(
                            context,
                            'Start',
                            'start',
                            widget.tid.toString(),
                          ),
                        ),
                        IconSlideAction(
                          caption: 'Stop',
                          color: Colors.red,
                          icon: Icons.stop,
                          onTap: () => _showSnackBar(
                            context,
                            'Stop',
                            'stop',
                            widget.tid.toString(),
                          ),
                        ),
                      ]
                    : widget.status == "not_started"
                        ? [
                            IconSlideAction(
                              caption: 'Start',
                              color: Colors.green,
                              icon: Icons.play_arrow,
                              onTap: () => _showSnackBar(
                                context,
                                'Start',
                                'start',
                                widget.tid.toString(),
                              ),
                            ),
                          ]
                        : [],
            child: Card(
              shape: Border(
                left: BorderSide(
                  color: widget.status == "active"
                      ? Colors.blue
                      : widget.status == "paused"
                          ? Colors.orange
                          : widget.status == "not_started"
                              ? Colors.green
                              : Colors.grey,
                  width: 3,
                ),
              ),
              child: FlatButton(
                onPressed: () {},
                child: ListTile(
                  title: Text(widget.title),
                  subtitle: Text(widget.subtitle),
                  trailing: Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                  ),
                ),
              ),
            ),
          )
        : Center(child: CircularProgressIndicator());
  }

  changeStatus({String tids, String opr}) async {
    Map data = {
      'tid': tids,
      'opr': opr,
      'token': '56sdf6s56dfs66sdfvSGDF66sdfsy',
      'action': 'task_update'
    };
    var jsonData;
    var response = await http.post(
      globalUrl,
      body: data,
    );
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      if (jsonData['result'] == "success") {
        setState(() {
          isLoading = true;
        });
      } else {}
    } else {}
  }

  void _showSnackBar(
      BuildContext context, String text, String opr, String tid) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
    setState(() {
      isLoading = !isLoading;
      changeStatus(
        opr: opr,
        tids: tid,
      );
    });
  }
}
