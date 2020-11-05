import 'dart:math';

import 'package:colorstudio/blocs/blocs.dart';
import 'package:colorstudio/example/util/calculate_contrast.dart';
import 'package:colorstudio/example/util/color_util.dart';
import 'package:colorstudio/example/util/constants.dart';
import 'package:colorstudio/example/util/when.dart';
import 'package:colorstudio/example/vertical_picker/app_bar_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hsluv/hsluvcolor.dart';

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
    // final surface = luv.lightness >= kLightnessThreshold
    //     ? Colors.black.withOpacity(0.20)
    //     : Colors.white.withOpacity(0.20);

    // final scheme = luv.lightness >= kLightnessThreshold
    //     ? ColorScheme.light(primary: color, surface: surface)
    //     : ColorScheme.dark(primary: color, surface: surface);

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
      color: rgbColorWithBlindness,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 8),
          TopRow(rgbColor, selected),
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
          SizedBox(height: 8),
//                if (isBlindnessOn) ...[
//                  SizedBox(height: 4),
//                  Text(
//                    "color blindness is on",
//                    style: Theme.of(context).textTheme.caption.copyWith(
//                          color: scheme.onSurface.withOpacity(0.70),
//                        ),
//                  ),
//                ],
          SizedBox(height: 8),
//                  NearestColor(color: color),
        ],
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
          children: <Widget>[
            SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ColorSearchButton(
                color: color,
                selected: selected,
              ),
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
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            SizedBox(width: 8),
            Container(
              height: 36,
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "${contrastBlack.toStringAsPrecision(3)}$blackLetter",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            if (largeScreen) ...[
              SizedBox(width: 8),
              OutlinedIconButton(
                child: Icon(Icons.shuffle_rounded, size: 16),
                onPressed: () {
                  final rng = Random();

                  BlocProvider.of<MdcSelectedBloc>(context).add(
                    MDCLoadEvent(
                      currentColor: Color.fromARGB(
                        255,
                        rng.nextInt(256),
                        rng.nextInt(256),
                        rng.nextInt(256),
                      ),
                      selected: selected,
                    ),
                  );
                },
              ),
            ] else
              SizedBox(width: 8),
            SizedBox(width: 24),
          ],
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
