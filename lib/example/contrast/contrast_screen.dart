import 'dart:math' as math;

import 'package:colorstudio/example/blocs/blocs.dart';
import 'package:colorstudio/example/blocs/multiple_contrast_color/multiple_contrast_color_bloc.dart';
import 'package:colorstudio/example/blocs/multiple_contrast_color/multiple_contrast_color_state.dart';
import 'package:colorstudio/example/contrast/inter_color_with_contrast.dart';
import 'package:colorstudio/example/contrast/reorder_list.dart';
import 'package:colorstudio/example/contrast/shuffle_color.dart';
import 'package:colorstudio/example/hsinter.dart';
import 'package:colorstudio/example/mdc/components.dart';
import 'package:colorstudio/example/util/color_util.dart';
import 'package:colorstudio/example/util/constants.dart';
import 'package:colorstudio/example/util/hsluv_tiny.dart';
import 'package:colorstudio/example/util/selected.dart';
import 'package:colorstudio/example/widgets/loading_indicator.dart';
import 'package:colorstudio/scheme/same_as.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import '../util/constants.dart';
import '../widgets/update_color_dialog.dart';
import 'contrast_item.dart';
import 'contrast_list.dart';
import 'contrast_util.dart';
import 'info_screen.dart';

class MultipleContrastScreen extends StatefulWidget {
  const MultipleContrastScreen();

  @override
  _MultipleContrastScreenState createState() => _MultipleContrastScreenState();
}

class _MultipleContrastScreenState extends State<MultipleContrastScreen> {
  bool contrastMode = true;

  int currentSegment = 0;

  void onValueChanged(int newValue) {
    setState(() {
      currentSegment = newValue;
      contrastMode = currentSegment == 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MultipleContrastColorBloc, MultipleContrastColorState>(
        builder:
            (BuildContext builderContext, MultipleContrastColorState state) {
      if (state is MultipleContrastColorLoading) {
        return const Scaffold(body: Center(child: LoadingIndicator()));
      }

      final list = (state as MultipleContrastColorLoaded).colorsList;

      ColorScheme colorScheme;

      if (list[0].rgbColor.computeLuminance() > kLumContrast) {
        colorScheme = ColorScheme.light(
          primary: list[0].rgbColor,
          surface: list[0].rgbColor,
        );
      } else {
        colorScheme = ColorScheme.dark(
          primary: list[0].rgbColor,
          surface: list[0].rgbColor,
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
          buttonTheme: Theme.of(context).buttonTheme.copyWith(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: list[0].rgbColor),
                  borderRadius: BorderRadius.circular(defaultRadius),
                ),
              ),
          cardTheme: Theme.of(context).cardTheme,
        ),
        child: Scaffold(
          backgroundColor: list[0].rgbColor,
          appBar: AppBar(
            title: const Text("Contrast Compare"),
            actions: <Widget>[
              if (currentSegment != 2)
                IconButton(
                  tooltip: "Reorder",
                  icon: Icon(FeatherIcons.list),
                  onPressed: () => showReorderDialog(builderContext, list),
                )
            ],
            bottom: PreferredSize(
              preferredSize: const Size(500, 56),
              child: Container(
                width: 500,
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16,
                  top: 16,
                  bottom: 12,
                ),
                child: CupertinoSlidingSegmentedControl<int>(
                  backgroundColor: colorScheme.onSurface.withOpacity(0.20),
                  thumbColor: compositeColors(
                    colorScheme.background,
                    list[0].rgbColor,
                    kVeryTransparent,
                  ),
                  children: const <int, Widget>{
                    0: Text("Adjust"),
                    1: Text("Info"),
                  },
                  onValueChanged: onValueChanged,
                  groupValue: currentSegment,
                ),
              ),
            ),
          ),
          body: contrastMode ? _MultipleContrastScreen(list) : InfoScreen(list),
        ),
      );
    });
  }

  Future<void> showReorderDialog(
      BuildContext builderContext, List<ContrastedColor> list) async {
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

    if (result != null && result is List<Color>) {
      BlocProvider.of<MdcSelectedBloc>(builderContext)
          .add(MDCUpdateAllEvent(colors: result, ignoreLock: true));
    }
  }
}

class _MultipleContrastScreen extends StatelessWidget {
  const _MultipleContrastScreen(this.colorsList);

