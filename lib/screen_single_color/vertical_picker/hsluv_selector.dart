import 'package:colorstudio/example/color_with_inter.dart';
import 'package:colorstudio/example/hsinter.dart';
import 'package:colorstudio/example/util/hsinter_tiny.dart';
import 'package:flutter/material.dart';
import 'package:hsluv/hsluvcolor.dart';

import '../../contrast_util.dart';
import 'vertical_picker_main.dart';

class HSLuvSelector extends StatelessWidget {
  const HSLuvSelector({this.color, this.moreColors = false});

  // initial color
  final HSLuvColor color;

  final bool moreColors;

  @override
  Widget build(BuildContext context) {
    const HSInterType kind = HSInterType.HSLuv;

    // maximum number of items
    final int itemsOnScreen =
        ((MediaQuery.of(context).size.height - 56 * 4) / 56).ceil();

    final int toneSize = moreColors ? itemsOnScreen * 2 : itemsOnScreen;
    final int hueSize = moreColors ? 90 : 45;

    final inter = HSInterColor.fromHSLuv(color);

    return HSGenericScreen(
      color: inter,
      kind: kind,
      fetchHue: () =>
          hsinterAlternatives(inter, hueSize).convertToColorWithInter(),
      fetchSat: () =>
          hsinterTones(inter, toneSize, 0, 100).convertToColorWithInter(),
      fetchLight: () =>
          hsinterLightness(inter, toneSize, 0, 100).convertToColorWithInter(),
      hueTitle: hueStr,
      satTitle: satStr,
      lightTitle: lightStr,
      toneSize: toneSize,
    );
  }
}
