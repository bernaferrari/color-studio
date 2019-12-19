import 'dart:math' as math;

import 'package:colorstudio/example/mdc/components.dart';
import 'package:colorstudio/example/screens/about.dart';
import 'package:colorstudio/example/screens/multiple_sliders.dart';
import 'package:colorstudio/example/screens/single_color_blindness.dart';
import 'package:colorstudio/example/util/color_util.dart';
import 'package:colorstudio/example/util/selected.dart';
import 'package:colorstudio/example/util/when.dart';
import 'package:colorstudio/example/vertical_picker/vertical_picker_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hsluv/hsluvcolor.dart';

import '../blocs/blocs.dart';
import '../util/constants.dart';
import 'color_library.dart';

class Home extends StatefulWidget {
  const Home();

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MdcSelectedBloc, MdcSelectedState>(
        builder: (context, state) {
      final currentState = state as MDCLoadedState;

      final color = currentState.rgbColors[currentState.selected];

      final contrastedColor = (color.computeLuminance() > kLumContrast)
          ? Colors.black
          : Colors.white;

      final surfaceColor = blendColorWithBackground(color);

      final colorScheme = (color.computeLuminance() > kLumContrast)
          ? ColorScheme.light(
              primary: color,
              secondary: color,
              surface: surfaceColor,
            )
          : ColorScheme.dark(
              primary: color,
              secondary: color,
              surface: surfaceColor,
            );

      return Theme(
        data: ThemeData.from(
          // todo it would be nice if there were a ThemeData.join
          // because you need to copyWith manually everything every time.
          colorScheme: colorScheme,
        ).copyWith(
          cardTheme: Theme.of(context).cardTheme,
          buttonTheme: Theme.of(context).buttonTheme.copyWith(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
        ),
        child: Scaffold(
          backgroundColor: color,
          body: DefaultTabController(
            length: 5,
            initialIndex: 1,
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: TabBarView(
                      children: [
                        const MultipleSliders(),
                        HSVerticalPicker(color: color),
                        const SingleColorBlindness(),
                        const About(),
                        ColorLibrary(color: color),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color:
                          colorScheme.background.withOpacity(kVeryTransparent),
                      border: Border(
                        top: BorderSide(
                            color: colorScheme.onSurface.withOpacity(0.40)),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        ThemeBar(),
                        TabBar(
                          labelColor: contrastedColor,
                          indicatorColor: contrastedColor,
                          isScrollable: true,
                          indicator: BoxDecoration(
                            color: colorScheme.onSurface.withOpacity(0.10),
                            border: Border(
                              top: BorderSide(
                                color: colorScheme.onSurface,
                                width: 2.0,
                              ),
                            ),
                          ),
                          tabs: [
                            Tab(
                              icon: Transform.rotate(
                                angle: 0.5 * math.pi,
                                child: const Icon(FeatherIcons.sliders),
                              ),
                            ),
                            const Tab(icon: Icon(FeatherIcons.barChart2)),
                            Tab(icon: Icon(Icons.invert_colors)),
                            Tab(icon: Icon(FeatherIcons.info)),
                            Tab(icon: Icon(FeatherIcons.bookOpen)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget cardPicker(String title, Widget picker) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: picker,
          ),
        ],
      ),
    );
  }
}

class ColorWithDiff {
  const ColorWithDiff(this.color, this.diff, this.didChange);

  final HSLuvColor color;
  final int diff;
  final bool didChange;
}

List<ColorWithDiff> generateLuvVariations(HSLuvColor luv, String kind) {
  final luvList = <ColorWithDiff>[];

  for (int i = -10; i < 0; i += 5) {
    // if lightness becomes 0 or 100 the hue value might be lost
    // because app is always converting HSLuv to RGB and vice-versa.

    ColorWithDiff withDiff;
    if (kind == hueStr) {
      final upd = luv.withHue((luv.hue + i * 2) % 360);
      withDiff = ColorWithDiff(upd, i * 2, true);
    } else if (kind == satStr) {
      final upd = luv.withSaturation(math.max(luv.saturation + i, 5.0));
      // luv.saturation - upd.saturation > -i - 5
      // 9 - 5 > - (-5) -5 => 4 > 0 ok
      // 9 - 5 > - (-10) -5 => 4 > 5 false
      // this calculation is made so it can be known when -10 is going to be useless.
      withDiff =
          ColorWithDiff(upd, i, luv.saturation - upd.saturation > -i - 5);
    } else if (kind == lightStr) {
      final upd = luv.withLightness(math.max(luv.lightness + i, 5.0));
      withDiff = ColorWithDiff(upd, i, luv.lightness - upd.lightness > -i - 5);
    }

    luvList.add(withDiff);
  }

  luvList.add(ColorWithDiff(luv, 0, false));

  for (int i = 5; i < 15; i += 5) {
    // if lightness becomes 0 or 100 the hue value might be lost
    // because app is always converting HSLuv to RGB and vice-versa.

    ColorWithDiff withDiff;
    if (kind == hueStr) {
      final upd = luv.withHue((luv.hue + i * 2) % 360);
      withDiff = ColorWithDiff(upd, i * 2, true);
    } else if (kind == satStr) {
      final upd = luv.withSaturation(math.min(luv.saturation + i, 95.0));
      // upd.saturation - luv.saturation > -i - 5
      // 95 - 90 > 5 - 5 => 5 > 0 ok
      // 95 - 90 > 10 - 5 => 4 > 5 false
      print("${upd.saturation - luv.saturation} || ${i + 5}");
      withDiff = ColorWithDiff(upd, i, upd.saturation - luv.saturation > i - 5);
    } else if (kind == lightStr) {
      final min = math.min(luv.lightness + i, 95.0);
      final upd = luv.withLightness(min);
      withDiff = ColorWithDiff(upd, i, upd.lightness - luv.lightness > i - 5);
    }

    luvList.add(withDiff);
  }

  return luvList;
}

class ThemeBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: BlocBuilder<MdcSelectedBloc, MdcSelectedState>(
          builder: (context, state) {
//        if (state is MultipleContrastColorLoading) {
//          return const Center(child: LoadingIndicator());
//        }

        final currentState = (state as MDCLoadedState);

        final selected = currentState.selected;
        final Map<String, Color> colorsList = Map.from(currentState.rgbColors);

        // remove from the bar items that were locked in the previous screen.
        colorsList
            .removeWhere((String a, Color b) => currentState.locked[a] == true);

        final mappedList = colorsList.values.toList();
        final keysList = colorsList.keys.toList();

        return Column(
          children: <Widget>[
            SizedBox(
              height: 36,
              child: ListView(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    const SizedBox(width: 16),
                    for (int i = 0; i < mappedList.length; i++) ...[
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: RawMaterialButton(
                          onPressed: () {
                            BlocProvider.of<MdcSelectedBloc>(context).add(
                              MDCLoadEvent(
                                currentColor: mappedList[i],
                                selected: keysList[i],
                              ),
                            );
                          },
                          onLongPress: () {
//                            showSlidersDialog(context, mappedList[i], i);
                          },
                          fillColor: mappedList[i],
                          shape: CircleBorder(
                            side: BorderSide(
                              width: 2,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.7),
                            ),
                          ),
                          child: selected == keysList[i]
                              ? Icon(
                                  FeatherIcons.check,
                                  size: 16,
                                  color: contrastingColor(mappedList[i]),
                                )
                              : null,
                          elevation: 0.0,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    const SizedBox(width: 8),
                  ]),
            ),
          ],
        );
      }),
    );
  }
}

class ContrastItem extends StatelessWidget {
  const ContrastItem({
    this.colorWithDiff,
    this.onPressed,
    this.contrast,
    this.compactText = false,
    this.category = "",
  });

  final ColorWithDiff colorWithDiff;
  final Function onPressed;
  final bool compactText;
  final double contrast;
  final String category;

  @override
  Widget build(BuildContext context) {
    final color = colorWithDiff.color;

    final Color textColor = (color.lightness < kLumContrast)
        ? Colors.white.withOpacity(0.87)
        : Colors.black87;

    Widget cornerText;
    print("${colorWithDiff.color.lightness} || ${colorWithDiff.diff} AAA");
    if (colorWithDiff.diff == 0) {
      final String writtenValue = when<String>({
        () => category == hueStr: () => color.hue.round().toString(),
        () => category == satStr: () => "${color.saturation}",
        () => category == lightStr || category == valueStr: () =>
            "${color.lightness}",
      });

      cornerText = Text(
        writtenValue,
        style: Theme.of(context)
            .textTheme
            .caption
            .copyWith(color: textColor, fontWeight: FontWeight.w700),
      );
    } else if (!colorWithDiff.didChange) {
      cornerText = null;
    } else {
      cornerText = Text(
        "${colorWithDiff.diff > 0 ? "+" : ""}${colorWithDiff.diff}",
        style: Theme.of(context).textTheme.caption.copyWith(color: textColor),
      );
    }

    return SizedBox(
      width: 56,
      child: MaterialButton(
        elevation: 0,
        padding: EdgeInsets.zero,
        color: color.toColor(),
        shape: const RoundedRectangleBorder(),
        onPressed: onPressed,
        child: cornerText,
      ),
    );
  }
}

class RoundSelectableColor extends StatelessWidget {
  const RoundSelectableColor(this.kind);

  final String kind;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MdcSelectedBloc, MdcSelectedState>(
        builder: (context, state) {
      final selected = (state as MDCLoadedState).selected;
      final allItems = (state as MDCLoadedState).rgbColorsWithBlindness;

      final Color primaryColor = allItems[kPrimary];
      final Color surfaceColor = allItems[kSurface];

      final Color correctColor = when({
        () => kind == kPrimary: () => primaryColor,
        () => kind == kSurface: () => surfaceColor,
      });

      return SizedBox(
        width: 24,
        height: 24,
        child: RawMaterialButton(
          onPressed: () {
//            BlocProvider.of<MdcSelectedBloc>(context).add(
//              MDCUpdateAllEvent(
//                primaryColor: primaryColor,
//                surfaceColor: surfaceColor,
//                selectedTitle: kind,
//              ),
//            );
            colorSelected(context, correctColor);
          },
          fillColor: correctColor,
          shape: CircleBorder(
            side: BorderSide(
              width: 2,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          child: kind == selected ? Icon(FeatherIcons.check, size: 16) : null,
          elevation: 0.0,
          padding: EdgeInsets.zero,
        ),
      );
    });
  }
}
