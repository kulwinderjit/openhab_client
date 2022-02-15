import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

class ThemeChoser extends StatelessWidget {
  const ThemeChoser(
      {Key? key, required this.currentSheme, required this.onSelect})
      : super(key: key);
  final FlexScheme currentSheme;
  final Function(FlexScheme) onSelect;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return PopupMenuButton<FlexScheme>(
        onSelected: (scheme) => onSelect(scheme),
        initialValue: currentSheme,
        child: AbsorbPointer(
          absorbing: true,
          child: ElevatedButton(
            onPressed: null,
            child: Text(
              currentSheme.name.capitalize,
              style: theme.textTheme.subtitle1,
            ),
          ),
        ),
        itemBuilder: (BuildContext context) {
          return FlexScheme.values
              .where((value) => value.name != 'custom')
              .map((e) => PopupMenuItem<FlexScheme>(
                  value: e, child: Text(e.name.capitalize)))
              .toList();
        });
  }
}
