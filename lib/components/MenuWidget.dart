import 'package:flutter/material.dart';

import './../screens/LogScreen/LogScreen.dart';

class MenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new PopupMenuButton<FlatButton>(
        // onSelected: _select,
        itemBuilder: (BuildContext context) {
          return [
            new PopupMenuItem<FlatButton>(
              // value: 'yo',
              child: new FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) => new LogScreen()),
                  );
                },
                child: new Text('Log'),
              ),
            ),
          ];
        },
      );
  }
}
