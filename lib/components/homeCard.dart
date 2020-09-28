import 'package:flutter/material.dart';

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
      padding: EdgeInsets.all(4),
      child: FlatButton(
        color: color,
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
