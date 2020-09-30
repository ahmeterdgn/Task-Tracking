import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class Offline extends StatelessWidget {
  const Offline({
    Key key,
    this.body,
  }) : super(key: key);

  final body;
  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        if (connectivity == ConnectivityResult.none) {
          return Container(
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi_lock,
                    size: 50,
                    color: Colors.red,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Oops, \n\nNow we are Offline!",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          );
        } else {
          return child;
        }
      },
      builder: (BuildContext context) {
        return body;
      },
    );
  }
}
