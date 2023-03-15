import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hsluv/hsluvcolor.dart';

import 'color_util.dart';

// converted from TinyColor
// https://github.com/bgrins/TinyColor

// Modification Functions
// ----------------------
// Thanks to less.js for some of the basics here
// <https://github.com/cloudhead/less.js/blob/master/lib/less/functions.js>

Color desaturate(Color color, [int amount = 10]) {
  final HSLColor hsl = HSLColor.fromColor(color);

  var saturation = hsl.saturation;
  saturation -= amount / 100;
  saturation = clamp01(saturation);

  return hsl.withSaturation(saturation).toColor();
}

Color saturate(Color color, [int amount = 10]) {
  final HSLColor hsl = HSLColor.fromColor(color);

  var saturation = hsl.saturation;
  saturation += amount / 100;
  saturation = clamp01(saturation);

  return hsl.withSaturation(saturation).toColor();
}

Color greyscale(Color color) {
  return desaturate(color, 100);
}

Color lighten(Color color, [int amount = 10]) {
  final HSLColor hsl = HSLColor.fromColor(color);

  var lightness = hsl.lightness;
  lightness += amount / 100;
  lightness = clamp01(lightness);

  return hsl.withSaturation(lightness).toColor();
}

Color brighten(Color rgb, [int amount = 10]) {
  final int change = (255 * -(amount / 100)).round();

  final r = max(0, min(255, rgb.red - change));
  final g = max(0, min(255, rgb.green - change));
  final b = max(0, min(255, rgb.blue - change));

  return Color.fromARGB(255, r, g, b);
}

Color darken(Color color, [int amount = 10]) {
  final HSLColor hsl = HSLColor.fromColor(color);

  var lightness = hsl.lightness;
  lightness -= amount / 100;
  lightness = clamp01(lightness);

  return hsl.withSaturation(lightness).toColor();
}

// Spin takes a positive or negative amount within [-360, 360] indicating the change of hue.
// Values outside of this range will be wrapped into this range.
Color spin(Color color, [int amount = 180]) {
  final HSLColor hsl = HSLColor.fromColor(color);
  final hue = (hsl.hue + amount) % 360;
  return hsl.withSaturation((hue < 0) ? 360 + hue : hue).toColor();
}

// Force a number between 0 and 1
double clamp01(double value) {
  return min(1, max(0, value));
}

// Combination Functions
// ---------------------
// Thanks to jQuery xColor for some of the ideas behind these
// <https://github.com/infusion/jQuery-xcolor/blob/master/jquery.xcolor.js>
Color complement(Color color) {
  final HSLColor hsl = HSLColor.fromColor(color);
  return hsl.withHue((hsl.hue + 180) % 360).toColor();
}

List<Color> triad(Color color) {
  final HSLColor hsl = HSLColor.fromColor(color);
  final double hue = hsl.hue;
  return [
    color,
    hsl.withHue((hue + 120) % 360).toColor(),
    hsl.withHue((hue + 240) % 360).toColor(),
  ];
}

List<Color> tetrad(Color color) {
  final HSLColor hsl = HSLColor.fromColor(color);
  final double hue = hsl.hue;
  return [
    color,
    hsl.withHue((hue + 90) % 360).toColor(),
    hsl.withHue((hue + 180) % 360).toColor(),
    hsl.withHue((hue + 270) % 360).toColor(),
  ];
}

List<Color> nTrad(Color color, [int n = 6]) {
  final HSLColor hsl = HSLColor.fromColor(color);
  final double hue = hsl.hue;

  final int div = (360 / n).round();
  return [for (; n > 0; n--) hsl.withHue((hue + div * n) % 360).toColor()];
}

// get variation in Hue.
List<Color> hueVariations(Color color, [int n = 6]) {
  // HSLColor and HSVColor will always have the same hue.
  final HSLColor hsl = HSLColor.fromColor(color);

  final int div = (360 / n).round();
  // in the original, code it is: hsl.hue + (div * n) % 360
  // this was modified to ignore luv.hue value because the
  // list that is observing would miss the current position every time
  // the color changes.
  return [for (; n > 0; n--) hsl.withHue((div * n) % 360.0).toColor()];
}

// get variation in Hue.
List<Color> hsluvHueToneVariation(Color color,
    [int n = 6, double toneDiff = 0]) {
  // HSLColor and HSVColor will always have the same hue.
  final HSLuvColor hsluv = HSLuvColor.fromColor(color);

  final int div = (360 / n).round();
  // in the original, code it is: hsl.hue + (div * n) % 360
  // this was modified to ignore luv.hue value because the
  // list that is observing would miss the current position every time
  // the color changes.
  return [
    for (; n > 0; n--)
      hsluv
          .withHue((div * n) % 360.0)
          .withLightness(interval(hsluv.lightness + toneDiff, 5, 95))
          .toColor()
  ];
}

List<Color> tones(Color color,
    [int n = 6, double step = 0.15, double start = 0.1]) {
  final HSLColor hsl = HSLColor.fromColor(color);
  double sat = start;
  final List<Color> list = [];

  for (; n > 0; n--) {
    sat += step;
    if (sat > 1.0) {
      sat = 1.0;
    }

    list.add(hsl.withSaturation(sat).toColor());
  }

  return list;
}

List<Color> tonesHSV(Color color,
    [int n = 6, double step = 0.15, double start = 0.1]) {
  final HSVColor hsv = HSVColor.fromColor(color);
  double sat = start;
  final List<Color> list = [];

  for (; n > 0; n--) {
    sat += step;
    if (sat > 1.0) {
      sat = 1.0;
    }

    list.add(hsv.withSaturation(sat).toColor());
  }

  return list.reversed.toList();
}