  final List<ContrastedColor> colorsList;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MdcSelectedBloc, MdcSelectedState>(
        builder: (BuildContext builderContext, MdcSelectedState state) {
      const bool more = false;
      final interListOfLists = <List<InterColorWithContrast>>[];

      final currentState = state as MDCLoadedState;

      for (var element in colorsList) {
        final interList = <InterColorWithContrast>[];
        for (int i = -10; i < 15; i += 5) {
          final luv = HSInterColor.fromColor(element.rgbColor, "HSLuv");
          // if lightness becomes 0 or 100 the hue value might be lost
          // because app is always converting HSLuv to RGB and vice-versa.
          final updatedLuv =
              luv.withLightness(interval(luv.lightness + i, 5.0, 95.0));

          interList.add(
            InterColorWithContrast(
              updatedLuv.toColor(),
              updatedLuv,
              colorsList[0].rgbColor,
            ),
          );
        }
        interListOfLists.add(interList);
      }

      return ListView.builder(
        key: const PageStorageKey("ContrastCompareKey"),
        itemCount: colorsList.length,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return HSLuvSelector2(
              index: index,
              moreColors: more,
              colorsMap: colorsList,
            );
          } else {
            return AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              switchInCurve: Curves.easeInOut,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SizeTransition(child: child, sizeFactor: animation);
              },
              child: (currentState.locked[mdcList[index]] == true)
                  ? SameAs(
                      selected: mdcList[index],
                      color: colorsList[index].rgbColor,
                      contrast: colorsList[index].hsluvColor.lightness,
                      children: <Widget>[
                        _ComparisonPart(
                          colorsList[0].rgbColor,
                          colorsList[index].contrast,
                        ),
                        SizedBox(height: 16),
                      ],
                    )
                  : Container(
                      padding: const EdgeInsets.only(top: 12, bottom: 16),
                      color: colorsList[index].rgbColor,
                      child: Column(
                        children: <Widget>[
                          _UpperPart(
                            colorsList[index].rgbColor,
                            colorsList[0].rgbColor,
                            colorsList[index].contrast,
                            index,
                            colorsList,
                          ),
                          _Minimized("HSLuv", index, interListOfLists[index]),
                          SizedBox(height: 16),
                          _ComparisonPart(
                            colorsList[0].rgbColor,
                            colorsList[index].contrast,
                          ),
                        ],
                      ),
                    ),
            );
          }
        },
      );
    });
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            if (contrast > 7.0) checkIcon else removeIcon,
            const SizedBox(width: 8),
            Column(
              children: <Widget>[
                Text(
                  "Optimal",
                  style: TextStyle(
                    fontSize: 14,
                    color: otherColor,
                  ),
                ),
                Text("AAA", style: style),
              ],
            ),
          ],
        ),
        const SizedBox(width: 48),
        Row(
          children: <Widget>[
            if (contrast > 4.5) checkIcon else removeIcon,
            const SizedBox(width: 8),
            Column(
              children: <Widget>[
                Text(
                  "Small",
                  style: TextStyle(
                    fontSize: 14,
                    color: otherColor,
                  ),
                ),
                Text("AA", style: style),
              ],
            ),
          ],
        ),
        const SizedBox(width: 48),
        Row(
          children: <Widget>[
            if (contrast > 3.0) checkIcon else removeIcon,
            const SizedBox(width: 8),
            Column(
              children: <Widget>[
                Text(
                  "Large",
                  style: TextStyle(
                    // similar to H6
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: otherColor,
                  ),
                ),
                Text("AA Large", style: style),
              ],
            ),
//            const SizedBox(width: 8),
//            Icon(
//              Icons.brightness_4,
//              color: otherColor,
//            ),
          ],
        ),
      ],
    );
  }
}

class HSLuvSelector2 extends StatelessWidget {
  const HSLuvSelector2({
    this.moreColors = false,
    this.index,
    this.colorsMap,
  });

  // maximum number of items
  final bool moreColors;

  final List<ContrastedColor> colorsMap;

  final int index;

