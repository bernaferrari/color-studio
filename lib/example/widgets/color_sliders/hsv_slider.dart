import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'single_slider.dart';

class HSVSlider extends StatefulWidget {
  const HSVSlider({Key key, this.color, this.onChanged}) : super(key: key);

  final Function(double, double, double) onChanged;
  final HSVColor color;

  @override
  _HSVSliderState createState() => _HSVSliderState();
}

class _HSVSliderState extends State<HSVSlider> {
  double valueH = 0.0;
  double valueS = 0.0;
  double valueB = 0.0;

  List<Color> colorH;
  List<Color> colorS;
  List<Color> colorB;

  void updateColorLists() {
    final vh = valueH;
    final vs = valueS;
    final vb = valueB;

    colorH = [
      HSVColor.fromAHSV(1, 0, vs, vb).toColor(),
      HSVColor.fromAHSV(1, 60, vs, vb).toColor(),
      HSVColor.fromAHSV(1, 120, vs, vb).toColor(),
      HSVColor.fromAHSV(1, 180, vs, vb).toColor(),
      HSVColor.fromAHSV(1, 240, vs, vb).toColor(),
      HSVColor.fromAHSV(1, 300, vs, vb).toColor(),
      HSVColor.fromAHSV(1, 360, vs, vb).toColor(),
    ];
    colorS = [
      HSVColor.fromAHSV(1, vh, 0, vb).toColor(),
      HSVColor.fromAHSV(1, vh, 1.0, vb).toColor(),
    ];
    colorB = [
      HSVColor.fromAHSV(1, vh, vs, 0).toColor(),
      HSVColor.fromAHSV(1, vh, vs, 1).toColor(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final hsv = widget.color;

    valueH = hsv.hue;
    valueS = hsv.saturation;
    valueB = hsv.value;
    updateColorLists();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SingleSlider("Hue", valueH / 360, "${valueH.round()}", colorH,
            (double value) {
          setState(() {
            valueH = value * 360;
            updateColorLists();
            widget.onChanged(valueH, valueS, valueB);
          });
        }),
        SingleSlider("Saturation", valueS, "${(valueS * 100).round()}", colorS,
            (double value) {
          setState(() {
            valueS = value;
            updateColorLists();
            widget.onChanged(valueH, valueS, valueB);
          });
        }),
        SingleSlider("Value", valueB, "${(valueB * 100).round()}", colorB,
            (double value) {
          setState(() {
            valueB = value;
            updateColorLists();
            widget.onChanged(valueH, valueS, valueB);
          });
        }),
      ],
    );
  }
}
