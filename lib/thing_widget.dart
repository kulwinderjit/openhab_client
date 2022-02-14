// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThingWidget extends StatefulWidget {
  ThingWidget(
      {Key? key,
      required String name,
      required bool state,
      required Future<bool> Function(bool state) stateCallback})
      : super(key: key) {
    _name = name;
    _state = state;
    _stateCallback = stateCallback;
  }
  late bool _state;
  late String _name;
  late Future<bool> Function(bool state) _stateCallback;

  @override
  ThingWidgetState createState() => ThingWidgetState();
}

class ThingWidgetState extends State<ThingWidget> {
  void toggleState(bool value) {
    if (widget._state == false) {
      setState(() {
        widget._state = true;
      });
    } else {
      setState(() {
        widget._state = false;
      });
    }
    Future<bool> call = widget._stateCallback.call(widget._state);
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
    AppLocalizations? loc = AppLocalizations.of(context);
    return Card(
      child: Column(children: [
        Card(
            child: ListTile(
                title: Text(
              widget._name,
              style: const TextStyle(color: Colors.white),
            )),
            color: Theme.of(context).primaryColor),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget._state ? loc!.enabled : loc!.disabled,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
              ),
              Switch(
                onChanged: toggleState,
                value: widget._state,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
