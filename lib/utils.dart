import 'package:flutter/material.dart';

class Utils {
  static const String runRuleUrl =
      'https://home.myopenhab.org/rest/rules/{uuid}/runnow';

  static const String enableRuleUrl =
      'https://home.myopenhab.org/rest/rules/{uuid}/enable';

  static const String enableThingUrl =
      'https://home.myopenhab.org/rest/things/{uuid}/enable';

  static const String itemsUrl = 'https://home.myopenhab.org/rest/items';

  static const String systeminfoUrl =
      'https://home.myopenhab.org/rest/systeminfo';

  static const String rulesUrl =
      'https://home.myopenhab.org/rest/rules?summary=true';

  static const String thingsUrl =
      'https://home.myopenhab.org/rest/things?summary=true';

  static const String onN = "ON";
  static const String off = "OFF";

  static makeToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      content: Text(message),
      backgroundColor: Theme.of(context).primaryColor,
    ));
  }
}
