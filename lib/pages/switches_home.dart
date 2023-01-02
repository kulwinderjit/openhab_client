import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:openhab_client/models/item.dart';
import 'package:openhab_client/models/ItemGroupsProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:openhab_client/widgets/search_widget.dart';
import 'package:openhab_client/widgets/switch_widget.dart';
import 'package:openhab_client/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SwitchesHome extends StatefulWidget {
  const SwitchesHome({Key? key}) : super(key: key);

  @override
  State<SwitchesHome> createState() => _SwitchesHomeState();
}

class _SwitchesHomeState extends State<SwitchesHome> {
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
    AppLocalizations loc = AppLocalizations.of(context)!;
    ThemeData theme = Theme.of(context);
    SplayTreeMap<String, List<Item>> switchGroups = items.switchGroups;
    List<MapEntry<String, List<Item>>> filterMap = switchGroups.entries
        .map((e) {
          List<Item> l = e.value
              .where((element) =>
                  (element.label.isEmpty ? element.name : element.label)
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase()) ||
                  _searchController.text.isEmpty)
              .toList();
          MapEntry<String, List<Item>> m = MapEntry(e.key, l);
          return m;
        })
        .where((element) => element.value.length > 0)
        .toList();
    Widget body = SafeArea(
        child: items.switchGroups.length == 0
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
                    child: GridView.builder(
                      itemCount: filterMap.length,
                      itemBuilder: (context, idx) {
                        MapEntry<String, List<Item>> entry = filterMap[idx];
                        String groupName = entry.key;
                        List<Item> switches = entry.value;
                        List<Widget> buttons = [];
                        for (Item s in switches) {
                          buttons.add(Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: SwitchWidget(
                                name: s.label.isEmpty ? s.name : s.label,
                                state: (s.state) == Utils.onN,
                                callback: (st) {
                                  return switchState(
                                    st,
                                    s.link,
                                    items.auth,
                                    context,
                                    s,
                                    items,
                                  );
                                }),
                          ));
                        }
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(
                              left: 8, right: 8, top: 5, bottom: 5),
                          child: Column(
                            children: [
                              Card(
                                elevation: 4,
                                child: ListTile(
                                  title: Text(groupName),
                                  horizontalTitleGap: 0,
                                  leading: Icon(
                                    Icons.toggle_on,
                                    color: theme.iconTheme.color,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      ...buttons,
                                      Padding(
                                          padding: EdgeInsets.only(right: 8))
                                    ],
                                  ),
                                ),
                              ),
                              const Padding(padding: EdgeInsets.all(9)),
                            ],
                          ),
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: Utils.gridColumnCount(context),
                          mainAxisExtent: 160),
                    ),
                  ),
                ],
              ));
    return body;
  }

  Future<bool> switchState(bool state, String? url, String? auth,
      BuildContext context, Item item, ItemGroupsProvider provider) async {
    AppLocalizations loc = AppLocalizations.of(context)!;
    if (url == null || auth == null) {
      Utils.makeToast(context, loc.noCredentialsMsg);
      return !state;
    }
    bool _state = state;
    var hdrs = <String, String>{
      'authorization': auth,
      'accept': 'application/json'
    };
    try {
      var resp = await http.post(Uri.parse(url),
          headers: hdrs, body: state ? Utils.onN : Utils.off);
      if (resp.statusCode != 200) {
        _state = !state;
      }
    } on Exception catch (e) {
      await Future.delayed(const Duration(seconds: 1), () => _state = !state);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(loc.errorOccurred),
      ));
    } on Error catch (e) {
      await Future.delayed(const Duration(seconds: 1), () => _state = !state);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(loc.errorOccurred),
      ));
    }
    item.state = _state ? Utils.onN : Utils.off;
    SharedPreferences.getInstance()
        .then((value) => provider.saveSwitches(value));
    return _state;
  }
}
