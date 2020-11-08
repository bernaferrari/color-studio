import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hsluv/hsluvcolor.dart';

import '../../blocs/blocs.dart';
import '../../screen_home/contrast_ratio/widgets/contrast_widgets.dart';
import '../../screen_home/scheme/widgets/expanded_section.dart';
import '../../screen_single/templates/templates_screen.dart';
import '../mdc/components.dart';
import '../util/constants.dart';
import '../util/selected.dart';
import '../util/when.dart';
import '../vertical_picker/vertical_picker_main.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/update_color_dialog.dart';
import 'color_library.dart';
import 'single_color_blindness.dart';

class SingleColorHome extends StatelessWidget {
  const SingleColorHome({this.isSplitView = false});

  final bool isSplitView;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MdcSelectedBloc, MdcSelectedState>(
        builder: (context, state) {
      final currentState = state as MDCLoadedState;

      final Color selectedRgbColor =
          currentState.rgbColors[currentState.selected];
      final HSLuvColor selectedHsluvColor =
          currentState.hsluvColors[currentState.selected];

      final colorScheme = (selectedHsluvColor.lightness > kLightnessThreshold)
          ? ColorScheme.light(
              primary: selectedRgbColor,
              secondary: selectedRgbColor,
              surface: selectedRgbColor,
            )
          : ColorScheme.dark(
              primary: selectedRgbColor,
              secondary: selectedRgbColor,
              surface: selectedRgbColor,
            );

      return Theme(
        data: ThemeData.from(
          colorScheme: colorScheme,
          textTheme: TextTheme(
            headline6: GoogleFonts.openSans(),
            // subtitle2: GoogleFonts.firaSans(fontWeight: FontWeight.w500),
            // bodyText2: GoogleFonts.firaSans(),
            // bodyText1: GoogleFonts.b612Mono(fontSize: 12),
            // caption: GoogleFonts.firaSans(),
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
          backgroundColor: selectedRgbColor,
          body: DefaultTabController(
            length: 4,
            initialIndex: 0,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: TabBarView(
                    children: [
                      HSVerticalPicker(
                        color: selectedRgbColor,
                        hsLuvColor: selectedHsluvColor,
                        isSplitView: isSplitView,
                      ),
                      SingleColorBlindness(
                        color: selectedRgbColor,
                        isSplitView: isSplitView,
                      ),
                      // About(isSplitView: isSplitView),
                      ColorLibrary(
                        color: selectedRgbColor,
                        isSplitView: isSplitView,
                      ),
                      TemplatesScreen(
                        backgroundColor: selectedRgbColor,
                        isSplitView: isSplitView,
                      ),
                    ],
                  ),
                ),
                _BottomHome(
                  selected: currentState.selected,
                  selectedColor: selectedRgbColor,
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

  final ColorType selected;
  final Color selectedColor;
  final Map<ColorType, Color> rgbColors;
  final Map<ColorType, bool> locked;

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
                // Tab(icon: Icon(FeatherIcons.info)),
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
  final Map<ColorType, Color> rgbColors;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContrastRatioCubit, ContrastRatioState>(
        builder: (context, state) {
      if (state.contrastValues.isEmpty) {
        return const LoadingIndicator();
      }

      return Center(
        child: SizedBox(
          width: 500,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ContrastCircleBar(
                title: kPrimary,
                subtitle: kBackground,
                contrast: state.contrastValues[0],
                animateOnInit: false,
                circleColor: rgbColors[ColorType.Primary],
                contrastingColor: rgbColors[ColorType.Background],
              ),
              // don't show the other circles when their values are useless.
              ContrastCircleBar(
                title: kPrimary,
                subtitle: kSurface,
                contrast: state.contrastValues[1],
                animateOnInit: false,
                circleColor: rgbColors[ColorType.Surface],
                contrastingColor: rgbColors[ColorType.Primary],
              ),
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

  for (var i = -10; i < 0; i += 5) {
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

  final ColorType selected;
  final Map<ColorType, Color> rgbColors;
  final Map<ColorType, bool> locked;
  final bool isExpanded;
  final Function onExpanded;
  final Widget leading;

  void colorSelected(
    BuildContext context,
    ColorType selected,
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
    final Map<ColorType, Color> colorsList = Map.from(rgbColors);

    // remove from the bar items that were locked in the previous screen.
    colorsList.removeWhere((var a, var b) => locked[a] == true);

    final mappedList = colorsList.values.toList();
    final keysList = colorsList.keys.toList();

    final contrastedColors = [
      for (int i = 0; i < mappedList.length; i++)
        contrastingRGBColor(mappedList[i])
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
              if (leading != null) leading,
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
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                elevation: 0.0,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                backgroundColor: mappedList[i],
                                side: BorderSide(
                                  width: 1,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.7),
                                ),
                              ),
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
                                  Text(
                                    describeEnum(keysList[i]),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                          color: contrastedColors[i],
                                          fontWeight: (selected == keysList[i])
                                              ? FontWeight.w700
                                              : FontWeight.w400,
                                        ),
                                  ),
                                  SizedBox(width: 8),
                                ],
                              ),
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

    final Color textColor = (color.lightness < kLightnessThreshold)
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

      final Color primaryColor = allItems[ColorType.Primary];
      final Color surfaceColor = allItems[ColorType.Surface];

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
