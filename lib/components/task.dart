import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:xtech/components/alert.dart';
import 'package:xtech/constants/global.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

class TaskWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final Function onTap;
  final index;
  final String status;
  final tid;
  final String description;
  const TaskWidget({
    Key key,
    this.title,
    this.subtitle,
    this.onTap,
    this.index,
    this.status,
    this.tid,
    this.description,
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
            secondaryActions: widget.status == "paused"
                ? paused(context)
                : widget.status == "active"
                    ? active(context)
                    : widget.status == "not_started"
                        ? not_started(context)
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
                onPressed: () {
                  _detaylibilgiler(
                      title: widget.title, content: widget.description);
                },
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
        : Padding(
            padding: const EdgeInsets.all(3.0),
            child: Card(
              elevation: 4,
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(10),
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),
                ),
              )),
            ),
          );
  }

  List<Widget> active(BuildContext context) {
    return [
      IconSlideAction(
        caption: 'Pause',
        color: Colors.orange,
        icon: Icons.pause,
        onTap: () => _showSnackBar(
          context,
          'Pause',
          'pause',
          widget.tid.toString(),
          'paused',
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
          'finished',
        ),
      ),
    ];
  }

  // ignore: non_constant_identifier_names
  List<Widget> not_started(BuildContext context) {
    return [
      IconSlideAction(
        caption: 'Start',
        color: Colors.green,
        icon: Icons.play_arrow,
        onTap: () => _showSnackBar(
          context,
          'Start',
          'start',
          widget.tid.toString(),
          'active',
        ),
      ),
    ];
  }

  List<Widget> paused(BuildContext context) {
    return [
      IconSlideAction(
        caption: 'Start',
        color: Colors.green,
        icon: Icons.play_arrow,
        onTap: () => _showSnackBar(
          context,
          'Start',
          'start',
          widget.tid.toString(),
          'active',
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
          'finished',
        ),
      ),
    ];
  }

  changeStatus({String tids, String opr, String statuschange}) async {
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
          widget.onTap(statuschange);
        });
      } else if (jsonData['result'] == "error") {
        setState(() {
          isLoading = true;
          showAlertDialog(context, title: 'Error!', text: jsonData['message']);
        });
      }
    } else {
      setState(() {
        isLoading = true;
        showAlertDialog(context, title: 'Error!', text: 'An error occurred');
      });
    }
  }

  void _showSnackBar(BuildContext context, String text, String opr, String tid,
      String statuschange) {
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
        statuschange: statuschange,
      );
    });
  }

  _detaylibilgiler({title, content}) {
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
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: Html(
                  data: "<section>$content</section>",
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
}
