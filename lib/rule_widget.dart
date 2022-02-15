// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RuleWidget extends StatefulWidget {
  RuleWidget(
      {Key? key,
      required String name,
      required bool state,
      String? description,
      required Future<bool> Function(bool state) stateCallback,
      required Future<bool> Function() runCallback})
      : super(key: key) {
    _name = name;
    _state = state;
    _runCallback = runCallback;
    _stateCallback = stateCallback;
    _description = description;
  }
  late bool _state;
  late String _name;
  late String? _description;
  late Future<bool> Function(bool state) _stateCallback;
  late Future<bool> Function() _runCallback;

  @override
  RuleWidgetState createState() => RuleWidgetState();
}

class RuleWidgetState extends State<RuleWidget> {
  bool runningRule = false;
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

  void execute() {
    setState(() {
      runningRule = true;
    });
    Future<bool> call = widget._runCallback.call();
    call.whenComplete(() => setState(() {
          runningRule = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? loc = AppLocalizations.of(context);
    ThemeData theme = Theme.of(context);
    Row buttonRow = Row(
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
        Text(
          loc.runRule,
          style: theme.textTheme.bodyText2,
        ),
        runningRule
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    height: 24, width: 24, child: CircularProgressIndicator()),
              )
            : IconButton(
                onPressed: execute,
                icon: Icon(
                  Icons.play_circle,
                  size: 24,
                ),
              ),
      ],
    );
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
      child: Column(children: [
        Card(
          elevation: 4,
          child: ListTile(
            leading: Icon(
              Icons.rule,
              color: theme.iconTheme.color,
            ),
            horizontalTitleGap: 0,
            title: Text(
              widget._name,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 8, top: 8, bottom: 8),
          child: widget._description != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget._description!),
                    buttonRow,
                  ],
                )
              : buttonRow,
        ),
      ]),
    );
  }
}
