import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  SearchWidget({key, required TextEditingController controller})
      : super(key: key) {
    _controller = controller;
  }
  late final TextEditingController _controller;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
          controller: _controller,
          autocorrect: false,
          enableSuggestions: false,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            prefixIcon: const Icon(Icons.search),
            filled: false,
            fillColor: Colors.grey[100],
          )),
    );
  }
}
