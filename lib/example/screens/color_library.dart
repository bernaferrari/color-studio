import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:colorstudio/example/contrast/shuffle_color.dart';
import 'package:colorstudio/example/mdc/components.dart';
import 'package:colorstudio/example/util/constants.dart';
import 'package:colorstudio/example/util/selected.dart';
import 'package:colorstudio/example/widgets/update_color_dialog.dart';

import '../util/color_util.dart';

class ColorLibrary extends StatefulWidget {
  const ColorLibrary({this.color});

  final Color color;

  @override
  _ColorLibraryState createState() => _ColorLibraryState();
}

class _ColorLibraryState extends State<ColorLibrary> {
  int currentSegment = 0;

  void onValueChanged(int newValue) {
    setState(() {
      currentSegment = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorsList = getColorClaim();

    return Scaffold(
      backgroundColor: widget.color,
      appBar: AppBar(
        title: Text("Color Library"),
        backgroundColor: widget.color,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 818),
          child: Column(
            children: <Widget>[
//          CupertinoSlidingSegmentedControl<int>(
//            backgroundColor:
//                Theme.of(context).colorScheme.onSurface.withOpacity(0.20),
//            thumbColor: compositeColors(
//              Theme.of(context).colorScheme.background,
//              widget.color,
//              kVeryTransparent,
//            ),
//            children: const <int, Widget>{
//              0: Text('Hex'),
//              1: Text('RGB'),
//              2: Text('HSLuv'),
//              3: Text('HSV'),
//            },
//            onValueChanged: onValueChanged,
//            groupValue: currentSegment,
//          ),
              Expanded(
                child: Card(
                  color: Theme.of(context)
                      .colorScheme
                      .background
                      .withOpacity(kVeryTransparent),
                  elevation: 0,
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.40))),
                  child: CustomScrollView(
                    key: const PageStorageKey("ColorLibrary"),
                    primary: false,
                    slivers: <Widget>[
                      SliverPadding(
                        padding: const EdgeInsets.all(20),
                        sliver: SliverGrid.count(
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          crossAxisCount: (math.min(
                                      MediaQuery.of(context).size.width, 818) /
                                  120)
                              .ceil(),
                          children: <Widget>[
                            for (int i = 0; i < colorsList.length; i++)
                              RawMaterialButton(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(kVeryTransparent),
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                                onPressed: () {
                                  colorSelected(context, colorsList[i]);
                                },
                                onLongPress: () {
                                  showSlidersDialog(context, colorsList[i]);
                                },
                                fillColor: colorsList[i],
                                padding: const EdgeInsets.all(8),
                                child: Center(
                                  child: Text(
                                    colorsList[i].toHexStr(),
//                                when<String>({
//                                  () => currentSegment == 0: () =>
//                                      colorsList[i].toHexStr(),
//                                  () => currentSegment == 1: () =>
//                                      "R:${colorsList[i].red}\nG:${colorsList[i].green}\nB${colorsList[i].blue}",
//                                  () => currentSegment == 2: () =>
//                                      "H:${colorsList[i].red}\nS:${colorsList[i].green}\nV${colorsList[i].blue}",
//                                }),
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(
                                          fontFamily: "B612Mono",
                                          color: contrastingColor(colorsList[i])
                                              .withOpacity(0.70),
                                        ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
