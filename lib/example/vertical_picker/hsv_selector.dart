import 'package:colorstudio/example/color_with_inter.dart';
import 'package:colorstudio/example/hsinter.dart';
import 'package:colorstudio/example/util/hsinter_tiny.dart';
import 'package:flutter/material.dart';

import 'vertical_picker_main.dart';

class HSVSelector extends StatelessWidget {
  const HSVSelector({this.color, this.moreColors = false});

  // initial color
  final Color color;

  final bool moreColors;

  @override
  Widget build(BuildContext context) {
    const String kind = hsvStr;

    // maximum number of items
    final int itemsOnScreen =
        ((MediaQuery.of(context).size.height - 56 * 4) / 56).ceil();

    final int toneSize = moreColors ? itemsOnScreen * 2 : itemsOnScreen;
    final int hueSize = moreColors ? 90 : 45;

    final HSInterColor inter = HSInterColor.fromColor(color, kind);

    return HSGenericScreen(
      color: inter,
      kind: kind,
      fetchHue: () => hsinterLightness(inter, hueSize),
      fetchSat: (HSInterColor c) =>
          hsinterTones(c, toneSize, 0.05, 1.0).convertToColorWithInter(),
      fetchLight: (HSInterColor c) =>
          hsinterLightness(c, toneSize, 0.05, 1.0).convertToColorWithInter(),
      hueTitle: hueStr,
      satTitle: satStr,
      lightTitle: valueStr,
      toneSize: toneSize,
    );
  }
}
