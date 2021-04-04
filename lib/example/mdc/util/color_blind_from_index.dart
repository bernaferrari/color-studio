import 'package:color_blindness/color_blindness.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../screens/single_color_blindness.dart';

enum _ColorBlindnessTypes {
  None,
  Protanomaly,
  Deuteranomaly,
  Tritanomaly,
  Protanopia,
  Deuteranopia,
  Tritanopia,
  Achromatopsia,
  Achromatomaly
}

ColorWithBlind? getColorBlindFromIndex(Color color, int i) {
  const m = "of males";
  const f = "of females";
  const p = "of population";

  final type = _ColorBlindnessTypes.values[i];

  switch (type) {
    case _ColorBlindnessTypes.None:
      return null;
    case _ColorBlindnessTypes.Protanomaly:
      return ColorWithBlind(
          protanomaly(color), "Protanomaly", "1% $m, 0.01% $f");
    case _ColorBlindnessTypes.Deuteranomaly:
      return ColorWithBlind(
          deuteranomaly(color), "Deuteranomaly", "6% $m, 0.4% $f");
    case _ColorBlindnessTypes.Tritanomaly:
      return ColorWithBlind(tritanomaly(color), "Tritanomaly", "0.01% $p");
    case _ColorBlindnessTypes.Protanopia:
      return ColorWithBlind(protanopia(color), "Protanopia", "1% $m");
    case _ColorBlindnessTypes.Deuteranopia:
      return ColorWithBlind(deuteranopia(color), "Deuteranopia", "1% $m");
    case _ColorBlindnessTypes.Tritanopia:
      return ColorWithBlind(tritanopia(color), "Tritanopia", "less than 1% $p");
    case _ColorBlindnessTypes.Achromatopsia:
      return ColorWithBlind(achromatopsia(color), "Achromatopsia", "0.003% $p");
    case _ColorBlindnessTypes.Achromatomaly:
      return ColorWithBlind(achromatomaly(color), "Achromatomaly", "0.001% $p");
  }
}
