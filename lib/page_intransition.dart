import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class PageInTransition extends StatefulWidget {
  Widget body;
  PageInTransition({Key? key, required this.body}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PageInTransitionState();
}

class PageInTransitionState extends State<PageInTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  _toggleAnimation() {
    _animationController.isDismissed
        ? _animationController.forward()
        : _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    Animation<double> animation =
        Tween(begin: 0.0, end: 1.0).animate(_animationController);
    return FadeTransition(child: widget.body, opacity: animation);
  }
}
