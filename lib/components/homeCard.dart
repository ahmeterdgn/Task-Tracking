import 'package:flutter/material.dart';
import 'package:xtech/constants/global.dart';

class HomeComponent extends StatelessWidget {
  const HomeComponent({
    Key key,
    @required this.size,
    this.image,
    this.text,
    this.sizex,
    this.color,
    this.onPressed,
  }) : super(key: key);

  final Size size;
  final String image;
  final String text;
  final double sizex;
  final Color color;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        gradient: new LinearGradient(
          colors: color == Colors.green
              ? [Colors.greenAccent, Colors.lightGreen]
              : [mainColor, secondColor],
          begin: FractionalOffset.centerLeft,
          end: FractionalOffset.centerRight,
        ),
      ),
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.all(4),
      child: FlatButton(
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              width: size.width * sizex,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
