// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RuleWidget extends StatefulWidget {
  RuleWidget(
      {Key? key,
      required String name,
      required bool state,
      required Future<bool> Function(bool state) stateCallback,
      required Future<bool> Function() runCallback})
      : super(key: key) {
    _name = name;
    _state = state;
    _runCallback = runCallback;
    _stateCallback = stateCallback;
  }
  late bool _state;
  late String _name;
  late Future<bool> Function(bool state) _stateCallback;
  late Future<bool> Function() _runCallback;

  @override
  SwitchWidgetClass createState() => SwitchWidgetClass();
}

class SwitchWidgetClass extends State<RuleWidget> {
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
    Color runRuleColor;
    if (Theme.of(context).brightness == Brightness.dark) {
      runRuleColor = Colors.white;
    } else {
      runRuleColor = Theme.of(context).primaryColor.withAlpha(200);
    }
    return Card(
      child: Column(children: [
        Card(
            child: ListTile(
                title: Text(
              widget._name,
              style: const TextStyle(color: Colors.white),
            )),
            color: Theme.of(context).primaryColor.withAlpha(150)),
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
              Text(
                loc.runRule,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
              ),
              runningRule
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          height: 24,
                          width: 24,
                          child:
                              CircularProgressIndicator(color: runRuleColor)),
                    )
                  : IconButton(
                      onPressed: execute,
                      icon: Icon(
                        Icons.play_circle,
                        color: runRuleColor,
                        size: 24,
                      ),
                    )
            ],
          ),
        ),
      ]),
    );
  }
}
