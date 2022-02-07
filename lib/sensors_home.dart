import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:openhab_client/models/EnrichedItemDTO.dart';
import 'package:openhab_client/models/ItemGroupsProvider.dart';
import 'package:openhab_client/page_wrapper.dart';
import 'package:provider/src/provider.dart';
import "dart:collection";

class SensorsHome extends StatelessWidget {
  const SensorsHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ItemGroupsProvider items = context.watch<ItemGroupsProvider>();
    AppLocalizations loc = AppLocalizations.of(context)!;
    SplayTreeMap<String, List<EnrichedItemDTO>> sensorGroups =
        items.sensorGroups;
    SafeArea body = SafeArea(
      child: ListView.builder(
        itemCount: sensorGroups.entries.length,
        itemBuilder: (conext, idx) {
          MapEntry<String, List<EnrichedItemDTO>> entry =
              sensorGroups.entries.elementAt(idx);
          String groupName = entry.key;
          List<EnrichedItemDTO> sensors = entry.value;
          List<TableRow> rows = [];
          for (EnrichedItemDTO s in sensors) {
            rows.add(TableRow(children: [
              SelectableText(s.label ?? s.name ?? loc.noName,
                  textScaleFactor: 1.1),
              SelectableText(s.state ?? loc.noValue, textScaleFactor: 1.1),
            ]));
          }
          return Card(
            elevation: 5,
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Card(
                  elevation: 2,
                  color: Theme.of(context).primaryColor,
                  child: ListTile(
                    title: Text(
                      groupName,
                      style: const TextStyle(color: Colors.white),
                    ),
                    leading: const Icon(
                      Icons.roofing_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Table(
                        children: rows,
                      ),
                    )
                  ],
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  direction: Axis.horizontal,
                  verticalDirection: VerticalDirection.down,
                  spacing: 15,
                  runSpacing: 15,
                ),
              ],
            ),
          );
        },
      ),
    );
    return body;
  }
}
