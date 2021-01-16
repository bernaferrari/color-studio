import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hsluv/hsluvcolor.dart';
import 'package:infinite_listview/infinite_listview.dart';

import '../blocs/blocs.dart';
import '../blocs/multiple_contrast_compare/rgb_hsluv_tuple.dart';
import '../contrast_util.dart';
import '../util/constants.dart';
import '../util/hsluv_tiny.dart';
import '../util/when.dart';

class MultiRowColorPicker extends StatelessWidget {
  const MultiRowColorPicker({
    this.moreColors = false,
    this.selected,
    this.colorsTuple,
  });

  // maximum number of items
  final bool moreColors;

  final RgbHSLuvTuple colorsTuple;

  final ColorType selected;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width - 16 - 56;

    final int toneSize = (size / 56).ceil();
    final int hueSize = moreColors ? 90 : 45;

    return _MultiRowColorPicker(
      fetchHue: (c) => hsluvAlternatives2(c, hueSize)
          .map((d) => RgbHSLuvTuple(d.toColor(), d))
          .toList(),
      fetchSat: (c) => hsluvTones2(c, toneSize, 10, 100)
          .map((d) => RgbHSLuvTuple(d.toColor(), d))
          .toList(),
      fetchLight: (c) => hsluvLightness2(c, toneSize, 5, 95)
          .map((d) => RgbHSLuvTuple(d.toColor(), d))
          .toList(),
      toneSize: toneSize,
      colorsTuple: colorsTuple,
      selected: selected,
    );
  }
}

class _MultiRowColorPicker extends StatelessWidget {
  const _MultiRowColorPicker({
    this.fetchHue,
    this.fetchSat,
    this.fetchLight,
    this.toneSize,
    this.selected,
    this.colorsTuple,
  });

  final ColorType selected;
  final RgbHSLuvTuple colorsTuple;
  final List<RgbHSLuvTuple> Function(HSLuvColor) fetchHue;
  final List<RgbHSLuvTuple> Function(HSLuvColor) fetchSat;
  final List<RgbHSLuvTuple> Function(HSLuvColor) fetchLight;

  final int toneSize;

  double interval(double value, double min, double max) {
    return math.min(math.max(value, min), max);
  }

  void contrastColorSelected(BuildContext context, HSLuvColor color) {
    context
        .read<ColorsCubit>()
        .updateColor(hsLuvColor: color, selected: selected);
  }

