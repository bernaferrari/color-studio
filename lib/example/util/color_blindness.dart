// https://github.com/jordidekock/Colorblinds

import 'dart:ui';

/// Type of color blindness.
///
/// - Deuteranomaly: Malfunctioning M-cone (green).
/// - Deuteranopia: Missing. M-cone (green).
/// - Protanomaly: Malfunctioning L-cone (red).
/// - Protanopia: Missing L-cone (red).

Color deuteranomaly(Color color) {
  final double r = (color.red * 0.80) + (color.green * 0.20) + (color.blue * 0);
  final double g =
      (color.red * 0.25833) + (color.green * 0.74167) + (color.blue * 0);
  final double b =
      (color.red * 0.0) + (color.green * 0.14167) + (color.blue * 0.85833);

  return Color.fromARGB(255, r.round(), g.round(), b.round());
}

Color protanopia(Color color) {
  final double r =
      (color.red * 0.56667) + (color.green * 0.43333) + (color.blue * 0);
  final double g =
      (color.red * 0.55833) + (color.green * 0.44167) + (color.blue * 0);
  final double b =
      (color.red * 0.0) + (color.green * 0.24167) + (color.blue * 0.75833);

  return Color.fromARGB(255, r.round(), g.round(), b.round());
}

Color deuteranopia(Color color) {
  final double r =
      (color.red * 0.625) + (color.green * 0.375) + (color.blue * 0);
  final double g = (color.red * 0.7) + (color.green * 0.3) + (color.blue * 0);
  final double b = (color.red * 0.0) + (color.green * 0.3) + (color.blue * 0.7);

  return Color.fromARGB(255, r.round(), g.round(), b.round());
}

Color protanomaly(Color color) {
  final double r =
      (color.red * 0.81667) + (color.green * 0.18333) + (color.blue * 0);
  final double g =
      (color.red * 0.33333) + (color.green * 0.66667) + (color.blue * 0);
  final double b =
      (color.red * 0.0) + (color.green * 0.125) + (color.blue * 0.875);

  return Color.fromARGB(255, r.round(), g.round(), b.round());
}

Color tritanopia(Color color) {
  final double r = (color.red * 0.95) + (color.green * 0.05) + (color.blue * 0);
  final double g =
      (color.red * 0.0) + (color.green * 0.43) + (color.blue * 0.56);
  final double b =
      (color.red * 0.0) + (color.green * 0.4755) + (color.blue * 0.525);

  return Color.fromARGB(255, r.round(), g.round(), b.round());
}

Color tritanomaly(Color color) {
  final double r =
      (color.red * 0.9667) + (color.green * 0.033) + (color.blue * 0);
  final double g =
      (color.red * 0.0) + (color.green * 0.733) + (color.blue * 0.2667);
  final double b =
      (color.red * 0.0) + (color.green * 0.183) + (color.blue * 0.8167);

  return Color.fromARGB(255, r.round(), g.round(), b.round());
}

Color achromatomaly(Color color) {
  final double r =
      (color.red * 0.618) + (color.green * 0.32) + (color.blue * 0.062);
  final double g =
      (color.red * 0.163) + (color.green * 0.775) + (color.blue * 0.062);
  final double b =
      (color.red * 0.163) + (color.green * 0.32) + (color.blue * 0.516);

  return Color.fromARGB(255, r.round(), g.round(), b.round());
}

Color achromatopsia(Color color) {
  final double r =
      (color.red * 0.299) + (color.green * 0.587) + (color.blue * 0.114);
  final double g =
      (color.red * 0.299) + (color.green * 0.587) + (color.blue * 0.114);
  final double b =
      (color.red * 0.299) + (color.green * 0.587) + (color.blue * 0.114);

  return Color.fromARGB(255, r.round(), g.round(), b.round());
}
