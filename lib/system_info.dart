import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:openhab_client/models/ItemGroupsProvider.dart';
import 'package:openhab_client/page_wrapper.dart';
import 'package:provider/src/provider.dart';

class SystemInfo extends StatelessWidget {
  const SystemInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ItemGroupsProvider items = context.watch<ItemGroupsProvider>();
    AppLocalizations loc = AppLocalizations.of(context)!;
    List<TableRow> rows = [];
    for (var element in items.sysInfo.entries) {
      rows.add(TableRow(children: [
        SelectableText(element.key, textScaleFactor: 1.1),
        SelectableText(element.value, textScaleFactor: 1.1),
      ]));
    }
    SafeArea body = SafeArea(
      child: Card(
          child: Wrap(
        children: [
          Card(
            color: Theme.of(context).primaryColor.withAlpha(150),
            child: ListTile(
              title: Text(loc.sysInfoTitle,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Table(
              children: rows,
            ),
          )
        ],
      )),
    );
    return body;
  }
}
