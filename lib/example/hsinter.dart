import 'dart:math' as math;
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hsluv/hsluvcolor.dart';

enum HSInterType {
  HSLuv,
  HSV,
}

/// HSInterColor means Hue Saturation Interchangeable Color.
/// It is made to wrap both HSV and HSLuv with the same interface.
/// It could also be easily extended to HSL and others.
@immutable
class HSInterColor extends Equatable {
  /// Creates a [HSInterColor].
  const HSInterColor.fromHSInter(
    this.hue,
    this.saturation,
    this.lightness,
    this.kind,
    this.maxValue,
  );

  /// Creates an [HSInterColor] from an RGB [Color].
  ///
  /// This constructor does not necessarily round-trip with [toColor] because
  /// of floating-point imprecision.
  factory HSInterColor.fromColor(Color color, HSInterType kind) {
    late final double maxV;

    switch (kind) {
      case HSInterType.HSLuv:
        maxV = 100.0;
        break;
      case HSInterType.HSV:
        maxV = 1.0;
        break;
    }

    if (kind == HSInterType.HSLuv) {
      final luv = HSLuvColor.fromColor(color);
      return HSInterColor.fromHSInter(
          luv.hue, luv.saturation, luv.lightness, kind, maxV);
    } else if (kind == HSInterType.HSV) {
      final hsv = HSVColor.fromColor(color);
      return HSInterColor.fromHSInter(
          hsv.hue, hsv.saturation, hsv.value, kind, maxV);
    } else {
      final hsv = HSVColor.fromColor(color);
      return HSInterColor.fromHSInter(
          hsv.hue, hsv.saturation, hsv.value, kind, maxV);
    }
  }

  factory HSInterColor.fromHSLuv(HSLuvColor hsLuvColor) {
    const double maxV = 100.0;

    return HSInterColor.fromHSInter(
      hsLuvColor.hue,
      hsLuvColor.saturation,
      hsLuvColor.lightness,
      HSInterType.HSLuv,
      maxV,
    );
  }

  final HSInterType kind;
  final double hue;
  final double saturation;
  final double lightness;

  /// [maxValue] is 100.0 for HSLuv and 1.0 for HSV.
  /// They use different scales, so this is necessary.
  final double maxValue;

  /// output [saturation] in [0-100] interval.
  int outputSaturation() {
    switch (kind) {
      case HSInterType.HSLuv:
        return saturation.toInt();
      case HSInterType.HSV:
        return (saturation * 100).toInt();
    }
  }

  /// output [lightness] in [0-100] interval.
  int outputLightness() {
    switch (kind) {
      case HSInterType.HSLuv:
        return lightness.toInt();
      case HSInterType.HSV:
        return (lightness * 100).toInt();
    }
  }

  /// Returns a copy of this color with the [hue] parameter replaced with the
  /// given value.
  HSInterColor withHue(double hue) {
    return HSInterColor.fromHSInter(hue, saturation, lightness, kind, maxValue);
  }

  /// Returns a copy of this color with the [saturation] parameter replaced with
  /// the given value.
  HSInterColor withSaturation(double saturation) {
    return HSInterColor.fromHSInter(
        hue, math.min(saturation, maxValue), lightness, kind, maxValue);
  }

  /// Returns a copy of this color with the [lightness] parameter replaced with
  /// the given value.
  HSInterColor withLightness(double lightness) {
    return HSInterColor.fromHSInter(
        hue, saturation, math.min(lightness, maxValue), kind, maxValue);
  }

  /// Returns this color in RGB.
  /// Calls the [toColor] method from either HSLuvColor or HSVColor.
  Color toColor() {
    switch (kind) {
      case HSInterType.HSLuv:
        return HSLuvColor.fromHSL(hue, saturation, lightness).toColor();
      case HSInterType.HSV:
        return HSVColor.fromAHSV(1.0, hue, saturation, lightness).toColor();
    }
  }

  @override
  List<Object> get props => [hue, saturation, lightness];

  /// Returns this color as a String in the H:250 S:100 L:60 format.
  @override
  String toString() {
    final String valueLetter = kind == HSInterType.HSLuv ? "L" : "V";

    // this is never reached, but is needed for dart analyzer.
    return "H:${hue.toInt()} S:${outputSaturation()} $valueLetter:${outputLightness()}";
  }

  String toPartialStr(int index) {
    final String valueLetter = kind == HSInterType.HSLuv ? "L" : "V";

    switch (index) {
      case 0:
        return "H:${hue.toInt()}";
      case 1:
        return "S:${outputSaturation()}";
      case 2:
        return "$valueLetter:${outputLightness()}";
      default:
        return "error in toPartialStr";
    }
  }
}
