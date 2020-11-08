import 'package:flutter/material.dart';

import '../color_with_inter.dart';
import '../hsinter.dart';
import '../util/hsinter_tiny.dart';
import 'vertical_picker_main.dart';

class HSVSelector extends StatelessWidget {
  const HSVSelector({this.color, this.moreColors = false});

  // initial color
  final Color color;

  final bool moreColors;

  @override
  Widget build(BuildContext context) {
    // maximum number of items
    final int itemsOnScreen =
        ((MediaQuery.of(context).size.height - 56 * 4) / 56).ceil();

    final int toneSize = moreColors ? itemsOnScreen * 2 : itemsOnScreen;
    final int hueSize = moreColors ? 90 : 45;

    const HSInterType kind = HSInterType.HSV;
    final HSInterColor inter = HSInterColor.fromColor(color, kind);

    return HSGenericScreen(
      color: inter,
      kind: kind,
      fetchHue: () =>
          hsinterAlternatives(inter, hueSize).convertToColorWithInter(),
      fetchSat: () =>
          hsinterTones(inter, toneSize, 0.0, 1.0).convertToColorWithInter(),
      fetchLight: () =>
          hsinterLightness(inter, toneSize, 0.0, 1.0).convertToColorWithInter(),
      hueTitle: hueStr,
      satTitle: satStr,
      lightTitle: valueStr,
      toneSize: toneSize,
    );
  }
}
