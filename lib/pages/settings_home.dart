// ignore_for_file: must_be_immutable

import 'package:flex_color_scheme/flex_color_scheme.dart';
// ignore: unnecessary_import
import 'package:flex_color_scheme/src/flex_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:openhab_client/widgets/theme_choser.dart';
import 'package:openhab_client/widgets/theme_mode_switch.dart';
import 'package:openhab_client/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as conv;

class SettingsHome extends StatefulWidget {
  SettingsHome(
      {Key? key,
      required Function callback,
      required Function demoCallback,
      required themeMode,
      required onThemeModeChanged,
      required ValueChanged<FlexScheme> onThemeChanged,
      required FlexScheme currentScheme})
      : super(key: key) {
    this._callback = callback;
    this._themeMode = themeMode;
    this._onThemeModeChanged = onThemeModeChanged;
    this._onThemeChanged = onThemeChanged;
    this._currentScheme = currentScheme;
    this._demoCallback = demoCallback;
  }
  late final ThemeMode _themeMode;
  late final ValueChanged<ThemeMode> _onThemeModeChanged;
  late final ValueChanged<FlexScheme> _onThemeChanged;
  late final FlexScheme _currentScheme;
  late final Function _callback;
  late final Function _demoCallback;

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
      _passwordController.text = prefs.get(Utils.password)?.toString() ?? '';
      _displayNameController.text =
          prefs.get(Utils.displayName)?.toString() ?? '';
      _usernameController.text = prefs.get(Utils.username)?.toString() ?? '';
      _apiTokenController.text = prefs.get(Utils.apitoken)?.toString() ?? '';
    });
  }

  void themeChange(FlexScheme scheme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Utils.colorScheme, scheme.name);
    widget._onThemeChanged(scheme);
  }

  void themeModeChange(ThemeMode mode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(Utils.themeMode, mode.index);
    widget._onThemeModeChanged(mode);
  }

  void demoData(BuildContext context, AppLocalizations loc) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(loc.askGenDemoDataTitle),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(loc.genDemoDataWarn),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(loc.generate),
              onPressed: () {
                widget._demoCallback();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(loc.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
    Utils.makeToast(context, loc.verifyingCredentials);
    String basicAuth = 'Basic ' +
        conv.base64Encode(conv.utf8
            .encode('${_usernameController.text}:${_passwordController.text}'));
    bool tested =
        await testCredentials(basicAuth, _apiTokenController.text, context);
    if (tested) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(Utils.username, _usernameController.text);
      prefs.setString(Utils.password, _passwordController.text);
      prefs.setString(Utils.displayName, _displayNameController.text);
      prefs.setString(Utils.apitoken, _apiTokenController.text);
      widget._callback.call();
      Utils.makeToast(context, loc.settingsSaved);
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations loc = AppLocalizations.of(context)!;
    ThemeData theme = Theme.of(context);
    Widget body = GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: ListView(children: [
        Card(
          elevation: 2,
          margin: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            children: <Widget>[
              Card(
                  elevation: 4,
                  child: ListTile(
                      leading: Icon(
                        Icons.settings,
                        color: theme.iconTheme.color,
                      ),
                      horizontalTitleGap: 0,
                      title: Text(loc.credentialsTitle,
                          style: theme.textTheme.subtitle1))),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: TextField(
                    controller: _displayNameController,
                    autocorrect: false,
                    enableSuggestions: false,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.smart_display_outlined),
                      labelText: loc.displayName,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: TextField(
                    controller: _usernameController,
                    autocorrect: false,
                    enableSuggestions: false,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.manage_accounts),
                      labelText: loc.userName,
                      errorText: userEmpty ? loc.userNameRequired : null,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: TextField(
                  controller: _passwordController,
                  autocorrect: false,
                  enableSuggestions: false,
                  obscureText: !_passwordVisible,
                  obscuringCharacter: '*',
                  decoration: InputDecoration(
                    labelText: loc.passowrd,
                    errorText: passEmpty ? loc.passwordRequired : null,
                    prefixIcon: const Icon(Icons.password),
                    suffixIcon: IconButton(
                      icon: Icon(_passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: TextField(
                  controller: _apiTokenController,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: InputDecoration(
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
              ),
              ButtonBar(
                alignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      demoData(context, loc);
                    },
                    child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Wrap(spacing: 10, runSpacing: 10, children: [
                          Text(
                            loc.genDemoData,
                            style: theme.primaryTextTheme.headline6,
                          )
                        ])),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _save(context, loc);
                    },
                    child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Wrap(spacing: 10, runSpacing: 10, children: [
                          Text(
                            loc.save,
                            style: theme.primaryTextTheme.headline6,
                          )
                        ])),
                  )
                ],
              ),
            ],
          ),
        ),
        Card(
          margin: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
          elevation: 2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(loc.colorScheme),
                  trailing: ThemeChoser(
                    onSelect: themeChange,
                    currentSheme: widget._currentScheme,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(loc.themeMode),
                  subtitle: Text('${loc.themeModeSub} '
                      '${widget._themeMode.toString().dotTail}'),
                  trailing: ThemeModeSwitch(
                    themeMode: widget._themeMode,
                    onChanged: themeModeChange,
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
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