  @override
  Widget build(BuildContext context) {
    final List<RgbHSLuvTuple> light = fetchLight(colorsTuple.hsluvColor);
    final List<RgbHSLuvTuple> hue = fetchHue(colorsTuple.hsluvColor);
    final List<RgbHSLuvTuple> tones = fetchSat(colorsTuple.hsluvColor);

    final hueLen = hue.length;

    final borderColor = (colorsTuple.hsluvColor.lightness > kLightnessThreshold)
        ? Colors.black.withOpacity(0.40)
        : Colors.white.withOpacity(0.40);

    // in the ideal the world they could be calculated in the Bloc &/or in parallel.
    final widgets = <Widget>[
      _HorizontalColorListExpanded(
        category: hueStr,
        listSize: hueLen,
        isInfinite: true,
        colorsList: hue,
        onColorPressed: (c) => contrastColorSelected(context, c),
      ),
      _HorizontalColorListExpanded(
        category: satStr,
        listSize: toneSize,
        isInfinite: false,
        colorsList: tones,
        onColorPressed: (c) => contrastColorSelected(context, c),
      ),
      _HorizontalColorListExpanded(
        category: lightStr,
        listSize: toneSize,
        isInfinite: false,
        colorsList: light,
        onColorPressed: (c) => contrastColorSelected(context, c),
      ),
    ];

    final shape = RoundedRectangleBorder(
      side: BorderSide(color: borderColor),
      borderRadius: BorderRadius.circular(defaultRadius),
    );

    return Theme(
      data: ThemeData.from(
        colorScheme: (colorsTuple.hsluvColor.lightness > kLightnessThreshold)
            ? ColorScheme.light(surface: colorsTuple.rgbColor)
            : ColorScheme.dark(surface: colorsTuple.rgbColor),
        textTheme: TextTheme(
          caption: GoogleFonts.b612Mono(),
          button: GoogleFonts.b612Mono(),
        ),
      ).copyWith(
        buttonTheme: ButtonThemeData(shape: shape),
        cardTheme: Theme.of(context).cardTheme.copyWith(
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              shape: shape,
            ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 818),
          child: Column(
            children: <Widget>[
              for (int i = 0; i < 3; i++)
                Padding(
                  padding: const EdgeInsets.only(
                    top: 4,
                    bottom: 4,
                    left: 16,
                    right: 8,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(
                          // make items larger on iPad
                          height: MediaQuery.of(context).size.shortestSide < 600
                              ? 56
                              : 64,
                          child: widgets[i],
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 48,
                        child: Text(
                          toPartialStr(colorsTuple.hsluvColor, i),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.b612Mono(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String toPartialStr(HSLuvColor hsluv, int index) {
    switch (index) {
      case 0:
        return "H:${hsluv.hue.toInt()}";
      case 1:
        return "S:${hsluv.saturation.round()}";
      case 2:
        return "L:${hsluv.lightness.round()}";
      default:
        return "";
    }
  }
}

class _HorizontalColorListExpanded extends StatelessWidget {
  const _HorizontalColorListExpanded({
    @required this.category,
    @required this.listSize,
    @required this.colorsList,
    @required this.isInfinite,
    @required this.onColorPressed,
  });

  final List<RgbHSLuvTuple> colorsList;
  final String category;
  final int listSize;
  final bool isInfinite;
  final ValueChanged<HSLuvColor> onColorPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: isInfinite
          ? InfiniteListView.builder(
              scrollDirection: Axis.horizontal,
              key: PageStorageKey<String>("hPicker $category"),
              itemBuilder: (_, absoluteIndex) {
                final index = absoluteIndex % listSize;

                return _ContrastItemExpanded(
                  rgbHsluvTuple: colorsList[index],
                  category: category,
                  onPressed: () => onColorPressed(
                    colorsList[index].hsluvColor,
                  ),
                );
              },
            )
          : MediaQuery.removePadding(
              // this is necessary on iOS, else there will be a bottom padding.
              removeBottom: true,
              context: context,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: listSize,
                scrollDirection: Axis.horizontal,
                key: PageStorageKey<String>("hPicker $category"),
                itemBuilder: (_, index) {
                  return _ContrastItemExpanded(
                    rgbHsluvTuple: colorsList[index],
                    category: category,
                    onPressed: () => onColorPressed(
                      colorsList[index].hsluvColor,
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class _ContrastItemExpanded extends StatelessWidget {
  const _ContrastItemExpanded({
    this.rgbHsluvTuple,
    this.onPressed,
    this.category = "",
  });

  final RgbHSLuvTuple rgbHsluvTuple;
  final VoidCallback onPressed;
  final String category;

  @override
  Widget build(BuildContext context) {
    final hsluv = rgbHsluvTuple.hsluvColor;

    final Color textColor = (hsluv.lightness < kLightnessThreshold)
        ? Colors.white.withOpacity(0.87)
        : Colors.black87;

    final String writtenValue = when<String>({
      () => category == hueStr: () => hsluv.hue.round().toString(),
      () => category == satStr: () => hsluv.saturation.round().toString(),
      () => category == lightStr || category == valueStr: () =>
          hsluv.lightness.round().toString(),
    });

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: EdgeInsets.zero,
        primary: rgbHsluvTuple.rgbColor,
        shape: const RoundedRectangleBorder(),
      ),
      onPressed: onPressed,
      child: Text(
        writtenValue,
        style: Theme.of(context).textTheme.caption.copyWith(color: textColor),
      ),
    );
  }
}
