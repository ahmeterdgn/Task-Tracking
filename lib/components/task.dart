import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TaskWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final Function onTap;
  final index;
  final status;
  const TaskWidget(
      {Key key, this.title, this.subtitle, this.onTap, this.index, this.status})
      : super(key: key);

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
  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: TaskWidget._getActionPane(widget.index),
      secondaryActions: widget.status == "active"
          ? [
              IconSlideAction(
                caption: 'Stop',
                color: Colors.red,
                icon: Icons.stop,
                onTap: () => _showSnackBar(context, 'Delete'),
              ),
              IconSlideAction(
                caption: 'Pause',
                color: Colors.orange,
                icon: Icons.pause,
                onTap: () => _showSnackBar(context, 'Archive'),
              ),
            ]
          : [
              IconSlideAction(
                caption: 'Start',
                color: Colors.green,
                icon: Icons.play_arrow,
                onTap: () => _showSnackBar(context, 'Archive'),
              ),
            ],
      child: Card(
        shape: Border(
          right: BorderSide(color: Colors.red, width: 3),
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
    );
  }

  void _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
