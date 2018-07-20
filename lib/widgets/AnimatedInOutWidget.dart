import 'package:flutter/material.dart';

class AnimatedInOutWidget extends StatefulWidget {
  AnimatedInOutWidget({ Key key }) : super(key: key);

  @override
  AnimatedInOutWidgetState createState() =>
      new AnimatedInOutWidgetState();
}

class AnimatedInOutWidgetState extends State<AnimatedInOutWidget> with TickerProviderStateMixin {
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
    return AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget child) {
          return child;
        });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

}
