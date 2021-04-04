import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'gradients_json.dart';

class GradientScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final flutterGradients =
        gradientsJson.map((e) => Map<String, dynamic>.from(e)).toList();

    for (var element in flutterGradients) {
      element['colors'] = (element['colors'] as List<String>)
          .map((e) => Color(int.parse("0xFF${e.substring(1)}")))
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("uiGradients"),
      ),
      body: Row(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverGrid.count(
                  crossAxisCount: 3,
                  childAspectRatio: 1.2,
                  children: flutterGradients
                      .map(
                        (element) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: element['colors'],
                              ),
                            ),
                            child: Center(
                              child: Text(
                                element['name'],
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 180,
                child: LayoutBuilder(
                  builder: (context, constraints) =>
                      InteractiveGradient(constraints),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InteractiveGradient extends StatefulWidget {
  final BoxConstraints constraints;

  const InteractiveGradient(this.constraints);

  @override
  _InteractiveGradientState createState() => _InteractiveGradientState();
}

class _InteractiveGradientState extends State<InteractiveGradient> {
  late double x1;
  late double y1;

  late double x2;
  late double y2;

  double angle = 2;

  double wLine = 10;

  @override
  void initState() {
    super.initState();

    x1 = 24;
    y1 = 24;

    x2 = widget.constraints.maxWidth / 2 - 48;
    y2 = widget.constraints.maxHeight / 2 - 48;
  }

  void onMove(PointerMoveEvent event) {
    setState(() {
      if (event.delta.dx != 0) {
        x1 += event.delta.dx;
        x1 = xCornerDetection(x1);
      }
      if (event.delta.dy != 0) {
        y1 += event.delta.dy;
        y1 = yCornerDetection(y1);
      }

      // y2 - y1;
      wLine = math.sqrt(math.pow(x2 - x1, 2) + math.pow(y2 - y1, 2));
      angle = math.atan((y2 - y1) / (x2 - x1));

      print("x1: $x1 y1: $y1 line: $wLine x2: $x2 y2: $y2 angle: ${angle}");
    });
  }

  double xCornerDetection(double x) {
    if (x < 0) {
      x = 0;
    }
    if (x > widget.constraints.maxWidth - 24) {
      x = widget.constraints.maxWidth - 24;
    }

    return x;
  }

  double yCornerDetection(double y) {
    if (y < 0) {
      y = 0;
    }
    if (y > widget.constraints.maxHeight - 24) {
      y = widget.constraints.maxHeight - 24;
    }

    return y;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        print("POINTER DOWNNNN ");
      },
      onPointerMove: onMove,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.red, Colors.green],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: x1,
              top: y1,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                width: 24,
                height: 24,
              ),
            ),
            Positioned(
              left: x1 - math.cos(angle) * wLine / 2,
              top: y1 + (y2 - y1 - 4) / 2 + 12,
              child: Transform.rotate(
                angle: angle,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  width: wLine,
                  height: 4,
                ),
              ),
            ),
            Positioned(
              left: x2,
              top: y2,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                width: 24,
                height: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
