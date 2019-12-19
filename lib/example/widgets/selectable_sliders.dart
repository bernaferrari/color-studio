import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SliderWithSelector extends StatefulWidget {
  const SliderWithSelector(
      this.sliders, this.color, this.selectableColor, this.context);

  final Color color;
  final Color selectableColor;
  final List<Widget> sliders;

  // this is necessary to save the selected position.
  // Flutter will discard the Dialog's context when Dialog closes.
  final BuildContext context;

  @override
  _SliderWithSelectorState createState() => _SliderWithSelectorState();
}

class _SliderWithSelectorState extends State<SliderWithSelector> {
  int currentSegment;

  final Map<int, Widget> children = const <int, Widget>{
    0: Text("RGB"),
    1: Text("HSLuv"),
    2: Text("HSV"),
  };

  @override
  void initState() {
    currentSegment = PageStorage.of(widget.context).readState(
          widget.context,
          identifier: const ValueKey("Selectable Sliders"),
        ) ??
        1;

    super.initState();
  }

  void onValueChanged(int newValue) {
    setState(() {
      currentSegment = newValue;
      PageStorage.of(widget.context).writeState(
        widget.context,
        currentSegment,
        identifier: const ValueKey("Selectable Sliders"),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CupertinoSlidingSegmentedControl<int>(
          children: children,
          backgroundColor:
              Theme.of(context).colorScheme.onSurface.withOpacity(0.20),
          thumbColor: widget.selectableColor,
          onValueChanged: onValueChanged,
          groupValue: currentSegment,
        ),
        Padding(
          // this is the right padding, so text don't get glued to the border.
          padding: const EdgeInsets.only(top: 8),
          child: widget.sliders[currentSegment],
        ),
      ],
    );
  }
}
