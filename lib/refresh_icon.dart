import 'package:flutter/material.dart';
import 'package:openhab_client/models/ItemGroupsProvider.dart';
import 'package:provider/provider.dart';

class RefreshIcon extends StatefulWidget {
  const RefreshIcon({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RefreshIconState();
}

class RefreshIconState extends State<RefreshIcon> {
  bool isRefreshing = false;

  void perfromRefresh(ItemGroupsProvider it) async {
    setState(() {
      isRefreshing = true;
    });
    it.refresh().whenComplete(() => setState(() {
          isRefreshing = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    ItemGroupsProvider it =
        Provider.of<ItemGroupsProvider>(context, listen: false);
    Widget retWidget;
    if (isRefreshing) {
      retWidget = Padding(
          padding: const EdgeInsets.only(right: 20, top: 10),
          child: Wrap(
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 5, right: 3),
                  height: 24,
                  width: 24,
                  child: const CircularProgressIndicator(color: Colors.white))
            ],
          ));
    } else {
      retWidget = IconButton(
        onPressed: () => perfromRefresh(it),
        icon: const Icon(
          Icons.refresh_sharp,
          color: Colors.white,
        ),
        iconSize: 36,
        padding: const EdgeInsets.only(right: 20),
      );
    }
    return retWidget;
  }
}
