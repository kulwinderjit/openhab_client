import 'dart:convert';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:openhab_client/pages/about_home.dart';
import 'package:openhab_client/models/item.dart';
import 'package:openhab_client/models/ItemGroupsProvider.dart';
import 'package:openhab_client/models/rule.dart';
import 'package:openhab_client/models/thing.dart';
import 'package:openhab_client/utils/layout.dart';
import 'package:openhab_client/widgets/refresh_icon.dart';
import 'package:openhab_client/pages/rules_home.dart';
import 'package:openhab_client/pages/sensors_home.dart';
import 'package:openhab_client/pages/settings_home.dart';
import 'package:openhab_client/pages/sidebar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:openhab_client/pages/switches_home.dart';
import 'package:openhab_client/pages/system_info_home.dart';
import 'package:openhab_client/pages/things_home.dart';
import 'package:openhab_client/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageWrapper extends StatefulWidget {
  const PageWrapper({
    Key? key,
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.onThemeChanged,
    required this.currentScheme,
  }) : super(key: key);

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final ValueChanged<FlexScheme> onThemeChanged;
  final FlexScheme currentScheme;

  @override
  State<StatefulWidget> createState() => PageWrapperState();
}

class PageWrapperState extends State<PageWrapper> {
  int navIndex = 1;
  String? title;
  String? displayName;
  String? userName;
  bool isDemo = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      displayName = prefs.get(Utils.displayName)?.toString();
      userName = prefs.get(Utils.username)?.toString();
      String? password = prefs.get(Utils.password)?.toString();
      String? apiToken = prefs.get(Utils.apitoken)?.toString();
      String? switches = prefs.get(Utils.switches)?.toString();
      String? rules = prefs.get(Utils.rules)?.toString();
      String? things = prefs.get(Utils.things)?.toString();
      isDemo = prefs.getBool(Utils.isDemo) ?? false;
      ItemGroupsProvider items =
          Provider.of<ItemGroupsProvider>(context, listen: false);
      if (switches != null) {
        List<Item> switchList = (jsonDecode(switches) as List)
            .map((e) => Item.fromJson(e))
            .toList();
        Future.delayed(Duration.zero, () {
          items.addSwitches(switchList);
        });
      }
      if (rules != null) {
        List<Rule> ruleList =
            (jsonDecode(rules) as List).map((e) => Rule.fromJson(e)).toList();
        Future.delayed(Duration.zero, () {
          items.addRules(ruleList);
        });
      }
      if (things != null) {
        List<Thing> thingList =
            (jsonDecode(things) as List).map((e) => Thing.fromJson(e)).toList();
        Future.delayed(Duration.zero, () {
          items.addThings(thingList);
        });
      }
      if (userName == null || userName!.isEmpty) {
        setState(() {
          navIndex = 6;
        });
      } else {
        String basicAuth =
            'Basic ' + base64Encode(utf8.encode('$userName:$password'));
        items.auth = basicAuth;
        items.apiToken = apiToken;
      }
    });
  }

  void _dataRefresh() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(Utils.isDemo, false);
      setState(() {
        isDemo = false;
      });
    });
  }

  void _demoData(BuildContext context, AppLocalizations loc) {
    ItemGroupsProvider items =
        Provider.of<ItemGroupsProvider>(context, listen: false);
    items.dummyData(context).then((value) {
      Utils.makeToast(context, loc.genDemoDataDone);
      SharedPreferences.getInstance().then((prefs) {
        prefs.setBool(Utils.isDemo, true);
        setState(() {
          isDemo = true;
        });
      });
    });
  }

  void _settingsVerified() {
    SharedPreferences.getInstance().then((prefs) {
      displayName = prefs.get(Utils.displayName)?.toString();
      userName = prefs.get(Utils.username)?.toString();
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
    if (isDemo && navIndex >= 1 && navIndex <= 5) {
      title = '${loc.demo} $title';
    }
    return Builder(builder: (context) {
      ResponsiveWrapperData responsiveData = ResponsiveWrapper.of(context);
      double menuwidth = 250;
      double contentWidth = responsiveData.screenWidth - menuwidth;
      if (responsiveData.isLargerThan(Layout.MOBILE)) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 40,
            title: Text(title!),
            actions: showRefresh
                ? [
                    RefreshIcon(
                      callback: _dataRefresh,
                    )
                  ]
                : null,
          ),
          body: Row(
            children: [
              SizedBox(
                width: menuwidth,
                child: SideBar(
                  selectedIndex: navIndex,
                  setIndex: (int index) {
                    setState(() {
                      navIndex = index;
                    });
                  },
                  displayName: displayName,
                  userName: userName,
                ),
              ),
              SizedBox(
                width: contentWidth,
                child: Builder(
                  builder: (context) {
                    switch (navIndex) {
                      case 1:
                        return SwitchesHome();
                      case 2:
                        return const SensorsHome();
                      case 3:
                        return RulesHome();
                      case 4:
                        return ThingsHome();
                      case 5:
                        return SystemInfo();
                      case 6:
                        return SettingsHome(
                          demoCallback: () {
                            _demoData(context, loc);
                          },
                          callback: _settingsVerified,
                          themeMode: widget.themeMode,
                          onThemeModeChanged: widget.onThemeModeChanged,
                          onThemeChanged: widget.onThemeChanged,
                          currentScheme: widget.currentScheme,
                        );
                      case 7:
                        return const AboutHome();
                      default:
                        return SwitchesHome();
                    }
                  },
                ),
              )
            ],
          ),
        );
      } else {
        return Scaffold(
          appBar: AppBar(
            title: Text(title!),
            actions: showRefresh
                ? [
                    RefreshIcon(
                      callback: _dataRefresh,
                    )
                  ]
                : null,
          ),
          body: Builder(
            builder: (context) {
              switch (navIndex) {
                case 1:
                  return SwitchesHome();
                case 2:
                  return const SensorsHome();
                case 3:
                  return const RulesHome();
                case 4:
                  return const ThingsHome();
                case 5:
                  return const SystemInfo();
                case 6:
                  return SettingsHome(
                    demoCallback: () {
                      _demoData(context, loc);
                    },
                    callback: _settingsVerified,
                    themeMode: widget.themeMode,
                    onThemeModeChanged: widget.onThemeModeChanged,
                    onThemeChanged: widget.onThemeChanged,
                    currentScheme: widget.currentScheme,
                  );
                case 7:
                  return const AboutHome();
                default:
                  return SwitchesHome();
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
    });
  }
}
