import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'single_slider.dart';

class HSLSlider extends StatefulWidget {
  const HSLSlider({Key key, this.color, this.onChanged}) : super(key: key);

  final Function(double, double, double) onChanged;
  final HSLColor color;

  @override
  _HSLSliderState createState() => _HSLSliderState();
}

class _HSLSliderState extends State<HSLSlider> {
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
      HSLColor.fromAHSL(1, 0, vs, vl).toColor(),
      HSLColor.fromAHSL(1, 60, vs, vl).toColor(),
      HSLColor.fromAHSL(1, 120, vs, vl).toColor(),
      HSLColor.fromAHSL(1, 180, vs, vl).toColor(),
      HSLColor.fromAHSL(1, 240, vs, vl).toColor(),
      HSLColor.fromAHSL(1, 300, vs, vl).toColor(),
      HSLColor.fromAHSL(1, 360, vs, vl).toColor(),
    ];
    colorS = [
      HSLColor.fromAHSL(1, vh, 0, vl).toColor(),
      HSLColor.fromAHSL(1, vh, 1.0, vl).toColor(),
    ];
    colorL = [
      HSLColor.fromAHSL(1, vh, vs, 0).toColor(),
      HSLColor.fromAHSL(1, vh, vs, 0.5).toColor(),
      HSLColor.fromAHSL(1, vh, vs, 1).toColor(),
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
        SingleSlider("Hue", valueH / 360, "${valueH.round()}", colorH,
            (double value) {
          setState(() {
            valueH = value * 360;
            updateColorLists();
            widget.onChanged(valueH, valueS, valueL);
          });
        }),
        SingleSlider("Saturation", valueS, "${(valueS * 100).round()}", colorS,
            (double value) {
          setState(() {
            valueS = value;
            updateColorLists();
            widget.onChanged(valueH, valueS, valueL);
          });
        }),
        SingleSlider("Lightness", valueL, "${(valueL * 100).round()}", colorL,
            (double value) {
          setState(() {
            valueL = value;
            updateColorLists();
            widget.onChanged(valueH, valueS, valueL);
          });
        }),
      ],
    );
  }
}
