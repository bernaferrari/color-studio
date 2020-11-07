import 'package:flutter/widgets.dart';

List<Widget> spaceRow(double gap, Iterable<Widget> children) => children
    .expand((item) sync* {
      yield SizedBox(width: gap);
      yield item;
    })
    .skip(1)
    .toList();

List<Widget> spaceColumn(double gap, Iterable<Widget> children) => children
    .expand((item) sync* {
      yield SizedBox(height: gap);
      yield item;
    })
    .skip(1)
    .toList();
