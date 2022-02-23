import 'package:flutter/material.dart';
import 'package:openhab_client/models/ItemGroupsProvider.dart';
import 'package:openhab_client/models/rule.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:openhab_client/widgets/rule_widget.dart';
import 'package:openhab_client/widgets/search_widget.dart';
import 'package:openhab_client/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RulesHome extends StatefulWidget {
  const RulesHome({Key? key}) : super(key: key);

  @override
  State<RulesHome> createState() => _RulesHomeState();
}

class _RulesHomeState extends State<RulesHome> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    ItemGroupsProvider items = context.watch<ItemGroupsProvider>();
    ThemeData theme = Theme.of(context);
    List<Rule> rs = items.rules
        .where((rule) =>
            rule.name!
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            _searchController.text.isEmpty)
        .toList();
    AppLocalizations loc = AppLocalizations.of(context)!;
    SafeArea body = SafeArea(
        child: items.rules.length == 0
            ? Card(
                elevation: 2,
                margin:
                    const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
                child: Center(
                    child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    loc.performRefresh,
                    style: theme.textTheme.subtitle1,
                  ),
                )),
              )
            : Column(
                children: [
                  SearchWidget(controller: _searchController),
                  Expanded(
                    child: ListView.builder(
                        itemCount: rs.length,
                        itemBuilder: (BuildContext context, int index) {
                          Rule rule = rs[index];
                          RuleWidget r = RuleWidget(
                            name: rule.name ?? loc.noName,
                            state: rule.state ?? false,
                            description: rule.description,
                            stateCallback: (st) => switchState(
                              st,
                              rule.uuid,
                              items.auth,
                              items.apiToken,
                              context,
                              rule,
                              items,
                            ),
                            runCallback: () => execute(
                                rule.uuid, items.auth, items.apiToken, context),
                          );
                          return r;
                        }),
                  ),
                ],
              ));

    return body;
  }

  Future<bool> execute(String? uuid, String? auth, String? apiToken,
      BuildContext context) async {
    AppLocalizations loc = AppLocalizations.of(context)!;
    var url = Uri.parse(Utils.runRuleUrl.replaceAll('{uuid}', uuid!));
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
      var resp = await http.post(url, headers: hdrs);
      if (resp.statusCode != 200) {
        _state = false;
        Utils.makeToast(context, loc.failedRuleExec);
      } else {
        _state = true;
        Utils.makeToast(context, loc.succesRuleExec);
      }
    } on Exception catch (e) {
      await Future.delayed(const Duration(seconds: 1), () => _state);
      Utils.makeToast(context, loc.errorOccurred);
    } on Error catch (e) {
      await Future.delayed(const Duration(seconds: 1), () => _state);
      Utils.makeToast(context, loc.errorOccurred);
    }
    return _state;
  }

  Future<bool> switchState(
      bool state,
      String? uuid,
      String? auth,
      String? apiToken,
      BuildContext context,
      Rule item,
      ItemGroupsProvider provider) async {
    AppLocalizations loc = AppLocalizations.of(context)!;
    var url = Uri.parse(Utils.enableRuleUrl.replaceAll('{uuid}', uuid!));
    if (auth == null || apiToken == null) {
      Utils.makeToast(context, loc.noCredentialsMsg);
      return !state;
    }
    bool _state = state;
    var hdrs = <String, String>{
      'authorization': auth,
      'accept': 'application/json',
      'X-OPENHAB-TOKEN': apiToken,
    };
    try {
      var resp = await http.post(url, headers: hdrs, body: state.toString());
      if (resp.statusCode != 200) {
        _state = !state;
      }
    } on Exception catch (e) {
      await Future.delayed(const Duration(seconds: 1), () => _state = !state);
      Utils.makeToast(context, loc.errorOccurred);
    } on Error catch (e) {
      await Future.delayed(const Duration(seconds: 1), () => _state = !state);
      Utils.makeToast(context, loc.errorOccurred);
    }
    item.state = _state;
    SharedPreferences.getInstance().then((value) => provider.saveRules(value));
    return _state;
  }
}
