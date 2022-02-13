import 'package:flutter/material.dart';
import 'package:openhab_client/models/ItemGroupsProvider.dart';
import 'package:openhab_client/models/rule.dart';
import 'package:openhab_client/page_wrapper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:openhab_client/rule_widget.dart';
import 'package:openhab_client/search_widget.dart';
import 'package:openhab_client/utils.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

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
    List<Rule> rs = items.rules
        .where((rule) =>
            rule.name!
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            _searchController.text.isEmpty)
        .toList();
    AppLocalizations loc = AppLocalizations.of(context)!;
    SafeArea body = SafeArea(
        child: Column(
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
                  stateCallback: (st) => switchState(
                      st, rule.uuid, items.auth, items.apiToken, context, rule),
                  runCallback: () =>
                      execute(rule.uuid, items.auth, items.apiToken, context),
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

  Future<bool> switchState(bool state, String? uuid, String? auth,
      String? apiToken, BuildContext context, Rule item) async {
    AppLocalizations loc = AppLocalizations.of(context)!;
    var url = Uri.parse(Utils.enableRuleUrl.replaceAll('{uuid}', uuid!));
    if (auth == null || apiToken == null) {
      Utils.makeToast(context, loc.noCredentialsMsg);
      return state;
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
    return _state;
  }
}
