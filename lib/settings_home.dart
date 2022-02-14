import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:openhab_client/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as conv;

class SettingsHome extends StatefulWidget {
  SettingsHome({Key? key, required Function callback}) : super(key: key) {
    this._callback = callback;
  }

  late Function _callback;

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
  bool testing = false;
  bool _passwordVisible = false;
  bool userEmpty = false, passEmpty = false, tokenEmpty = false;
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

  void _save(BuildContext context, AppLocalizations loc) async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    String apiToken = _apiTokenController.text;
    userEmpty = username.isEmpty;
    passEmpty = password.isEmpty;
    tokenEmpty = apiToken.isEmpty;
    if (userEmpty || passEmpty || tokenEmpty) {
      setState(() {});
      return;
    }
    setState(() {
      testing = true;
    });
    String basicAuth = 'Basic ' +
        conv.base64Encode(conv.utf8
            .encode('${_usernameController.text}:${_passwordController.text}'));
    bool tested =
        await testCredentials(basicAuth, _apiTokenController.text, context);
    if (tested) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', _usernameController.text);
      prefs.setString('password', _passwordController.text);
      prefs.setString('displayName', _displayNameController.text);
      prefs.setString('apitoken', _apiTokenController.text);
      widget._callback.call();
      Utils.makeToast(context, loc.settingsSaved);
    }
    setState(() {
      testing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations loc = AppLocalizations.of(context)!;
    Color buttonColor;
    if (Theme.of(context).brightness == Brightness.dark) {
      buttonColor = Colors.white70;
    } else {
      buttonColor = Theme.of(context).primaryColor;
    }
    Card body = Card(
      elevation: 5,
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: <Widget>[
          Card(
              elevation: 2,
              color: Theme.of(context).primaryColor.withAlpha(150),
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
                prefixIcon: const Icon(Icons.smart_display_outlined),
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
                prefixIcon: const Icon(Icons.manage_accounts),
                labelText: loc.userName,
                errorText: userEmpty ? loc.userNameRequired : null,
              )),
          TextField(
            controller: _passwordController,
            autocorrect: false,
            enableSuggestions: false,
            obscureText: !_passwordVisible,
            obscuringCharacter: '*',
            decoration: InputDecoration(
              filled: false,
              fillColor: Colors.grey[100],
              labelText: loc.passowrd,
              errorText: passEmpty ? loc.passwordRequired : null,
              prefixIcon: const Icon(Icons.password),
              suffixIcon: IconButton(
                icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              ),
            ),
          ),
          TextField(
            controller: _apiTokenController,
            autocorrect: false,
            enableSuggestions: false,
            decoration: InputDecoration(
              filled: false,
              fillColor: Colors.grey[100],
              labelText: loc.apiToken,
              errorText: tokenEmpty ? loc.apiTokenRequired : null,
              prefixIcon: const Icon(Icons.api),
              suffixIcon: IconButton(
                icon: Icon(Icons.content_paste),
                onPressed: () {
                  Clipboard.getData('text/plain').then((value) {
                    setState(() {
                      if (value != null && value.text != null) {
                        _apiTokenController.text = value.text!;
                      }
                    });
                  });
                },
              ),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(buttonColor)),
                onPressed: () {
                  _save(context, loc);
                },
                child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Wrap(spacing: 10, runSpacing: 10, children: [
                      Text(
                        testing ? loc.verifyingCredentials : loc.save,
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

  Future<bool> testCredentials(
      String? auth, String? apiToken, BuildContext context) async {
    AppLocalizations loc = AppLocalizations.of(context)!;
    var url = Uri.parse(Utils.thingsUrl);
    bool _state = false;
    if (auth == null || apiToken == null) {
      Utils.makeToast(context, loc.noCredentialsMsg);
      return _state;
    }
    var hdrs = <String, String>{
      'authorization': auth,
      'accept': 'application/json',
      'X-OPENHAB-TOKEN': apiToken,
    };
    try {
      var resp = await http.get(url, headers: hdrs);
      if (resp.statusCode != 200) {
        Utils.makeToast(
            context, '${loc.errorOccurred}\nHttp error ${resp.statusCode}');
      } else {
        _state = true;
      }
    } on Exception catch (e) {
      await Future.delayed(const Duration(seconds: 1));
      Utils.makeToast(context, '${loc.errorOccurred}\n$e');
    } on Error catch (e) {
      await Future.delayed(const Duration(seconds: 1));
      Utils.makeToast(context, '${loc.errorOccurred}\n$e');
    }
    return _state;
  }
}
