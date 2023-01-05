import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:typicons_flutter/typicons_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutHome extends StatelessWidget {
  const AboutHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations loc = AppLocalizations.of(context)!;
    ThemeData theme = Theme.of(context);
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              loc.developerName,
              style: theme.textTheme.headline4,
            ),
            Text(
              loc.aboutTagline,
              style: theme.textTheme.headline4,
            ),
            Text(
              loc.aboutSubTagline,
              style: theme.textTheme.headline5,
            ),
            SizedBox(
              height: 10.0,
            ),
            Card(
              clipBehavior: Clip.antiAlias,
              margin: EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 25.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              elevation: 4,
              child: ListTile(
                leading: Icon(
                  Typicons.social_github,
                ),
                title: Text(
                  loc.github,
                ),
                onTap: () => launch(loc.githubUrl),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
