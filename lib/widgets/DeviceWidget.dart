import 'package:flutter/material.dart';

import '../models/Device.dart';

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
  final Device device;
  List<String> values;
  int currentValue = 0;

  DeviceWidgetState(this.device, this.values);

  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    final Animation curve =
        CurvedAnimation(parent: controller, curve: Curves.easeOut);
    animation = IntTween(begin: 100, end: 50).animate(curve)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && animation.value == 50) {
          controller.reverse();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    // controller.forward();
    return AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget child) {
          return new Opacity( opacity: 0.01 * animation.value, child: new Card(
            child: new GestureDetector(
              onTap: () {
                controller.forward();
              },
              onHorizontalDragEnd: (drag) {
                setState(() {
                  int direction = drag.velocity.pixelsPerSecond.dx > 0 ? 1 : -1;
                  this.currentValue = (this.currentValue + direction) % this.values.length;
                });
              },
              // we might need this behavcccccior for number %
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
                    new Text(this.values[this.currentValue]),
                  ],
                ),
              ),
            
            ),
          ));
        });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

}
