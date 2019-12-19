import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hsluv/hsluvcolor.dart';

import 'single_slider.dart';

class HSLuvSlider extends StatefulWidget {
  const HSLuvSlider({Key key, this.color, this.onChanged}) : super(key: key);

  final Function(double, double, double) onChanged;
  final HSLuvColor color;

  @override
  _HSLuvSliderState createState() => _HSLuvSliderState();
}

class _HSLuvSliderState extends State<HSLuvSlider> {
  double valueH = 0.0;
  double valueS = 0.0;
  double valueL = 0.0;

  List<Color> colorH;
  List<Color> colorS;
  List<Color> colorL;

  void updateColorLists() {
    final vh = valueH;
    final vs = valueS;
    final vl = valueL;

    colorH = [
      HSLuvColor.fromHSL(0, vs, vl).toColor(),
      HSLuvColor.fromHSL(60, vs, vl).toColor(),
      HSLuvColor.fromHSL(120, vs, vl).toColor(),
      HSLuvColor.fromHSL(180, vs, vl).toColor(),
      HSLuvColor.fromHSL(240, vs, vl).toColor(),
      HSLuvColor.fromHSL(300, vs, vl).toColor(),
      HSLuvColor.fromHSL(360, vs, vl).toColor(),
    ];
    colorS = [
      HSLuvColor.fromHSL(vh, 0.0, vl).toColor(),
      HSLuvColor.fromHSL(vh, 100.0, vl).toColor(),
    ];
    colorL = [
      HSLuvColor.fromHSL(vh, vs, 0).toColor(),
      HSLuvColor.fromHSL(vh, vs, 50).toColor(),
      HSLuvColor.fromHSL(vh, vs, 100).toColor(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final hsl = widget.color;

    valueH = hsl.hue;
    valueS = hsl.saturation;
    valueL = hsl.lightness;
    updateColorLists();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // when max value is 360, it occasionally jumps to 0 because of
        // its own nature. Keeping <= 359 should be unnoticeable.
        // The math.min will avoid 360 / 359 situations where value will be >= 1.0.
        SingleSlider(
            "Hue", math.min(valueH / 359, 1.0), "${valueH.round()}", colorH,
            (double value) {
          setState(() {
            valueH = value * 359;
            updateColorLists();
            widget.onChanged(valueH, valueS, valueL);
          });
        }),
        SingleSlider("Saturation", valueS / 100, "${valueS.round()}", colorS,
            (double value) {
          setState(() {
            valueS = value * 100;
            updateColorLists();
            widget.onChanged(valueH, valueS, valueL);
          });
        }),
        SingleSlider("Lightness", valueL / 100, "${valueL.round()}", colorL,
            (double value) {
          setState(() {
            valueL = value * 100;
            updateColorLists();
            widget.onChanged(valueH, valueS, valueL);
          });
        }),
      ],
    );
  }
}
