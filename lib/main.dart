// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:openhab_client/models/ItemGroupsProvider.dart';
import 'package:openhab_client/page_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? colorSchemeStr = prefs.getString('colorScheme');
  int? themeModeInt = prefs.getInt('themeMode');
  ThemeMode themeMode;
  FlexScheme colorScheme;
  if (themeModeInt != null) {
    themeMode = ThemeMode.values[themeModeInt];
  } else {
    themeMode = ThemeMode.system;
  }
  if (colorSchemeStr != null) {
    colorScheme = FlexScheme.values
        .firstWhere((element) => element.name == colorSchemeStr);
  } else {
    colorScheme = FlexScheme.greyLaw;
  }
  runApp(ChangeNotifierProvider(
      create: (context) => ItemGroupsProvider(),
      child: MyApp(
        themeMode: themeMode,
        colorScheme: colorScheme,
      )));
}

class MyApp extends StatefulWidget {
  MyApp({Key? key, required this.themeMode, required this.colorScheme})
      : super(key: key);
  ThemeMode themeMode;
  FlexScheme colorScheme;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      theme: FlexThemeData.light(
          scheme: widget.colorScheme,
          surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
          blendLevel: 15,
          useSubThemes: true),
      darkTheme: FlexThemeData.dark(
          scheme: widget.colorScheme,
          surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
          blendLevel: 15,
          useSubThemes: true),
      themeMode: widget.themeMode,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      locale: const Locale.fromSubtags(languageCode: 'en'),
      home: PageWrapper(
        themeMode: widget.themeMode,
        onThemeModeChanged: (ThemeMode mode) {
          setState(() {
            widget.themeMode = mode;
          });
        },
        currentScheme: widget.colorScheme,
        onThemeChanged: (FlexScheme scheme) {
          setState(() {
            widget.colorScheme = scheme;
          });
        },
      ),
    );
  }
}
