import 'package:flutter/material.dart';
import 'package:openhab_client/models/ItemGroupsProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:openhab_client/search_widget.dart';
import 'package:openhab_client/thing_widget.dart';
import 'package:openhab_client/utils.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'models/thing.dart';

class ThingsHome extends StatefulWidget {
  const ThingsHome({Key? key}) : super(key: key);

  @override
  State<ThingsHome> createState() => _ThingsHomeState();
}

class _ThingsHomeState extends State<ThingsHome> {
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
    List<Thing> rs = items.things
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
                Thing thing = rs[index];
                ThingWidget r = ThingWidget(
                  name: thing.name ?? loc.noName,
                  state: thing.state ?? false,
                  stateCallback: (st) => switchState(st, thing.uuid, items.auth,
                      items.apiToken, context, thing),
                );
                return r;
              }),
        ),
      ],
    ));

    return body;
  }

  Future<bool> switchState(bool state, String? uuid, String? auth,
      String? apiToken, BuildContext context, Thing thing) async {
    AppLocalizations loc = AppLocalizations.of(context)!;
    var url = Uri.parse(Utils.enableThingUrl.replaceAll('{uuid}', uuid!));
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
      var resp = await http.put(url, headers: hdrs, body: state.toString());
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
    thing.state = _state;
    return _state;
  }
}