List<Color> alternative(Color color, [int n = 6, double step = 10]) {
  final HSLColor hsl = HSLColor.fromColor(color);

  final halfN = (n / 2).round();

  return [
    ...[
      for (int i = halfN; i > 0; i--) // farther -> closer
        hsl.withHue((hsl.hue - step * i) % 360).toColor()
    ],
    ...[
      for (int i = 1; i <= halfN; i++) // closer -> farther
        hsl.withHue((hsl.hue + step * i) % 360).toColor()
    ],
  ];
}

List<Color> brightShade(Color color, [int n = 6, double step = 0.05]) {
  final HSLColor hsl = HSLColor.fromColor(color);
  double lightness = 1.0;
  final List<Color> list = [];

  for (; n > 0; n--) {
    lightness -= step;
    if (lightness < 0.0) {
      lightness = 0.0;
    }

    list.add(hsl.withLightness(lightness).toColor());
  }

  list.sort((a, b) => a.value.compareTo(b.value));
  return list;
}

List<Color> alphaBlendShades(Color fgColor, Color bgColor,
    [int n = 6, double step = 0.1]) {
  final List<Color> list = [];
  var stp = step;

  for (; n > 0; n--, stp += step) {
    if (stp > 1.0) stp = 1.0;
    list.add(Color.alphaBlend(fgColor.withOpacity(stp), bgColor));
  }

  list.sort((a, b) => a.value.compareTo(b.value));
  return list;
}

List<Color> darkShade(Color color,
    [int n = 6, double step = 0.05, double start = 0.0]) {
  final HSLColor hsl = HSLColor.fromColor(color);
  double darkness = start;
  final List<Color> ret = [];

  for (; n > 0; n--) {
    darkness += step;
    if (darkness < 0.0) {
      darkness = 0.0;
    }

    ret.add(hsl.withLightness(darkness).toColor());
  }

  return ret;
}

List<Color> valueVariations(Color color,
    [int n = 6, double step = 0.05, double start = 0.0]) {
  final HSVColor hsv = HSVColor.fromColor(color);
  double darkness = start;
  final List<Color> ret = [];

  for (; n > 0; n--) {
    darkness += step;
    if (darkness > 1.0) {
      darkness = 1.0;
    }

    ret.add(hsv.withValue(darkness).toColor());
  }

  return ret.reversed.toList();
}

List<Color> analogous(Color color, [int results = 3, int slices = 6]) {
  final HSLColor hsl = HSLColor.fromColor(color);

  final int part = (360 / slices).round();
  final List<Color> ret = [color];
  double hue = ((hsl.hue - (part * results >> 1)) + 720) % 360;

  for (; results > 1; results--) {
    hue = (hue + part) % 360;
    ret.add(hsl.withHue(hue).toColor());
  }

  return ret;
}

List<Color> splitComplement(Color color) {
  final HSLColor hsl = HSLColor.fromColor(color);
  final double hue = hsl.hue;
  return [
    hsl.withHue((hue + 72) % 360).toColor(),
    hsl.withHue((hue + 144) % 360).toColor(),
    hsl.withHue((hue + 216) % 360).toColor(),
  ];
}

// Inspired from ColorHexa website.
List<Color> monoColorSteps(Color color, [int results = 6, double step = 0.05]) {
  final HSLColor hsl = HSLColor.fromColor(color);
  double tmpLightness = hsl.lightness;
  double tmpDarkness = hsl.lightness;
  final List<Color> list = [];
  int halfResult;

  for (halfResult = (results / 2).round(); halfResult > 0; halfResult--) {
    tmpLightness += step;
    if (tmpLightness > 1.0) {
      tmpLightness = 1.0;
    }

    list.add(hsl.withLightness(tmpLightness).toColor());
  }

  for (halfResult = (results / 2).round(); halfResult > 0; halfResult--) {
    tmpDarkness -= step;
    if (tmpDarkness < 0.0) {
      tmpDarkness = 0.0;
    }

    list.add(hsl.withLightness(tmpDarkness).toColor());
  }

  list.sort((a, b) => a.value.compareTo(b.value));
  return list;
}

List<Color> monochromatic(Color color, [int results = 6]) {
  final HSVColor hsv = HSVColor.fromColor(color);
  final double h = hsv.hue;
  final double s = hsv.saturation;
  double v = hsv.value;

  final List<Color> list = [];
  final double modification = 1.0 / results;

  for (; results > 0; results--) {
    list.add(HSVColor.fromAHSV(1.0, h, s, v).toColor());
    v = (v + modification) % 1;
  }

  list.sort((a, b) => a.value.compareTo(b.value));
  return list;
}

// Utility Functions
// ---------------------

Color mix(Color color1, Color color2, [int amount = 50]) {
  final rgb1 = color1;
  final rgb2 = color2;

  final p = amount / 100;

  return Color.fromARGB(
    ((rgb2.alpha - rgb1.alpha) * p).round() + rgb1.alpha,
    ((rgb2.red - rgb1.red) * p).round() + rgb1.red,
    ((rgb2.green - rgb1.green) * p).round() + rgb1.green,
    ((rgb2.blue - rgb1.blue) * p).round() + rgb1.blue,
  );
}

// Readability Functions
// ---------------------
// <http://www.w3.org/TR/2008/REC-WCAG20-20081211/#contrast-ratiodef (WCAG Version 2)

// `contrast`
// Analyze the 2 colors and returns the color contrast defined by (WCAG Version 2)
double readability(Color color1, Color color2) =>
    (max(color1.computeLuminance(), color2.computeLuminance()) + 0.05) /
    (min(color1.computeLuminance(), color2.computeLuminance()) + 0.05);
