import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:colorstudio/example/screens/single_color_blindness.dart';
import 'package:colorstudio/example/util/when.dart';

import '../../util/color_blindness.dart';

ColorWithBlind getColorBlindFromIndex(Color color, int i) {
  const m = "of males";
  const f = "of females";
  const p = "of population";

  return when({
    () => i == 0: () => null,
    () => i == 1: () =>
        ColorWithBlind(protanomaly(color), "Protanomaly", "1% $m, 0.01% $f"),
    () => i == 2: () =>
        ColorWithBlind(deuteranomaly(color), "Deuteranomaly", "6% $m, 0.4% $f"),
    () => i == 3: () =>
        ColorWithBlind(tritanomaly(color), "Tritanomaly", "0.01% $p"),
    () => i == 4: () =>
        ColorWithBlind(protanopia(color), "Protanopia", "1% $m"),
    () => i == 5: () =>
        ColorWithBlind(deuteranopia(color), "Deuteranopia", "1% $m"),
    () => i == 6: () =>
        ColorWithBlind(tritanopia(color), "Tritanopia", "less than 1% $p"),
    () => i == 7: () =>
        ColorWithBlind(achromatopsia(color), "Achromatopsia", "0.003% $p"),
    () => i == 8: () =>
        ColorWithBlind(achromatomaly(color), "Achromatomaly", "0.001% $p"),
  });
}
