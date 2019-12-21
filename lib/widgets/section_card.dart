import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({this.child, this.color});

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.30),
          width: 1,
        ),
      ),
      color: color,
      child: child,
    );
  }
}
