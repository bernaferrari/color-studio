import 'dart:math' as math;

import 'package:colorstudio/example/blocs/blocs.dart';
import 'package:colorstudio/example/contrast/reorder_list.dart';
import 'package:colorstudio/example/contrast/rgb_hsluv_tuple.dart';
import 'package:colorstudio/example/contrast/shuffle_color.dart';
import 'package:colorstudio/example/hsinter.dart';
import 'package:colorstudio/example/mdc/components.dart';
import 'package:colorstudio/example/util/color_util.dart';
import 'package:colorstudio/example/util/constants.dart';
import 'package:colorstudio/example/util/hsluv_tiny.dart';
import 'package:colorstudio/example/util/selected.dart';
import 'package:colorstudio/example/util/when.dart';
import 'package:colorstudio/example/util/widget_space.dart';
import 'package:colorstudio/scheme/same_as.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hsluv/hsluvcolor.dart';

import '../util/constants.dart';
import '../widgets/update_color_dialog.dart';
import 'contrast_item.dart';
import 'contrast_list.dart';
import 'contrast_util.dart';

class ContrastCompareScreen extends StatelessWidget {
  const ContrastCompareScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MultipleContrastCompareCubit, MultipleColorCompareState>(
        builder:
            (BuildContext builderContext, MultipleColorCompareState state) {
      if (state.colorsCompared.isEmpty) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      final selectedColor = state.colorsCompared[state.selectedKey];

      ColorScheme colorScheme;
      if (selectedColor.rgbColor.computeLuminance() > kLumContrast) {
        colorScheme = ColorScheme.light(
          primary: selectedColor.rgbColor,
          surface: selectedColor.rgbColor,
        );
      } else {
        colorScheme = ColorScheme.dark(
          primary: selectedColor.rgbColor,
          surface: selectedColor.rgbColor,
        );
      }

      return Theme(
        data: ThemeData.from(
          colorScheme: colorScheme,
          textTheme: TextTheme(
            caption: GoogleFonts.b612Mono(),
            button: GoogleFonts.b612Mono(),
          ),
        ).copyWith(
          cardTheme: Theme.of(context).cardTheme,
        ),
        child: Scaffold(
          backgroundColor: selectedColor.rgbColor,
          appBar: AppBar(
            title: const Text("Contrast Compare"),
            actions: <Widget>[
              // IconButton(
              //   tooltip: "Reorder",
              //   icon: Icon(FeatherIcons.list),
              //   onPressed: () => showReorderDialog(builderContext, list),
              // )
            ],
            elevation: 0,
          ),
          body: ListView.builder(
            key: const PageStorageKey("ContrastCompareKey"),
            itemCount: state.colorsCompared.length,
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            itemBuilder: (BuildContext context, int _index) {
              final currentKey = state.colorsCompared.keys.toList()[_index];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  color: state.colorsCompared[currentKey].rgbColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: AnimatedSwitcher(
                    duration: currentKey == state.selectedKey
                        ? Duration(milliseconds: 1250)
                        : Duration(milliseconds: 750),
                    switchInCurve: currentKey == state.selectedKey
                        ? Curves.fastOutSlowIn
                        : Curves.fastLinearToSlowEaseIn,
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return SizeTransition(
                        child: FadeTransition(child: child, opacity: animation),
                        sizeFactor: animation,
                      );

                      // return SizeTransition(
                      //   child: ScaleTransition(child: child, scale: animation),
                      //   sizeFactor: animation,
                      // );
                    },
                    child: (currentKey == state.selectedKey)
                        ? ExpandedPicker(
                            colorsMap: state.colorsCompared,
                            selectedKey: state.selectedKey,
                            currentKey: currentKey,
                          )
                        : CompactPicker(
                            colorsCompared: state.colorsCompared,
                            locked: state.locked,
                            selectedKey: state.selectedKey,
                            currentKey: currentKey,
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }

  Future<void> showReorderDialog(
      BuildContext context, List<ColorCompareContrast> list) async {
    final dynamic result = await showDialog<dynamic>(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text("Drag to reorder"),
            contentPadding: const EdgeInsets.only(top: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Card(
              clipBehavior: Clip.antiAlias,
              margin: EdgeInsets.zero,
              color: compositeColors(
                Theme.of(context).colorScheme.background,
                Theme.of(context).colorScheme.primary,
                0.20,
              ),
              child: ReorderList(list),
            ),
          );
        });

    // if (result != null && result is List<Color>) {
    //   BlocProvider.of<MdcSelectedBloc>(context)
    //       .add(MDCUpdateAllEvent(colors: result, ignoreLock: true));
    // }
  }
}

class _ComparisonPart extends StatelessWidget {
  const _ComparisonPart(this.otherColor, this.contrast);

  final Color otherColor;
  final double contrast;

  @override
  Widget build(BuildContext context) {
    final checkIcon = Icon(
      FeatherIcons.checkCircle,
      color: otherColor,
    );

    final removeIcon = Icon(
      FeatherIcons.xSquare,
      color: otherColor,
    );

    final style = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: otherColor,
    );

    final parameters = [
      {
        "title": "Optimal",
        "letters": "AAA",
        "contrast": 7.0,
        "fontSize": 14,
      },
      {
        "title": "Small",
        "letters": "AA",
        "contrast": 4.5,
        "fontSize": 14,
      },
      {
        "title": "Large",
        "letters": "AA Large",
        "contrast": 3.0,
        "fontSize": 18
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: space(
        48.0,
        <Widget>[
          for (Map<String, dynamic> param in parameters)
            Row(
              children: <Widget>[
                if (contrast > param["contrast"]) checkIcon else removeIcon,
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      param["title"],
                      style: TextStyle(
                        fontSize: param["fontSize"],
                        color: otherColor,
                        fontWeight: param["fontSize"] == 18
                            ? FontWeight.w500
                            : FontWeight.w400,
                      ),
                    ),
                    Text(param["letters"], style: style),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class CompactPicker extends StatelessWidget {
  const CompactPicker({
    @required this.colorsCompared,
    @required this.locked,
    @required this.selectedKey,
    @required this.currentKey,
    Key key,
  }) : super(key: key);

  final Map<ColorType, ColorCompareContrast> colorsCompared;
  final Map<ColorType, bool> locked;
  final ColorType selectedKey;
  final ColorType currentKey;

  @override
  Widget build(BuildContext context) {
    print(
        "currentKey $currentKey | selected $selectedKey ${colorsCompared[currentKey].contrast}");

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      switchInCurve: Curves.easeInOut,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SizeTransition(child: child, sizeFactor: animation);
      },
      child: (locked[colorsCompared[currentKey].name] == true)
          ? SameAs(
              selected: colorsCompared[currentKey].name,
              color: colorsCompared[currentKey].rgbColor,
              lightness: colorsCompared[currentKey].hsluvColor.lightness,
              children: <Widget>[
                _ComparisonPart(
                  colorsCompared[selectedKey].rgbColor,
                  colorsCompared[currentKey].contrast,
                ),
                const SizedBox(height: 16),
              ],
            )
          : Container(
              padding: const EdgeInsets.only(top: 12, bottom: 16),
              color: colorsCompared[currentKey].rgbColor,
              child: Column(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: colorsCompared[selectedKey].rgbColor,
                        fontWeight: FontWeight.w200,
                        fontSize: 18,
                      ),
                      children: [
                        TextSpan(
                          text: "${describeEnum(selectedKey)} x ",
                        ),
                        TextSpan(
                          text: describeEnum(currentKey),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  _UpperPart(
                    rgbColor: colorsCompared[currentKey].rgbColor,
                    hsluvColor: colorsCompared[currentKey].hsluvColor,
                    colorFromSelected: colorsCompared[selectedKey].rgbColor,
                    contrast: colorsCompared[currentKey].contrast,
                    isSelected: currentKey == selectedKey,
                    currentKey: currentKey,
                  ),
                  _Minimized(
                    colorsRange: colorsCompared[currentKey].colorsRange,
                    currentKey: currentKey,
                  ),
                  const SizedBox(height: 16),
                  _ComparisonPart(
                    colorsCompared[selectedKey].rgbColor,
                    colorsCompared[currentKey].contrast,
                  ),
                ],
              ),
            ),
    );
  }
}

class ExpandedPicker extends StatelessWidget {
  const ExpandedPicker({
    @required this.colorsMap,
    @required this.selectedKey,
    @required this.currentKey,
    Key key,
  }) : super(key: key);

  final Map<ColorType, ColorCompareContrast> colorsMap;
  final ColorType selectedKey;
  final ColorType currentKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              describeEnum(currentKey),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(width: 16),
            _UpperPart(
              rgbColor: colorsMap[currentKey].rgbColor,
              hsluvColor: colorsMap[currentKey].hsluvColor,
              colorFromSelected: colorsMap[selectedKey].rgbColor,
              contrast: colorsMap[selectedKey].contrast,
              isSelected: selectedKey == currentKey,
              currentKey: currentKey,
            ),
          ],
        ),
        HSLuvSelectorHorizontal(
          selected: selectedKey,
          moreColors: false,
          colorsTuple: RgbHSLuvTuple(
            colorsMap[selectedKey].rgbColor,
            colorsMap[selectedKey].hsluvColor,
          ),
        ),
      ],
    );
  }
}

class HSLuvSelectorHorizontal extends StatelessWidget {
  const HSLuvSelectorHorizontal({
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
    const HSInterType kind = HSInterType.HSLuv;

    final size = MediaQuery.of(context).size.width - 16 - 56;

    final int toneSize = (size / 56).ceil();
    //moreColors ? itemsOnScreen * 2 : itemsOnScreen;

    final int hueSize = moreColors ? 90 : 45;

    return ContrastHorizontalPicker(
      kind: kind,
      isShrink: true,
      fetchHue: (HSLuvColor c) => hsluvAlternatives2(c, hueSize)
          .map((d) => RgbHSLuvTuple(d.toColor(), d))
          .toList(),
      fetchSat: (HSLuvColor c) => hsluvTones2(c, toneSize, 10, 100)
          .map((d) => RgbHSLuvTuple(d.toColor(), d))
          .toList(),
      fetchLight: (HSLuvColor c) => hsluvLightness2(c, toneSize, 5, 95)
          .map((d) => RgbHSLuvTuple(d.toColor(), d))
          .toList(),
      hueTitle: hueStr,
      satTitle: satStr,
      lightTitle: lightStr,
      toneSize: toneSize,
      colorsTuple: colorsTuple,
      selected: selected,
    );
  }
}

class ContrastHorizontalPicker extends StatelessWidget {
  const ContrastHorizontalPicker({
    this.kind,
    this.fetchHue,
    this.fetchSat,
    this.fetchLight,
    this.hueTitle,
    this.satTitle,
    this.lightTitle,
    this.toneSize,
    this.selected,
    this.isShrink,
    this.colorsTuple,
  });

  final HSInterType kind;
  final bool isShrink;
  final ColorType selected;
  final RgbHSLuvTuple colorsTuple;
  final List<RgbHSLuvTuple> Function(HSLuvColor) fetchHue;
  final List<RgbHSLuvTuple> Function(HSLuvColor) fetchSat;
  final List<RgbHSLuvTuple> Function(HSLuvColor) fetchLight;

  final int toneSize;
  final String hueTitle;
  final String satTitle;
  final String lightTitle;

  double interval(double value, double min, double max) {
    return math.min(math.max(value, min), max);
  }

  void contrastColorSelected(BuildContext context, HSLuvColor color) {
    context
        .bloc<MdcSelectedBloc>()
        .add(MDCUpdateColor(hsLuvColor: color, selected: selected));
  }

  @override
  Widget build(BuildContext context) {
    final Color borderColor =
        (colorsTuple.hsluvColor.lightness > kLightnessThreshold)
            ? Colors.black.withOpacity(0.40)
            : Colors.white.withOpacity(0.40);

    final List<Widget> widgets = <Widget>[];

    final List<RgbHSLuvTuple> light = fetchLight(colorsTuple.hsluvColor);
    final List<RgbHSLuvTuple> hue = fetchHue(colorsTuple.hsluvColor);
    final List<RgbHSLuvTuple> tones = fetchSat(colorsTuple.hsluvColor);

    final hueLen = hue.length;

    // in the ideal the world they could be calculated in the Bloc &/or in parallel.

    final Widget hueWidget = ContrastList(
      kind: kind,
      title: hueTitle,
      sectionIndex: 0,
      listSize: hueLen,
      isInfinite: true,
      colorsList: hue,
      isFirst: false,
      //index == 0,
      buildWidget: (int index) {},
      onColorPressed: (HSLuvColor c) => contrastColorSelected(context, c),
    );
    widgets.add(hueWidget);

    final satWidget = ContrastList(
      kind: kind,
      title: satTitle,
      sectionIndex: 1,
      listSize: toneSize,
      isFirst: false,
      //index == 0,
      colorsList: tones,
      onColorPressed: (HSLuvColor c) => contrastColorSelected(context, c),
    );
    widgets.add(satWidget);

    final valueWidget = ContrastList(
      kind: kind,
      title: lightTitle,
      sectionIndex: 2,
      isFirst: false,
      //index == 0,
      listSize: toneSize,
      colorsList: light,
      onColorPressed: (HSLuvColor c) => contrastColorSelected(context, c),
    );
    widgets.add(valueWidget);

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
          child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              const SizedBox(height: 8),
              for (int i = 0; i < 3; i++) ...<Widget>[
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
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
                          style: GoogleFonts.b612Mono(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String toPartialStr(HSLuvColor hsluv, int index) {
    return when({
      () => index == 0: () => "H:${hsluv.hue.toInt()}",
      () => index == 1: () => "S:${hsluv.saturation.round()}",
      () => index == 2: () => "L:${hsluv.lightness.round()}",
    });
  }
}

class _Minimized extends StatelessWidget {
  const _Minimized({
    @required this.currentKey,
    @required this.colorsRange,
  });

  final ColorType currentKey;
  final List<RgbHSLuvTupleWithContrast> colorsRange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (int i = 0; i < colorsRange.length; i++)
              SizedBox(
                width: 56,
                height: 56,
                child: ContrastItem3(
                  rgbHsluvTuple: colorsRange[i],
                  contrast: colorsRange[i].contrast,
                  category: "Lightness",
                  onPressed: () {
                    context.bloc<MdcSelectedBloc>().add(
                          MDCLoadEvent(
                            currentColor: colorsRange[i].rgbColor,
                            selected: currentKey,
                          ),
                        );
//                    BlocProvider.of<MultipleContrastColorBloc>(context)
//                        .add(MCMoveColor(hsInter[i].color, index));
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _UpperPart extends StatelessWidget {
  const _UpperPart({
    @required this.rgbColor,
    @required this.hsluvColor,
    @required this.colorFromSelected,
    @required this.contrast,
    @required this.isSelected,
    @required this.currentKey,
  });

  final Color colorFromSelected;
  final HSLuvColor hsluvColor;
  final Color rgbColor;
  final double contrast;
  final bool isSelected;
  final ColorType currentKey;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: colorFromSelected,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: space(
        16,
        <Widget>[
          if (!isSelected)
            SizedBox(
              width: 56,
              child: Column(
                children: <Widget>[
                  RichText(
                    text: TextSpan(style: style, children: [
                      TextSpan(
                        text: contrast.toStringAsPrecision(3),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: ":1",
                        style: style.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ]),
                  ),
                  Text(
                    getContrastLetters(contrast),
                    style: style.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
          _Buttons(
            rgbColor: rgbColor,
            hsluvColor: hsluvColor,
            colorFromSelected: colorFromSelected,
            currentKey: currentKey,
            isSelected: isSelected,
          ),
        ],
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  const _Buttons({
    @required this.rgbColor,
    @required this.hsluvColor,
    @required this.colorFromSelected,
    @required this.isSelected,
    @required this.currentKey,
  });

  final Color rgbColor;
  final HSLuvColor hsluvColor;
  final Color colorFromSelected;
  final bool isSelected;
  final ColorType currentKey;

  @override
  Widget build(BuildContext context) {
    final contrastColor = isSelected
        ? Theme.of(context).colorScheme.onSurface
        : contrastingHSLuvColor(hsluvColor);

    final outlinedButtonSideColor = isSelected
        ? Theme.of(context).colorScheme.onSurface
        : colorFromSelected;

    return Row(
      children: space(
        16,
        <Widget>[
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(defaultRadius),
              ),
              side: BorderSide(color: outlinedButtonSideColor),
              primary: contrastColor,
            ),
            icon: Icon(
              FeatherIcons.search,
              size: 16,
            ),
            label: Text(rgbColor.toHexStr()),
            onPressed: () {
              showSlidersDialog(context, rgbColor, currentKey);
            },
            onLongPress: () {
              copyToClipboard(context, rgbColor.toHexStr());
            },
          ),
          SizedBox(
            width: 36,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(defaultRadius),
                ),
                side: BorderSide(color: outlinedButtonSideColor),
                primary: contrastColor,
              ),
              child: Icon(
                Icons.shuffle_rounded,
                size: 16,
                color: contrastColor,
              ),
              onPressed: () {
                BlocProvider.of<MdcSelectedBloc>(context).add(
                  MDCLoadEvent(
                    currentColor: getShuffleColor(),
                    selected: currentKey,
                  ),
                );
              },
            ),
          ),
          if (!isSelected)
            SizedBox(
              width: 36,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(defaultRadius),
                  ),
                  side: BorderSide(color: outlinedButtonSideColor),
                  primary: contrastColor,
                  elevation: 0,
                ),
                child: Icon(
                  Icons.compare_arrows_rounded,
                  size: 16,
                ),
                onPressed: () {
                  print("button is vs $currentKey");

                  context
                      .bloc<MultipleContrastCompareCubit>()
                      .updateSelectedKey(currentKey);
                },
              ),
            ),
        ],
      ),
    );
  }
}
