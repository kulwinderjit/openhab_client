import 'package:flutter/material.dart';
import 'package:openhab_client/page_wrapper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:openhab_client/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsHome extends StatefulWidget {
  const SettingsHome({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsHomeState();
}

class _SettingsHomeState extends State<SettingsHome> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _apiTokenController = TextEditingController();
  String username = '';
  String password = '';
  String displayName = '';
  String apiToken = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _passwordController.text = prefs.get('password')?.toString() ?? '';
      _displayNameController.text = prefs.get('displayName')?.toString() ?? '';
      _usernameController.text = prefs.get('username')?.toString() ?? '';
      _apiTokenController.text = prefs.get('apitoken')?.toString() ?? '';
    });
  }

  void _save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', _usernameController.text);
    prefs.setString('password', _passwordController.text);
    prefs.setString('displayName', _displayNameController.text);
    prefs.setString('apitoken', _apiTokenController.text);
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations loc = AppLocalizations.of(context)!;
    Card body = Card(
      elevation: 5,
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: <Widget>[
          Card(
              elevation: 2,
              color: Theme.of(context).primaryColor,
              child: ListTile(
                  title: Text(loc.credentialsTitle,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600)))),
          TextField(
              controller: _displayNameController,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.smart_display),
                filled: false,
                fillColor: Colors.grey[100],
                labelText: loc.displayName,
              )),
          TextField(
              controller: _usernameController,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                filled: false,
                fillColor: Colors.grey[100],
                prefixIcon: const Icon(Icons.supervised_user_circle),
                labelText: loc.userName,
              )),
          TextField(
            controller: _passwordController,
            autocorrect: false,
            enableSuggestions: false,
            obscureText: true,
            obscuringCharacter: '*',
            decoration: InputDecoration(
                filled: false,
                fillColor: Colors.grey[100],
                labelText: loc.passowrd,
                prefixIcon: const Icon(Icons.password)),
          ),
          TextField(
            controller: _apiTokenController,
            autocorrect: false,
            enableSuggestions: false,
            decoration: InputDecoration(
                filled: false,
                fillColor: Colors.grey[100],
                labelText: loc.apiToken,
                prefixIcon: const Icon(Icons.api)),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _save();
                  Utils.makeToast(context, loc.settingsSaved);
                },
                child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Wrap(spacing: 10, runSpacing: 10, children: [
                      Text(
                        loc.save,
                        style: const TextStyle(fontSize: 18),
                      )
                    ])),
              )
            ],
          ),
        ],
      ),
    );
    return body;
  }
}
