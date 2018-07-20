import 'package:flutter/material.dart';

import './../screens/LogScreen.dart';

class BarWidget extends AppBar {
  BarWidget({ Key key, Widget title, BuildContext context }) : super(
        key: key,
        title: title,
        actions: <Widget>[
          // action button
          new IconButton(
            icon: new Icon(Icons.visibility),
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => new LogScreen()),
              );
            },
          ),
        ],
      );
}
