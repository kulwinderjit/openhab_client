import 'package:flutter/material.dart';
import 'package:openhab_client/models/ItemGroupsProvider.dart';
import 'package:provider/provider.dart';

class RefreshIcon extends StatefulWidget {
  RefreshIcon({Key? key, required this.callback}) : super(key: key);
  late final Function callback;

  @override
  State<StatefulWidget> createState() => RefreshIconState();
}

class RefreshIconState extends State<RefreshIcon> {
  bool isRefreshing = false;

  void perfromRefresh(ItemGroupsProvider it, BuildContext context) async {
    setState(() {
      isRefreshing = true;
    });
    it.refresh(context).whenComplete(() {
      setState(() {
        isRefreshing = false;
      });
      widget.callback();
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ItemGroupsProvider it =
        Provider.of<ItemGroupsProvider>(context, listen: false);
    Widget retWidget;
    if (isRefreshing) {
      retWidget = Container(
        padding: const EdgeInsets.only(right: 26),
        width: 49,
        height: 23,
        child: FittedBox(
            fit: BoxFit.contain,
            child: CircularProgressIndicator(
                strokeWidth: 5, color: theme.appBarTheme.iconTheme!.color)),
      );
    } else {
      retWidget = IconButton(
        onPressed: () => perfromRefresh(it, context),
        icon: const Icon(
          Icons.refresh_sharp,
        ),
        iconSize: 36,
        padding: const EdgeInsets.only(right: 20),
      );
    }
    return retWidget;
  }
}
