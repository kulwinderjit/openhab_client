import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:openhab_client/models/EnrichedItemDTO.dart';
import 'package:openhab_client/models/ItemGroupsProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:openhab_client/search_widget.dart';
import 'package:openhab_client/switch_widget.dart';
import 'package:openhab_client/utils.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

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
    SplayTreeMap<String, List<EnrichedItemDTO>> switchGroups =
        items.switchGroups;
    List<MapEntry<String, List<EnrichedItemDTO>>> filterMap =
        switchGroups.entries
            .map((e) {
              List<EnrichedItemDTO> l = e.value
                  .where((element) =>
                      (element.label.isEmpty ? element.name : element.label)
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase()) ||
                      _searchController.text.isEmpty)
                  .toList();
              MapEntry<String, List<EnrichedItemDTO>> m = MapEntry(e.key, l);
              return m;
            })
            .where((element) => element.value.length > 0)
            .toList();
    Widget body = SafeArea(
        child: Column(
      children: [
        SearchWidget(controller: _searchController),
        Expanded(
          child: ListView.builder(
            itemCount: filterMap.length,
            itemBuilder: (context, idx) {
              MapEntry<String, List<EnrichedItemDTO>> entry = filterMap[idx];
              String groupName = entry.key;
              List<EnrichedItemDTO> switches = entry.value;
              List<Widget> buttons = [];
              for (EnrichedItemDTO s in switches) {
                buttons.add(SwitchWidget(
                    name: s.label.isEmpty ? s.name : s.label,
                    state: (s.state) == Utils.onN,
                    callback: (st) {
                      return switchState(st, s.link, items.auth, context, s);
                    }));
              }
              return Card(
                elevation: 5,
                margin: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                      elevation: 2,
                      color: Theme.of(context).primaryColor.withAlpha(150),
                      child: ListTile(
                        title: Text(groupName),
                        textColor: Colors.white,
                        leading: const Icon(
                          Icons.roofing_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Wrap(
                      children: [...buttons],
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.end,
                      direction: Axis.horizontal,
                      verticalDirection: VerticalDirection.down,
                      spacing: 15,
                      runSpacing: 15,
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ));
    return body;
  }

  Future<bool> switchState(bool state, String? url, String? auth,
      BuildContext context, EnrichedItemDTO item) async {
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
    return _state;
  }
}
