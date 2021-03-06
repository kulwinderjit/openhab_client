import 'package:flutter/material.dart';

class Utils {
  static const String runRuleUrl =
      'https://home.myopenhab.org/rest/rules/{uuid}/runnow';

  static const String enableRuleUrl =
      'https://home.myopenhab.org/rest/rules/{uuid}/enable';

  static const String enableThingUrl =
      'https://home.myopenhab.org/rest/things/{uuid}/enable';

  static const String itemsUrl =
      'https://home.myopenhab.org/rest/items?fields=label%2Cstate%2Clink%2Cname%2Ctype%2CgroupNames';

  static const String systeminfoUrl =
      'https://home.myopenhab.org/rest/systeminfo';

  static const String rulesUrl =
      'https://home.myopenhab.org/rest/rules?summary=true';

  static const String thingsUrl =
      'https://home.myopenhab.org/rest/things?summary=true';

  static const String onN = "ON";
  static const String off = "OFF";
  static const String themeMode = "themeMode";
  static const String colorScheme = "colorScheme";

  static const String username = "username";
  static const String password = "password";
  static const String apitoken = "apitoken";

  static const String displayName = "displayName";
  static const String switches = "switches";
  static const String rules = "rules";
  static const String things = "things";
  static const String isDemo = "isDemo";

  static makeToast(BuildContext context, String message) {
    Color backColor;
    if (Theme.of(context).brightness == Brightness.dark) {
      backColor = Colors.white70;
    } else {
      backColor = Theme.of(context).primaryColor;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: backColor,
    ));
  }
}
