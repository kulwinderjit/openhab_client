import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:openhab_client/models/EnrichedItemDTO.dart';
import 'package:openhab_client/models/ItemGroupsProvider.dart';
import 'package:openhab_client/search_widget.dart';
import 'package:provider/src/provider.dart';
import "dart:collection";

class SensorsHome extends StatefulWidget {
  const SensorsHome({Key? key}) : super(key: key);

  @override
  State<SensorsHome> createState() => _SensorsHomeState();
}

class _SensorsHomeState extends State<SensorsHome> {
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ItemGroupsProvider items = context.watch<ItemGroupsProvider>();
    AppLocalizations loc = AppLocalizations.of(context)!;
    ThemeData theme = Theme.of(context);
    SplayTreeMap<String, List<EnrichedItemDTO>> sensorGroups =
        items.sensorGroups;
    List<MapEntry<String, List<EnrichedItemDTO>>> filterMap =
        sensorGroups.entries
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
    SafeArea body = SafeArea(
      child: items.sensorGroups.length == 0
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
                    itemCount: filterMap.length,
                    itemBuilder: (conext, idx) {
                      MapEntry<String, List<EnrichedItemDTO>> entry =
                          filterMap[idx];
                      String groupName = entry.key;
                      List<EnrichedItemDTO> sensors = entry.value;
                      List<TableRow> rows = [];
                      for (EnrichedItemDTO s in sensors) {
                        rows.add(TableRow(children: [
                          SelectableText(
                            s.label.isEmpty ? s.name : s.label,
                            style: theme.textTheme.subtitle2,
                          ),
                          SelectableText(
                            s.state.isEmpty ? loc.noValue : s.state,
                            style: theme.textTheme.subtitle2,
                          ),
                        ]));
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
                                  Icons.sensors,
                                  color: theme.iconTheme.color,
                                ),
                              ),
                            ),
                            Wrap(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30, right: 8, top: 8, bottom: 8),
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
                ),
              ],
            ),
    );
    return body;
  }
}
