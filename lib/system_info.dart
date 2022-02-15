import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:openhab_client/models/ItemGroupsProvider.dart';
import 'package:provider/src/provider.dart';

class SystemInfo extends StatelessWidget {
  const SystemInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ItemGroupsProvider items = context.watch<ItemGroupsProvider>();
    AppLocalizations loc = AppLocalizations.of(context)!;
    ThemeData theme = Theme.of(context);
    List<TableRow> rows = [];
    for (var element in items.sysInfo.entries) {
      rows.add(TableRow(children: [
        SelectableText(element.key, style: theme.textTheme.subtitle2),
        SelectableText(element.value, style: theme.textTheme.subtitle2),
      ]));
    }
    SafeArea body = SafeArea(
      child: Card(
          elevation: 2,
          margin: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
          child: rows.length == 0
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      loc.performRefresh,
                      style: theme.textTheme.subtitle1,
                    ),
                  ),
                )
              : Wrap(
                  children: [
                    Card(
                      elevation: 4,
                      child: ListTile(
                        leading: Icon(
                          Icons.info,
                          color: theme.iconTheme.color,
                        ),
                        horizontalTitleGap: 0,
                        title: Text(loc.sysInfoTitle,
                            style: Theme.of(context).textTheme.headline6),
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
