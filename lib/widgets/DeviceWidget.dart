import 'package:flutter/material.dart';
import 'dart:async';

import '../models/Device.dart';
import './AnimatedInOutWidget.dart';
import '../services/DeviceService.dart';

class DeviceWidget extends StatefulWidget {
  final Device device;
  final List<String> values = ['TOGGLE', 'ON', 'OFF'];
  // final List<String> values = new List<String>.generate(100, (int index) => '$index');

  DeviceWidget(this.device, { Key key }) : super(key: key);

  @override
  DeviceWidgetState createState() =>
      new DeviceWidgetState(this.device, this.values);
}

class DeviceWidgetState extends State<DeviceWidget> with TickerProviderStateMixin {
  DeviceService deviceService;
  Device device;
  List<String> values;
  int currentValue = 0;
  int _pressedCount = 0;

  DeviceWidgetState(this.device, this.values) {
    deviceService = new DeviceService(this.device);
  }

  Future<Null> _onTap() async {
    setState(() { _pressedCount++; });
    this.device = await this.deviceService.send(this.values[this.currentValue]);
    setState(() {});

    return null;
  }

  @override
  Widget build(BuildContext context) {
    print(this.device.on);
    return AnimatedInOutWidget(
          update: _pressedCount,
            child: new Card(
              child: new GestureDetector(
                onTap: this._onTap,
                onHorizontalDragEnd: (drag) {
                  setState(() {
                    int direction = drag.velocity.pixelsPerSecond.dx > 0 ? 1 : -1;
                    this.currentValue = (this.currentValue + direction) % this.values.length;
                  });
                },
                // we might need this for number %
                // onHorizontalDragUpdate: (drag) {
                //   setState(() {
                //     int direction = drag.delta.dx > 0 ? 1 : -1;
                //     this.currentValue = (this.currentValue + direction) % this.values.length;
                //     print(this.currentValue);
                //     print(drag.delta.distance);
                //   });
                // },

                child: new Container(
                  color: Colors.black12, // without this it doesnt get fullsize
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      new Text(this.device.name),
                      new Icon(Icons.wb_incandescent),
                      new Text(this.device.on == true ? 'ON' : 'OFF',
                          style: new TextStyle(fontWeight: FontWeight.bold)),
                      new Text(this.values[this.currentValue],
                          style: new TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10.0)),
                    ],
                  ),
                ),

              ),
            ),
        );
  }
}
