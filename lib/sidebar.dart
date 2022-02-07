// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideBar extends StatelessWidget {
  SideBar(
      {Key? key,
      required this.selectedIndex,
      required this.setIndex,
      this.displayName,
      this.userName})
      : super(key: key);
  final Function setIndex;
  final int selectedIndex;
  String? displayName;
  String? userName;

  _navItemClicked(BuildContext context, int index) async {
    Navigator.of(context).pop();
    Future.delayed(Duration(milliseconds: 400), () => setIndex(index));
  }

  _navItem(
          {required BuildContext context,
          required IconData icon,
          required String title,
          String? subtitle,
          required isDark,
          required Function() onTap,
          required bool selected}) =>
      Container(
        decoration: ShapeDecoration(
            color: selected
                ? isDark
                    ? Colors.grey.shade500
                    : Colors.grey.shade300
                : Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            )),
        child: ListTile(
          leading: Icon(icon,
              color: selected ? Theme.of(context).primaryColor : Colors.black),
          title: Text(title),
          subtitle: Text(subtitle ?? ''),
          selected: selected,
          onTap: onTap,
        ),
      );

  @override
  Widget build(BuildContext context) {
    AppLocalizations loc = AppLocalizations.of(context)!;
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      child: ListView(
        children: [
          userName == null
              ? DrawerHeader(
                  child: Text(loc.noCredentials),
                )
              : UserAccountsDrawerHeader(
                  accountName: Text(displayName ?? loc.displayName),
                  accountEmail: Text(userName!),
                  arrowColor: Colors.amberAccent,
                ),
          _navItem(
              context: context,
              icon: Icons.settings_power,
              title: loc.switchesSidebarTitle,
              subtitle: loc.switchesSidebarSubTitle,
              isDark: isDark,
              selected: selectedIndex == 1,
              onTap: () {
                _navItemClicked(context, 1);
              }),
          _navItem(
              context: context,
              icon: Icons.sensors_rounded,
              title: loc.sensorsSidebarTitle,
              subtitle: loc.sensorsSidebarSubTitle,
              isDark: isDark,
              selected: selectedIndex == 2,
              onTap: () {
                _navItemClicked(context, 2);
              }),
          _navItem(
              context: context,
              icon: Icons.play_circle,
              title: loc.ruleSidebarTitle,
              subtitle: loc.rulesSidebarSubTitle,
              isDark: isDark,
              onTap: () {
                _navItemClicked(context, 3);
              },
              selected: selectedIndex == 3),
          _navItem(
              context: context,
              icon: Icons.system_security_update,
              title: loc.sysInfoSidebarTitle,
              subtitle: loc.sysInfoSidebarSubTitle,
              isDark: isDark,
              onTap: () {
                _navItemClicked(context, 4);
              },
              selected: selectedIndex == 4),
          _navItem(
              context: context,
              icon: Icons.settings,
              title: loc.settingsSideBarTitle,
              isDark: isDark,
              onTap: () {
                _navItemClicked(context, 5);
              },
              selected: selectedIndex == 5),
        ],
      ),
    );
  }
}
