import 'package:flutter/material.dart';
import 'package:xtech/components/textFieldContainer.dart';
import 'package:xtech/constants/global.dart';

class InputRadiusComponents extends StatelessWidget {
  final String hintText;
  final controller;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final bool obscureText;

  const InputRadiusComponents({
    Key key,
    this.hintText,
    this.icon,
    this.onChanged,
    this.obscureText = false,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          icon: Icon(icon, color: secondColor),
          border: InputBorder.none,
        ),
        onChanged: onChanged,
        validator: (val) {
          if (val.isEmpty) {
            return 'Do not leave blank';
          } else if (6 > val.length) {
            return '6 characters required';
          } else {
            return null;
          }
        },
      ),
    );
  }
}
