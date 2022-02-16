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
    ThemeData theme = Theme.of(context);
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
      child: Column(children: [
        Card(
          elevation: 4,
          child: ListTile(
              leading: Icon(
                Icons.emoji_objects,
                color: theme.iconTheme.color,
              ),
              horizontalTitleGap: 0,
              title: Text(
                widget._name,
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 8, top: 8, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget._state ? loc!.enabled : loc!.disabled,
                style: theme.textTheme.bodyText2,
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
