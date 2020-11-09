import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hsluv/hsluvcolor.dart';

import '../../blocs/blocs.dart';
import '../../example/util/calculate_contrast.dart';
import '../../example/util/color_util.dart';
import '../../example/util/constants.dart';
import '../../example/util/when.dart';
import '../../shared_widgets/color_search_button.dart';
import '../../shared_widgets/outlined_icon_button.dart';
import '../../util/widget_space.dart';
import 'flat_color_picker.dart';

class SchemeExpandedItem extends StatelessWidget {
  const SchemeExpandedItem({
    Key key,
    this.selected,
    this.rgbColor,
    this.hsLuvColor,
    this.rgbColorWithBlindness,
  }) : super(key: key);

  final ColorType selected;
  final Color rgbColor;
  final Color rgbColorWithBlindness;
  final HSLuvColor hsLuvColor;

  @override
  Widget build(BuildContext context) {
    const valuesList = [-5, -1, 0, 1, 5];

    final listOfLists = [
      valuesList
          .map((i) => hsLuvColor.withHue((hsLuvColor.hue + i * 2) % 360))
          .toList(),
      valuesList
          .map((i) => hsLuvColor
              .withSaturation(interval(hsLuvColor.saturation + i, 0.0, 100.0)))
          .toList(),
      valuesList
          .map((i) => hsLuvColor
              .withLightness(interval(hsLuvColor.lightness + i, 0.0, 100.0)))
          .toList(),
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: spaceColumn(
          8.0,
          <Widget>[
            TopRow(rgbColorWithBlindness, selected),
            FlatColorPicker(
              kind: "Hue",
              selected: selected,
              colors: listOfLists[0],
            ),
            FlatColorPicker(
              kind: "Saturation",
              selected: selected,
              colors: listOfLists[1],
            ),
            FlatColorPicker(
              kind: "Lightness",
              selected: selected,
              colors: listOfLists[2],
            ),
//                  NearestColor(color: color),
          ],
        ),
      ),
    );
  }

  // this is necessary because of https://github.com/flutter/flutter/issues/11416
  void setTextAndPosition(TextEditingController controller, String newText,
      {int caretPosition}) {
    final int offset = caretPosition ?? newText.length;
    controller.value = controller.value.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: offset),
        composing: TextRange.empty);
  }
}

class TopRow extends StatelessWidget {
  const TopRow(this.color, this.selected);

  final Color color;
  final ColorType selected;

  @override
  Widget build(BuildContext context) {
    final contrastWhite = calculateContrast(color, Colors.white);
    final contrastBlack = calculateContrast(color, Colors.black);

    return LayoutBuilder(
      builder: (context, builder) {
        // if screen is not large, hide the button for detailed color screen.
        // that screen is optimized for larger sizes.
        final largeScreen = builder.maxWidth > 320;

        // if screen is tiny (like in split-view), hide the AA/AAA letters.
        final smallScreen = builder.maxWidth < 380;

        final whiteLetter =
            smallScreen ? "" : " ${getContrastLetters(contrastWhite)}";
        final blackLetter =
            smallScreen ? "" : " ${getContrastLetters(contrastBlack)}";

        return Row(
          children: spaceRow(
            8.0,
            <Widget>[
              ColorSearchButton(
                color: color,
                selected: selected,
              ),
              Expanded(
                child: SizedBox.shrink(),
              ),
              Container(
                height: 36,
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "${contrastWhite.toStringAsPrecision(3)}$whiteLetter",
                    style: TextStyle(color: color),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              Container(
                height: 36,
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "${contrastBlack.toStringAsPrecision(3)}$blackLetter",
                    style: TextStyle(color: color),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              if (largeScreen)
                OutlinedIconButton(
                  child: Icon(Icons.shuffle_rounded, size: 16),
                  onPressed: () {
                    final rng = Random();

                    final rgbColor = Color.fromARGB(
                      255,
                      rng.nextInt(256),
                      rng.nextInt(256),
                      rng.nextInt(256),
                    );

                    context
                        .read<ColorsCubit>()
                        .updateColor(rgbColor: rgbColor, selected: selected);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  String getContrastLetters(double contrast) {
    return when({
      () => contrast < 2.9: () => "fail",
      () => contrast < 4.5: () => "AA+",
      () => contrast < 7.0: () => "AA",
      () => contrast < 25: () => "AAA",
    });
  }
}
