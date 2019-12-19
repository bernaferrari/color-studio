import 'package:flutter/material.dart';

extension on Color {
  List<double> toRGBList() {
    return [red / 255, green / 255, blue / 255];
  }
}

extension on List<double> {
  Color toColor() {
    return Color.fromARGB(255, (this[0] * 255).toInt(), (this[1] * 255).toInt(),
        (this[2] * 255).toInt());
  }
}

List<Color> hsvAlternatives(Color color, [int n = 6]) {
  final HSVColor hsv = HSVColor.fromColor(color);
  final int div = (360 / n).round();
  // in the original, code it is: luv.hue + (div * n) % 360
  // this was modified to ignore luv.hue value because the
  // list that is observing would miss the current position every time
  // the color changes.
  return [for (; n > 0; n--) hsv.withHue((div * n) % 360.0).toColor()];
}

List<Color> hsvTones(Color color,
    [int size, double start = 0.05, double stop = 1.0]) {
  final HSVColor hsv = HSVColor.fromColor(color);
  final step = (stop - start) / (size - 1);

  return [
    // this is the only way I found to make it work, from e.g. 95 to 5, inclusive.
    for (int n = size - 1; n >= 0; n -= 1)
      hsv.withSaturation(n * step + start).toColor()
  ];
}

List<Color> hsvValues(Color color,
    [int size, double start = 0.05, double stop = 0.95]) {
  final HSVColor hsv = HSVColor.fromColor(color);
  final step = (stop - start) / (size - 1);

  return [
    // (n = size; n > 0) won't work because n * step will be wrong. Unless you
    // you use (n-1) * step, but then it is an extra calculation per operation.
    for (int n = size - 1; n >= 0; n -= 1)
      hsv.withValue(n * step + start).toColor()
  ];
}
