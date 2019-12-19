import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class NearestColor extends StatelessWidget {
  const NearestColor({this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: FutureBuilder(
        future: DefaultAssetBundle.of(context)
            .loadString("assets/colornames.json")
            .then((onValue) => getNearest(onValue)),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox.shrink();
          }
          return Text(
            (snapshot.data as NamedColor).name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.caption.copyWith(),
          );
        },
      ),
    );
  }

  NamedColor getNearest(String data) {
    // this might be a heavy operation, therefore it is good to be run in a Future.
    final List<dynamic> newData = json.decode(data);
    final List<NamedColor> colorsList = newData.map((dynamic f) {
      return NamedColor(
        name: f["name"],
        color: Color(int.parse("0xFF${f["hex"].substring(1)}")),
      );
    }).toList();

    final nearest = nearestColor(color, colorsList);
    return nearest;
  }
}

class AnimatedText extends StatefulWidget {
  const AnimatedText(this.text);

  final String text;

  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText> {
  double opacity = 0.0;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        opacity = 1.0;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: opacity,
      curve: Curves.easeInOutSine,
      child: Text(
        widget.text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.caption.copyWith(),
      ),
    );
  }
}

class NamedColor {
  const NamedColor({this.name, this.color});

  final String name;
  final Color color;

  @override
  String toString() => "$runtimeType $name |$color";
}

/// Converted from https://github.com/dtao/nearest-color
/// Gets the nearest color, from the given list of [NamedColor] objects
NamedColor nearestColor(Color needle, List<NamedColor> colors) {
  double distanceSq;
  double minDistanceSq = double.infinity;
  Color rgb;
  NamedColor value;

  for (int i = 0; i < colors.length; ++i) {
    rgb = colors[i].color;

    distanceSq = math.pow(needle.red - rgb.red, 2.0) +
        math.pow(needle.green - rgb.green, 2.0) +
        math.pow(needle.blue - rgb.blue, 2.0);

    if (distanceSq < minDistanceSq) {
      minDistanceSq = distanceSq;
      value = colors[i];
    }
  }

  return value;
}
