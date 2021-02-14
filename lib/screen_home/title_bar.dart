import 'package:flutter/material.dart';

class TitleBar extends StatelessWidget {
  const TitleBar({this.title, this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline6.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ),
        ...children,
      ],
    );
  }
}
