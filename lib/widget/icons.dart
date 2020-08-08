import 'package:flutter/material.dart';

class IconCreate extends StatefulWidget {
  final color;
  final icon;
  final onpress;

  IconCreate({this.color, this.icon, this.onpress});

  @override
  _IconCreateState createState() => _IconCreateState();
}

class _IconCreateState extends State<IconCreate> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: widget.onpress,
      child: Icon(
        widget.icon,
        color: widget.color,
      ),
    );
  }
}
