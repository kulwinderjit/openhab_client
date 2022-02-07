import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:openhab_client/models/ItemGroupsProvider.dart';
import 'package:openhab_client/page_wrapper.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => ItemGroupsProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          colorSchemeSeed: Colors.tealAccent),
      darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.teal),
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      locale: const Locale.fromSubtags(languageCode: 'en'),
      home: const PageWrapper(),
    );
  }
}
