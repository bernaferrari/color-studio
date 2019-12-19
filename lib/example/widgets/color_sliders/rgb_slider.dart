import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'single_slider.dart';

class RGBSlider extends StatefulWidget {
  const RGBSlider({Key key, this.color, this.onChanged}) : super(key: key);

  final Function(int, int, int) onChanged;
  final Color color;

  @override
  _RGBSliderState createState() => _RGBSliderState();
}

extension on int {
  String convertToHexString() => toRadixString(16).padLeft(2, '0');
}

class _RGBSliderState extends State<RGBSlider> {
  int valueRed = 0;
  int valueBlue = 0;
  int valueGreen = 0;

  List<Color> colorRed;
  List<Color> colorGreen;
  List<Color> colorBlue;

  void updateColorLists() {
    final vg = valueGreen.convertToHexString();
    final vr = valueRed.convertToHexString();
    final vb = valueBlue.convertToHexString();

    colorRed = [
      Color(int.parse("0xFF00$vg$vb")),
      Color(int.parse("0xFFFF$vg$vb")),
    ];
    colorGreen = [
      Color(int.parse("0xFF${vr}00$vb")),
      Color(int.parse("0xFF${vr}FF$vb")),
    ];
    colorBlue = [
      Color(int.parse("0xFF$vr${vg}00")),
      Color(int.parse("0xFF$vr${vg}FF")),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color;
    valueRed = color.red;
    valueGreen = color.green;
    valueBlue = color.blue;

    updateColorLists();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SingleSlider("Red", valueRed / 255, "$valueRed", colorRed,
            (double value) {
          setState(() {
            valueRed = (value * 255).round();
            updateColorLists();
            widget.onChanged(valueRed, valueGreen, valueBlue);
          });
        }),
        SingleSlider("Green", valueGreen / 255, "$valueGreen", colorGreen,
            (double value) {
          setState(() {
            valueGreen = (value * 255).round();
            updateColorLists();
            widget.onChanged(valueRed, valueGreen, valueBlue);
          });
        }),
        SingleSlider("Blue", valueBlue / 255, "$valueBlue", colorBlue,
            (double value) {
          setState(() {
            valueBlue = (value * 255).round();
            updateColorLists();
            widget.onChanged(valueRed, valueGreen, valueBlue);
          });
        }),
      ],
    );
  }
}
