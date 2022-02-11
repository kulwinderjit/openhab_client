import 'package:flutter/material.dart';
import 'package:openhab_client/about_home.dart';
import 'package:openhab_client/refresh_icon.dart';
import 'package:openhab_client/rules_home.dart';
import 'package:openhab_client/sensors_home.dart';
import 'package:openhab_client/settings_home.dart';
import 'package:openhab_client/sidebar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:openhab_client/switches_home.dart';
import 'package:openhab_client/system_info.dart';
import 'package:openhab_client/things_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageWrapper extends StatefulWidget {
  const PageWrapper({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PageWrapperState();
}

class PageWrapperState extends State<PageWrapper> {
  int navIndex = 1;
  String? title;
  String? displayName;
  String? userName;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      displayName = prefs.get('displayName')?.toString();
      userName = prefs.get('username')?.toString();
      setState(() {
        if (userName == null || userName!.isEmpty) {
          navIndex = 6;
        }
      });
    });
  }

  void _settingsVerified() {
    SharedPreferences.getInstance().then((prefs) {
      displayName = prefs.get('displayName')?.toString();
      userName = prefs.get('username')?.toString();
      setState(() {
        if (userName == null || userName!.isEmpty) {
          navIndex = 6;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations loc = AppLocalizations.of(context)!;
    bool showRefresh = true;
    switch (navIndex) {
      case 1:
        title = loc.switchesSidebarTitle;
        break;
      case 2:
        title = loc.sensorsSidebarTitle;
        break;
      case 3:
        title = loc.ruleSidebarTitle;
        break;
      case 4:
        title = loc.thingsSidebarTitle;
        break;
      case 5:
        title = loc.sysInfoSidebarTitle;
        break;
      case 6:
        title = loc.settingsSideBarTitle;
        break;
      case 7:
        title = loc.aboutSideBarTitle;
        showRefresh = false;
        break;
      default:
        title = loc.appTitle;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title!),
        actions: showRefresh ? const [RefreshIcon()] : null,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5))),
      ),
      body: Builder(
        builder: (context) {
          switch (navIndex) {
            case 1:
              return const SwitchesHome();
            case 2:
              return const SensorsHome();
            case 3:
              return const RulesHome();
            case 4:
              return const ThingsHome();
            case 5:
              return const SystemInfo();
            case 6:
              return SettingsHome(callback: _settingsVerified);
            case 7:
              return const AboutHome();
            default:
              return const SwitchesHome();
          }
        },
      ),
      drawer: SideBar(
          selectedIndex: navIndex,
          setIndex: (int index) {
            setState(() {
              navIndex = index;
            });
          },
          displayName: displayName,
          userName: userName),
    );
  }
}
