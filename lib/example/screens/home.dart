import 'dart:math' as math;

import 'package:colorstudio/contrast_ratio/widgets/contrast_widgets.dart';
import 'package:colorstudio/example/mdc/components.dart';
import 'package:colorstudio/example/mdc/templates.dart';
import 'package:colorstudio/example/screens/about.dart';
import 'package:colorstudio/example/screens/single_color_blindness.dart';
import 'package:colorstudio/example/util/selected.dart';
import 'package:colorstudio/example/util/when.dart';
import 'package:colorstudio/example/vertical_picker/vertical_picker_main.dart';
import 'package:colorstudio/example/widgets/loading_indicator.dart';
import 'package:colorstudio/example/widgets/update_color_dialog.dart';
import 'package:colorstudio/scheme/widgets/expanded_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hsluv/hsluvcolor.dart';

import '../blocs/blocs.dart';
import '../util/constants.dart';
import 'color_library.dart';

class SingleColorHome extends StatelessWidget {
  const SingleColorHome({this.isSplitView = false});

  final bool isSplitView;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MdcSelectedBloc, MdcSelectedState>(
        builder: (context, state) {
      final currentState = state as MDCLoadedState;

      Color selectedColor = currentState.rgbColors[currentState.selected];
      HSLuvColor hsluvColor = currentState.hsluvColors[currentState.selected];
      String selected = currentState.selected;

      final colorScheme = (selectedColor.computeLuminance() > kLumContrast)
          ? ColorScheme.light(
              primary: selectedColor,
              secondary: selectedColor,
              surface: selectedColor,
            )
          : ColorScheme.dark(
              primary: selectedColor,
              secondary: selectedColor,
              surface: selectedColor,
            );

      return Theme(
        data: ThemeData.from(
          // todo it would be nice if there were a ThemeData.join
          // because you need to copyWith manually everything every time.
          colorScheme: colorScheme,
          textTheme: TextTheme(
            title: GoogleFonts.firaSans(fontWeight: FontWeight.w600),
            subtitle: GoogleFonts.firaSans(fontWeight: FontWeight.w500),
            body1: GoogleFonts.firaSans(),
            // body2 is used in templates screen
            body2: GoogleFonts.b612Mono(fontSize: 12),
            caption: GoogleFonts.firaSans(),
            button: GoogleFonts.b612Mono(),
          ),
        ).copyWith(
          cardTheme: Theme.of(context).cardTheme,
          buttonTheme: Theme.of(context).buttonTheme.copyWith(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
        ),
        child: Scaffold(
          backgroundColor: selectedColor,
          body: DefaultTabController(
            length: 5,
            initialIndex: 0,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: TabBarView(
                    children: [
//                        MultipleSliders(
//                          color: color,
//                          isSplitView: isSplitView,
//                        ),
                      HSVerticalPicker(
                        color: selectedColor,
                        hsLuvColor: hsluvColor,
                        isSplitView: isSplitView,
                      ),
                      SingleColorBlindness(
                        color: selectedColor,
                        isSplitView: isSplitView,
                      ),
                      About(isSplitView: isSplitView),
                      ColorLibrary(
                        color: selectedColor,
                        isSplitView: isSplitView,
                      ),
                      ColorTemplates(
                        backgroundColor: selectedColor,
                        isSplitView: isSplitView,
                      ),
                    ],
                  ),
                ),
                _BottomHome(
                  selected: selected,
                  selectedColor: selectedColor,
                  locked: currentState.locked,
                  rgbColors: currentState.rgbColors,
                ),
              ],
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

class _BottomHome extends StatefulWidget {
  const _BottomHome({
    this.selected,
    this.selectedColor,
    this.rgbColors,
    this.locked,
  });

  final String selected;
  final Color selectedColor;
  final Map<String, Color> rgbColors;
  final Map<String, bool> locked;

  @override
  __BottomHomeState createState() => __BottomHomeState();
}

class __BottomHomeState extends State<_BottomHome> {
  bool isContrastExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final contrastedColor =
        (widget.selectedColor.computeLuminance() > kLumContrast)
            ? Colors.black
            : Colors.white;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.background.withOpacity(kVeryTransparent),
        border: Border(
          top: BorderSide(
            color: colorScheme.onSurface.withOpacity(0.40),
          ),
        ),
      ),
      child: SafeArea(
        bottom: true,
        top: false,
        left: false,
        right: false,
        child: Column(
          children: <Widget>[
            ExpandedSection(
              expand: isContrastExpanded,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: _ColorContrastRow(
                  areValuesLocked: false,
                  rgbColors: widget.rgbColors,
                ),
              ),
            ),
            ThemeBar(
              selected: widget.selected,
              rgbColors: widget.rgbColors,
              locked: widget.locked,
              isExpanded: isContrastExpanded,
              onExpanded: () {
                setState(() {
                  isContrastExpanded = !isContrastExpanded;
                });
              },
            ),
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
//                            Tab(
//                              icon: Transform.rotate(
//                                angle: 0.5 * math.pi,
//                                child: const Icon(FeatherIcons.sliders),
//                              ),
//                            ),
                const Tab(icon: Icon(FeatherIcons.barChart2)),
                Tab(icon: Icon(Icons.invert_colors)),
                Tab(icon: Icon(FeatherIcons.info)),
                Tab(icon: Icon(FeatherIcons.bookOpen)),
                Tab(icon: Icon(FeatherIcons.briefcase)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorContrastRow extends StatelessWidget {
  const _ColorContrastRow({
    this.areValuesLocked,
    this.rgbColors,
  });

  final bool areValuesLocked;
  final Map<String, Color> rgbColors;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContrastRatioBloc, ContrastRatioState>(
        builder: (context, state) {
      if (state is InitialContrastRatioState) {
        return Center(child: LoadingIndicator());
      }

      final currentState = (state as ContrastRatioSuccess);

      return Center(
        child: SizedBox(
          width: 500,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ContrastCircleBar(
                title: kPrimary,
                subtitle: kBackground,
                contrast: currentState.contrastValues[0],
                animateOnInit: false,
                circleColor: rgbColors[kPrimary],
                contrastingColor: rgbColors[kBackground],
              ),
              // don't show the other circles when their values are useless.
              if (!areValuesLocked) ...[
                ContrastCircleBar(
                  title: kPrimary,
                  subtitle: kSurface,
                  contrast: currentState.contrastValues[1],
                  animateOnInit: false,
                  circleColor: rgbColors[kSurface],
                  contrastingColor: rgbColors[kPrimary],
                ),
                ContrastCircleBar(
                  title: kSurface,
                  subtitle: kBackground,
                  contrast: currentState.contrastValues[2],
                  animateOnInit: false,
                  circleColor: rgbColors[kBackground],
                  contrastingColor: rgbColors[kSurface],
                ),
              ],
            ],
          ),
        ),
      );
    });
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
  const ThemeBar({
    this.selected,
    this.rgbColors,
    this.locked,
    this.isExpanded,
    this.onExpanded,
    this.leading,
  });

  final String selected;
  final Map<String, Color> rgbColors;
  final Map<String, bool> locked;
  final bool isExpanded;
  final Function onExpanded;
  final Widget leading;

  void colorSelected(
    BuildContext context,
    String selected,
    Color color,
  ) {
    BlocProvider.of<MdcSelectedBloc>(context).add(
      MDCLoadEvent(
        currentColor: color,
        selected: selected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Color> colorsList = Map.from(rgbColors);

    // remove from the bar items that were locked in the previous screen.
    colorsList.removeWhere((String a, Color b) => locked[a] == true);

    final mappedList = colorsList.values.toList();
    final keysList = colorsList.keys.toList();

    final contrastedColors = [
      for (int i = 0; i < mappedList.length; i++)
        contrastingColor(mappedList[i])
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
      child: SizedBox(
        width: 500,
        child: LayoutBuilder(builder: (context, builder) {
          return Row(
            children: <Widget>[
              // this is necessary to counter-balance the chevronUp icon at the other side.
              if (leading == null &&
                  (builder.maxWidth > 400 || mappedList.length < 3))
                SizedBox(width: 48),
              if (leading != null)
                leading,
              Expanded(
                child: Center(
                  child: SizedBox(
                    height: 36,
                    child: ListView(
                      shrinkWrap: true,
                      // in a previous iteration, shrinkWrap
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        const SizedBox(width: 16),
                        for (int i = 0; i < mappedList.length; i++) ...[
                          SizedBox(
                            height: 32,
                            child: RawMaterialButton(
                              onPressed: () {
                                colorSelected(
                                  context,
                                  keysList[i],
                                  mappedList[i],
                                );
                              },
                              onLongPress: () {
                                showSlidersDialog(context, mappedList[i]);
                              },
                              fillColor: mappedList[i],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  width: 1,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.7),
                                ),
                              ),
                              textStyle:
                                  Theme.of(context).textTheme.body1.copyWith(
                                        color: contrastedColors[i],
                                        fontWeight: (selected == keysList[i])
                                            ? FontWeight.w700
                                            : FontWeight.w400,
                                      ),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(width: 8),
                                  if (selected == keysList[i])
                                    Icon(
                                      FeatherIcons.checkCircle,
                                      size: 16,
                                      color: contrastedColors[i],
                                    )
                                  else
                                    Icon(
                                      FeatherIcons.circle,
                                      size: 16,
                                      color: contrastedColors[i],
                                    ),
                                  SizedBox(width: 4),
                                  Text(keysList[i]),
                                  SizedBox(width: 8),
                                ],
                              ),
                              elevation: 0.0,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
              ),
              if (isExpanded != null)
                IconButton(
                  tooltip: isExpanded ? "compact" : "expand contrast",
                  icon: Icon(
                    isExpanded
                        ? FeatherIcons.chevronDown
                        : FeatherIcons.chevronUp,
                  ),
                  onPressed: onExpanded,
                ),
            ],
          );
        }),
      ),
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
