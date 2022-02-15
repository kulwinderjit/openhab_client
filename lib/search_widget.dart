import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  SearchWidget({key, required TextEditingController controller})
      : super(key: key) {
    _controller = controller;
  }
  late final TextEditingController _controller;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: TextField(
            style: theme.textTheme.subtitle1,
            controller: _controller,
            autocorrect: false,
            enableSuggestions: false,
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                contentPadding: EdgeInsets.all(0))),
      ),
    );
  }
}
