import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ListText extends StatelessWidget {
  String parents;
  String status;
  double fontSize;

  ListText({this.parents, this.status, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      parents,
      style: TextStyle(
        color: (status == "active" || status == "paused")
            ? Colors.black
            : status == "finished" ? Colors.white : Colors.white,
        fontSize: fontSize,
      ),
    );
  }
}
