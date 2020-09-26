import 'package:flutter/material.dart';

class BacgorundComponents extends StatelessWidget {
  final Widget child;

  const BacgorundComponents({Key key, @required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size gives us the overall height and width of your screen

    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomRight: const Radius.circular(100),
                bottomLeft: const Radius.circular(5),
              ),
              child: Image.asset(
                'assets/images/login_top.jpg',
                width: size.width * 1,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: const Radius.circular(100),
              ),
              child: Image.asset(
                'assets/images/login_top.jpg',
                width: size.width * 0.3,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(100),
              ),
              child: Image.asset(
                'assets/images/login_top.jpg',
                width: size.width * 0.3,
                fit: BoxFit.cover,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
