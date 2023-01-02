// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:openhab_client/utils/layout.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class SideBar extends StatelessWidget {
  SideBar({
    Key? key,
    required this.selectedIndex,
    required this.setIndex,
    this.displayName,
    this.userName,
  }) : super(key: key);
  final Function setIndex;
  final int selectedIndex;
  String? displayName;
  String? userName;

  _navItemClicked(BuildContext context, int index) async {
    if (ResponsiveWrapper.of(context).isSmallerThan(Layout.TABLET)) {
      Navigator.of(context).pop();
      Future.delayed(Duration(milliseconds: 400), () => setIndex(index));
    } else {
      setIndex(index);
    }
  }

  _navItem(
          {required BuildContext context,
          required IconData icon,
          required String title,
          String? subtitle,
          required ThemeData theme,
          required Function() onTap,
          required bool selected}) =>
      Padding(
        padding: const EdgeInsets.only(left: 3, right: 3),
        child: Container(
          decoration: BoxDecoration(
              color:
                  selected ? theme.scaffoldBackgroundColor : Colors.transparent,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          child: ListTile(
            leading: Icon(
              icon,
            ),
            title: Text(title),
            subtitle: Text(subtitle ?? ''),
            selected: selected,
            onTap: onTap,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    AppLocalizations loc = AppLocalizations.of(context)!;
    ThemeData theme = Theme.of(context);
    return Drawer(
      shape: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
          ? const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            )
          : null,
      child: ListView(
        primary: false,
        children: [
          userName == null
              ? DrawerHeader(
                  decoration:
                      BoxDecoration(color: theme.appBarTheme.backgroundColor),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.noCredentials,
                        style: theme.primaryTextTheme.subtitle1,
                      ),
                    ],
                  ),
                )
              : UserAccountsDrawerHeader(
                  accountName: Text(displayName ?? loc.displayName),
                  accountEmail: Text(userName!),
                ),
          _navItem(
              context: context,
              icon: Icons.toggle_on,
              title: loc.switchesSidebarTitle,
              subtitle: loc.switchesSidebarSubTitle,
              theme: theme,
              selected: selectedIndex == 1,
              onTap: () {
                _navItemClicked(context, 1);
              }),
          _navItem(
              context: context,
              icon: Icons.sensors_rounded,
              title: loc.sensorsSidebarTitle,
              subtitle: loc.sensorsSidebarSubTitle,
              theme: theme,
              selected: selectedIndex == 2,
              onTap: () {
                _navItemClicked(context, 2);
              }),
          _navItem(
              context: context,
              icon: Icons.rule,
              title: loc.ruleSidebarTitle,
              subtitle: loc.rulesSidebarSubTitle,
              theme: theme,
              onTap: () {
                _navItemClicked(context, 3);
              },
              selected: selectedIndex == 3),
          _navItem(
              context: context,
              icon: Icons.emoji_objects,
              title: loc.thingsSidebarTitle,
              subtitle: loc.thingsSidebarSubTitle,
              theme: theme,
              onTap: () {
                _navItemClicked(context, 4);
              },
              selected: selectedIndex == 4),
          _navItem(
              context: context,
              icon: Icons.info,
              title: loc.sysInfoSidebarTitle,
              subtitle: loc.sysInfoSidebarSubTitle,
              theme: theme,
              onTap: () {
                _navItemClicked(context, 5);
              },
              selected: selectedIndex == 5),
          _navItem(
              context: context,
              icon: Icons.settings,
              title: loc.settingsSideBarTitle,
              theme: theme,
              onTap: () {
                _navItemClicked(context, 6);
              },
              selected: selectedIndex == 6),
          _navItem(
              context: context,
              icon: Icons.help,
              title: loc.aboutSideBarTitle,
              theme: theme,
              onTap: () {
                _navItemClicked(context, 7);
              },
              selected: selectedIndex == 7),
        ],
      ),
    );
  }
}
