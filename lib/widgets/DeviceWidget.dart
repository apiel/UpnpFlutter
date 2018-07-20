import 'package:flutter/material.dart';

import '../models/Device.dart';

class DeviceWidget extends StatelessWidget {
  final Device device;

  DeviceWidget(this.device);

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new GestureDetector(
        onTap: () { print('tap tap'); },
        onHorizontalDragUpdate: (yo) { print('drag'); print(yo); },
        child: new Container(
          color: Colors.black12, // without this it doesnt get fullsize
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Text(this.device.name),
              new Icon(Icons.wb_incandescent),
              new Text('ON'),
            ],
          ),
        ),
      ),


      // child: new FlatButton(
      //   child: new Column(
      //     mainAxisSize: MainAxisSize.min,
      //     children: <Widget>[
      //       new Text(this.device.name),
      //       new Icon(Icons.wb_incandescent),
      //       new Text('ON'),
      //     ],
      //   ),
      //   onPressed: () { /* ... */ },
      // ),


      // child: new FlatButton(

      //   child: new ListTile(
      //     leading: const Icon(Icons.bug_report),
      //     title: new Text(this.device.name),
      //     subtitle: new Text('on'),
      //   ),
      //   onPressed: () { /* ... */ },
      // ),

      // child: new Column(
      //   mainAxisSize: MainAxisSize.min,
      //   children: <Widget>[
      //     new ListTile(
      //       title: new Text(this.device.name),
      //     ),
      //     new FlatButton(
      //       child: const Text('ON'),
      //       onPressed: () { /* ... */ },
      //     ),
      //   ],
      // ),



      // child: new Row(
      //   children: <Widget>[
      //     new Text(this.device.name)
      //   ],
      // ),
    );
  }
}
