import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:openhab_client/models/EnrichedItemDTO.dart';
import 'package:openhab_client/models/ItemGroupsProvider.dart';
import 'package:openhab_client/page_wrapper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:openhab_client/switch_widget.dart';
import 'package:openhab_client/utils.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SwitchesHome extends StatelessWidget {
  const SwitchesHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ItemGroupsProvider items = context.watch<ItemGroupsProvider>();
    AppLocalizations loc = AppLocalizations.of(context)!;
    SplayTreeMap<String, List<EnrichedItemDTO>> switchGroups =
        items.switchGroups;
    Widget body = ListView.builder(
      itemCount: switchGroups.length,
      itemBuilder: (context, idx) {
        MapEntry<String, List<EnrichedItemDTO>> entry =
            switchGroups.entries.elementAt(idx);
        String groupName = entry.key;
        List<EnrichedItemDTO> switches = entry.value;
        List<Widget> buttons = [];
        for (EnrichedItemDTO s in switches) {
          buttons.add(SwitchWidget(
              name: s.label ?? s.name ?? loc.noName,
              state: (s.state ?? Utils.off) == Utils.onN,
              callback: (st) {
                return switchState(st, s.link ?? '', items.auth, context, s);
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
                color: Theme.of(context).primaryColor,
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
    );
    return body;
  }

  Future<bool> switchState(bool state, String? url, String? auth,
      BuildContext context, EnrichedItemDTO item) async {
    if (url == null || auth == null) {
      return state;
    }
    AppLocalizations loc = AppLocalizations.of(context)!;
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
