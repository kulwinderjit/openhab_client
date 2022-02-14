import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:typicons_flutter/typicons_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutHome extends StatelessWidget {
  const AboutHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations loc = AppLocalizations.of(context)!;
    Color textColor;
    if (Theme.of(context).brightness == Brightness.dark) {
      textColor = Colors.white70;
    } else {
      textColor = Theme.of(context).primaryColor;
    }
    Color cardColor = Colors.white;
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            loc.developerName,
            style: TextStyle(
              fontSize: 40.0,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            loc.aboutTagline,
            style: TextStyle(
              color: textColor,
              fontSize: 20.0,
              letterSpacing: 2.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Divider(
            color: textColor,
            thickness: 4.0,
            indent: 50.0,
            endIndent: 50.0,
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
            color: cardColor,
            child: ListTile(
              leading: Icon(
                Typicons.social_github,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                loc.github,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onTap: () => launch(loc.githubUrl),
            ),
          ),
        ],
      ),
    );
  }
}