  @override
  Widget build(BuildContext context) {
    const String kind = hsluvStr;

    final size = MediaQuery.of(context).size.width - 16 - 56;

    final int toneSize =
        (size / 56).ceil(); //moreColors ? itemsOnScreen * 2 : itemsOnScreen;
    final int hueSize = moreColors ? 90 : 45;

    return ContrastHorizontalPicker(
      kind: kind,
      isShrink: true,
      fetchHue: (Color c) => hsluvAlternatives(c, hueSize),
      fetchSat: (Color c, Color otherColor) => hsluvTones(c, toneSize, 10, 100)
          .convertToInterContrast(kind, otherColor),
      fetchLight: (Color c, Color otherColor) =>
          hsluvLightness(c, toneSize, 5, 95)
              .convertToInterContrast(kind, otherColor),
      hueTitle: hueStr,
      satTitle: satStr,
      lightTitle: lightStr,
      toneSize: toneSize,
      colorsList: colorsMap,
      index: index,
    );
  }
}

const mdcList = [kPrimary, kBackground, kSurface];

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
    this.index,
    this.isShrink,
    this.colorsList,
  });

  final String kind;
  final bool isShrink;
  final int index;
  final List<ContrastedColor> colorsList;
  final List<Color> Function(Color) fetchHue;
  final List<InterColorWithContrast> Function(Color, Color) fetchSat;
  final List<InterColorWithContrast> Function(Color, Color) fetchLight;

  final int toneSize;
  final String hueTitle;
  final String satTitle;
  final String lightTitle;

  double interval(double value, double min, double max) {
    return math.min(math.max(value, min), max);
  }

  List<InterColorWithContrast> parseHue(Color color, Color otherColor) {
    return fetchHue(color).map((Color c) {
      final HSInterColor hsluv = HSInterColor.fromColor(c, kind);
      final color = hsluv.toColor();
      return InterColorWithContrast(color, hsluv, otherColor);
    }).toList();
  }

  void contrastColorSelected(BuildContext context, Color color) {
    BlocProvider.of<MdcSelectedBloc>(context)
        .add(MDCLoadEvent(currentColor: color, selected: mdcList[index]));
  }

  @override
  Widget build(BuildContext context) {
    final Color rgbColor = colorsList[index].rgbColor;

    final Color otherColor = colorsList[0].rgbColor;

    final contrast = colorsList[index].contrast;

    final List<InterColorWithContrast> values =
        fetchLight(rgbColor, otherColor);

    final Color borderColor = (rgbColor.computeLuminance() > kLumContrast)
        ? Colors.black.withOpacity(0.40)
        : Colors.white.withOpacity(0.40);

    final List<Widget> widgets = <Widget>[];

    final hue = parseHue(rgbColor, otherColor);
    final hueLen = hue.length;

    // in the ideal the world they could be calculated in the Bloc &/or in parallel.
    final List<InterColorWithContrast> tones = fetchSat(rgbColor, otherColor);

    final Widget hueWidget = ContrastList(
      pageKey: kind,
      title: hueTitle,
      sectionIndex: 0,
      listSize: hueLen,
      isInfinite: true,
      colorsList: hue,
      isFirst: index == 0,
      buildWidget: (int index) {},
      onColorPressed: (Color c) => contrastColorSelected(context, c),
    );
    widgets.add(hueWidget);

    final satWidget = ContrastList(
      pageKey: kind,
      title: satTitle,
      sectionIndex: 1,
      listSize: toneSize,
      isFirst: index == 0,
      colorsList: tones,
      onColorPressed: (Color c) => contrastColorSelected(context, c),
    );
    widgets.add(satWidget);

    final valueWidget = ContrastList(
      pageKey: kind,
      title: lightTitle,
      sectionIndex: 2,
      isFirst: index == 0,
      listSize: toneSize,
      colorsList: values,
      onColorPressed: (Color c) => contrastColorSelected(context, c),
    );
    widgets.add(valueWidget);

    final shape = RoundedRectangleBorder(
      side: BorderSide(color: borderColor),
      borderRadius: BorderRadius.circular(defaultRadius),
    );

    return Theme(
      data: ThemeData.from(
        colorScheme: (rgbColor.computeLuminance() > kLumContrast)
            ? ColorScheme.light(surface: rgbColor)
            : ColorScheme.dark(surface: rgbColor),
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
      child: Container(
        color: rgbColor,
        padding: const EdgeInsets.all(8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 818),
          child: Flex(
            mainAxisAlignment: MainAxisAlignment.center,
            direction: Axis.vertical,
            children: <Widget>[
              _UpperPart(rgbColor, otherColor, contrast, index, colorsList),
              Flex(
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
                              height:
                                  MediaQuery.of(context).size.shortestSide < 600
                                      ? 56
                                      : 64,
                              child: widgets[i],
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 48,
                            child: Text(
                              HSInterColor.fromColor(rgbColor, kind)
                                  .toPartialStr((index == 0) ? i : 2),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.b612Mono(
                                fontSize: 12,
                                textStyle: TextStyle(
                                  color: contrastingColor(rgbColor),
                                ),
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
            ],
          ),
        ),
      ),
    );
  }
}

class _Minimized extends StatelessWidget {
  const _Minimized(this.kind, this.index, this.hsInter);

  final String kind;
  final int index;
  final List<InterColorWithContrast> hsInter;

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
            for (int i = 0; i < hsInter.length; i++)
              SizedBox(
                width: 56,
                height: 56,
                child: ContrastItem(
                  kind: kind,
                  color: hsInter[i],
                  contrast: hsInter[i].contrast,
                  compactText: false,
                  category: "Lightness",
                  onPressed: () {
                    BlocProvider.of<MdcSelectedBloc>(context).add(
                      MDCLoadEvent(
                        currentColor: hsInter[i].color,
                        selected: mdcList[index],
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
  const _UpperPart(
      this.color, this.otherColor, this.contrast, this.index, this.list);

  final Color otherColor;
  final Color color;
  final double contrast;
  final int index;
  final List<ContrastedColor> list;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: otherColor,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(width: 16),
        if (index != 0)
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
          )
        else
          Text(
            "PRIMARY",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        const SizedBox(width: 16),
//        Expanded(
//          child: Center(
//            child: Container(
//              width: 0,
//              height: 32,
//              color: otherColor,
//            ),
//          ),
//        ),
        _Buttons(
          color: color,
          otherColor: (index == 0)
              ? Theme.of(context).colorScheme.onSurface
              : otherColor,
          index: index,
          list: list,
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}

class _Buttons extends StatelessWidget {
  const _Buttons({this.color, this.otherColor, this.index, this.list});

  final Color color;
  final Color otherColor;
  final int index;
  final List<ContrastedColor> list;

  @override
  Widget build(BuildContext context) {
    final contrastColor = contrastingColor(color);

    return Row(
      children: <Widget>[
        OutlineButton.icon(
          icon: Icon(
            FeatherIcons.search,
            size: 16,
          ),
          color: color,
          textColor: contrastColor,
          highlightedBorderColor: otherColor,
          borderSide: BorderSide(color: otherColor),
          label: Text(color.toHexStr()),
          onPressed: () {
            showSlidersDialog(context, color, mdcList[index]);
          },
          onLongPress: () {
            copyToClipboard(context, color.toHexStr());
          },
        ),
        const SizedBox(width: 16),
//        if (index == 0)
        MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultRadius),
            side: BorderSide(
              color: otherColor,
              width: 1.0,
            ),
          ),
          highlightColor:
              Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
          minWidth: 48,
          elevation: 0,
          textColor: contrastColor,
          child: Icon(
            FeatherIcons.shuffle,
            size: 16,
          ),
          padding: EdgeInsets.zero,
          onPressed: () {
            BlocProvider.of<MdcSelectedBloc>(context).add(
              MDCLoadEvent(
                currentColor: getShuffleColor(),
                selected: mdcList[index],
              ),
            );
          },
        ),
//        if (index != 0) const SizedBox(width: 16),
//        if (index != 0)
//          MaterialButton(
//            shape: RoundedRectangleBorder(
//              borderRadius: BorderRadius.circular(defaultRadius),
//              side: BorderSide(
//                color: otherColor,
//                width: 1.0,
//              ),
//            ),
//            highlightColor:
//                Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
//            minWidth: 48,
//            elevation: 0,
//            child: Icon(
//              FeatherIcons.maximize2,
//              size: 16,
//            ),
//            padding: EdgeInsets.zero,
//            onPressed: () => showReorderDialog(context, color, otherColor),
//          ),
      ],
    );
  }
}
