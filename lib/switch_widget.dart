// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class SwitchWidget extends StatefulWidget {
  SwitchWidget(
      {Key? key,
      required String name,
      required bool state,
      required Future<bool> Function(bool state) callback})
      : super(key: key) {
    _name = name;
    _state = state;
    _callback = callback;
  }
  late bool _state;
  late String _name;
  late Future<bool> Function(bool state) _callback;

  @override
  SwitchWidgetClass createState() => SwitchWidgetClass();
}

class SwitchWidgetClass extends State<SwitchWidget> {
  void toggleSwitch(bool value) {
    if (widget._state == false) {
      setState(() {
        widget._state = true;
      });
    } else {
      setState(() {
        widget._state = false;
      });
    }
    Future<bool> call = widget._callback.call(widget._state);
    call.then((value) => {
          if (value != widget._state)
            {
              setState(() {
                widget._state = value;
              })
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Transform.rotate(
          angle: 1.57,
          child: Switch(
            onChanged: toggleSwitch,
            value: widget._state,
          )),
      Text(
        widget._name,
      )
    ]);
  }
}
