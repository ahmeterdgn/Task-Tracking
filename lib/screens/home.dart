import 'package:flutter/material.dart';
import 'package:xtech/components/homeCard.dart';
import 'package:xtech/constants/global.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('XTech'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                secondColor,
                mainColor,
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          children: [
            HomeComponent(
              size: size,
              image: 'assets/images/notifications.png',
              text: 'NOTIFICATION',
              sizex: 0.25,
              color: Colors.green,
              onPressed: () {
                Navigator.pushNamed(context, '/notification');
              },
            ),
            HomeComponent(
              size: size,
              image: 'assets/images/task.png',
              text: 'TASK TRACKING',
              sizex: 0.45,
              color: Colors.blueAccent,
              onPressed: () {
                Navigator.pushNamed(context, '/task');
              },
            ),
          ],
        ),
      ),
    );
  }
}
