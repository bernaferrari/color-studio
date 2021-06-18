import 'package:flutter/material.dart';

class WidgetWithSelector extends StatelessWidget {
  const WidgetWithSelector({
    required this.child,
    required this.selector,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final Widget? selector;

  @override
  Widget build(BuildContext context) {
    if (selector == null) {
      return wrapInCard(child: child);
    }

    return Column(
      children: <Widget>[Expanded(child: wrapInCard(child: child)), selector!],
    );
  }
}

Widget wrapInCard({required Widget child}) {
  return ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 850),
    child: Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      clipBehavior: Clip.antiAlias,
      child: child,
    ),
  );
}
