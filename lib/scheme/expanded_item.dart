import 'dart:math';

import 'package:colorstudio/example/blocs/blocs.dart';
import 'package:colorstudio/example/blocs/mdc_selected/mdc_selected_state.dart';
import 'package:colorstudio/example/contrast/inter_color_with_contrast.dart';
import 'package:colorstudio/example/util/color_util.dart';
import 'package:colorstudio/example/util/constants.dart';
import 'package:colorstudio/example/util/when.dart';
import 'package:colorstudio/example/vertical_picker/app_bar_actions.dart';
import 'package:colorstudio/scheme/flat_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class SchemeExpandedItem extends StatelessWidget {
  const SchemeExpandedItem({
    Key key,
    this.selected,
  }) : super(key: key);

  final String selected;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MdcSelectedBloc, MdcSelectedState>(
      builder: (context, state) {
        final color = (state as MDCLoadedState).rgbColors[selected];
        final luv = (state as MDCLoadedState).hsluvColors[selected];

        final surface = luv.lightness > kLightnessThreshold
            ? Colors.black.withOpacity(0.20)
            : Colors.white.withOpacity(0.20);

        final scheme = luv.lightness > kLightnessThreshold
            ? ColorScheme.light(primary: color, surface: surface)
            : ColorScheme.dark(primary: color, surface: surface);

        const valuesList = [-5, -1, 0, 1, 5];

        final listOfLists = [
          valuesList.map((i) => luv.withHue((luv.hue + i * 2) % 360)).toList(),
          valuesList
              .map((i) =>
                  luv.withSaturation(interval(luv.saturation + i, 0.0, 100.0)))
              .toList(),
          valuesList
              .map((i) =>
                  luv.withLightness(interval(luv.lightness + i, 0.0, 100.0)))
              .toList(),
        ];

        return Theme(
          data: ThemeData.from(colorScheme: scheme)
              .copyWith(
                highlightColor: surface,
                textSelectionColor: surface,
                textSelectionHandleColor: surface,
              )
              .copyWith(
                buttonTheme: ButtonThemeData(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: scheme.onSurface.withOpacity(0.70),
                    ),
                  ),
                ),
              ),
          child: Container(
            color: (state as MDCLoadedState).rgbColorsWithBlindness[selected],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 8),
                TopRow(color, selected),
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
                _BottomRow(selected, color),
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
          ),
        );
      },
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
  final String selected;

  @override
  Widget build(BuildContext context) {
    final contrastWhite = calculateContrast(color, Colors.white);
    final contrastBlack = calculateContrast(color, Colors.black);

    return LayoutBuilder(
      builder: (context, builder) {
        // if screen is not large, hide the button for detailed color screen.
        // that screen is optimized for larger sizes.
        final largeScreen = builder.maxWidth > 380;

        // if screen is tiny (like in split-view), hide the AA/AAA letters.
        final smallScreen = builder.maxWidth < 320;

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
            if (largeScreen)
              BorderedIconButton(
                child: Icon(FeatherIcons.shuffle, size: 16),
                onPressed: () {
                  var rng = Random();

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
              )
            else
              SizedBox(width: 8),
            SizedBox(width: 16),
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

class _BottomRow extends StatelessWidget {
  const _BottomRow(this.selected, this.color);

  final Color color;
  final String selected;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
//        OutlineButton.icon(
//          label: Text("Details"),
//          borderSide: BorderSide(color: onSurface.withOpacity(0.70)),
//          highlightedBorderColor: onSurface.withOpacity(0.70),
//          icon: Icon(
//            FeatherIcons.maximize,
//            size: 16,
//          ),
//          onPressed: () {
//            BlocProvider.of<MdcSelectedBloc>(context).add(
//              MDCLoadEvent(
//                currentColor: color,
//                selected: selected,
//              ),
//            );
//
//            Navigator.pushNamed(context, "/colordetails");
//          },
//        ),
//        if (selected != kPrimary)
//          OutlineButton.icon(
//            label: Text("Auto"),
//            borderSide: BorderSide(color: onSurface.withOpacity(0.70)),
//            highlightedBorderColor: onSurface.withOpacity(0.70),
//            icon: Icon(
//              FeatherIcons.lock,
//              size: 16,
//            ),
//            onPressed: () {
//              BlocProvider.of<MdcSelectedBloc>(context).add(
//                MDCUpdateLock(
//                  isLock: true,
//                  selected: selected,
//                ),
//              );
//            },
//          ),
      ],
    );
  }
}
