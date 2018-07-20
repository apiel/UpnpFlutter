import 'package:flutter/material.dart';

import '../models/Device.dart';

class DeviceWidget extends StatefulWidget {
  final Device device;

  DeviceWidget(this.device, { Key key }) : super(key: key);

  @override
  DeviceWidgetState createState() =>
      new DeviceWidgetState(this.device, ['TOGGLE', 'ON', 'OFF']);
}

class DeviceWidgetState extends State<DeviceWidget> {
  final Device device;
  List<String> values;
  int currentValue = 0;

  DeviceWidgetState(this.device, this.values);

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new GestureDetector(
        onTap: () { print('tap tap'); },
        onHorizontalDragEnd: (drag) {
          setState(() {
            int direction = drag.velocity.pixelsPerSecond.dx > 0 ? 1 : -1;
            this.currentValue = (this.currentValue + direction) % this.values.length;
          });
        },
        child: new Container(
          color: Colors.black12, // without this it doesnt get fullsize
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Text(this.device.name),
              new Icon(Icons.wb_incandescent),
              new Text(this.values[this.currentValue]),
            ],
          ),
        ),
      ),
    );
  }
}
