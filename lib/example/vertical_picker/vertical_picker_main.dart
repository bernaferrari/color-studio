import 'dart:math' as math;

import 'package:colorstudio/example/hsinter.dart';
import 'package:colorstudio/example/util/color_util.dart';
import 'package:colorstudio/example/util/constants.dart';
import 'package:colorstudio/example/util/selected.dart';
import 'package:colorstudio/example/vertical_picker/picker_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hsluv/hsluvcolor.dart';

import '../color_with_inter.dart';
import '../screens/about.dart';
import '../util/constants.dart';
import 'app_bar_actions.dart';
import 'hsluv_selector.dart';
import 'hsv_selector.dart';

const hsvStr = "HSV";
const hsluvStr = "HSLuv";

const hueStr = "Hue";
const satStr = "Saturation";
const valueStr = "Value";
const lightStr = "Lightness";

class HSVerticalPicker extends StatefulWidget {
  const HSVerticalPicker({
    this.color,
    this.hsLuvColor,
    this.isSplitView = false,
  });

  final Color color;
  final HSLuvColor hsLuvColor;
  final bool isSplitView;

  @override
  _HSVerticalPickerState createState() => _HSVerticalPickerState();
}

class _HSVerticalPickerState extends State<HSVerticalPicker> {
  int currentSegment;

  @override
  void initState() {
    currentSegment = PageStorage.of(context).readState(context,
            identifier: const ValueKey("verticalSelected")) ??
        0;

    super.initState();
  }

  void onValueChanged(int newValue) {
    setState(() {
      currentSegment = newValue;
      PageStorage.of(context).writeState(
        context,
        currentSegment,
        identifier: const ValueKey("verticalSelected"),
      );
    });
  }

  final Map<int, Widget> children = const <int, Widget>{
    0: Text("HSLuv"),
    1: Text("HSV"),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${currentSegment == 0 ? "HSLuv" : "HSV"} Picker",
          style: Theme.of(context).textTheme.title,
        ),
        elevation: 0,
        centerTitle: widget.isSplitView,
        leading: widget.isSplitView ? SizedBox.shrink() : null,
        backgroundColor: widget.color,
        actions: <Widget>[
          ColorSearchButton(color: widget.color),
          BorderedIconButton(
            child: Icon(FeatherIcons.moreHorizontal, size: 16),
            onPressed: () {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext ctx) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.all(24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: widget.color,
                      content: Card(
                        clipBehavior: Clip.antiAlias,
                        margin: EdgeInsets.zero,
                        color: Theme.of(context)
                            .colorScheme
                            .background
                            .withOpacity(kVeryTransparent),
                        elevation: 0,
                        child: MoreColors(
                          activeColor: Colors.green,
                        ),
                      ),
                    );
                  });
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      backgroundColor: widget.color,
      body: Column(
        children: <Widget>[
          SizedBox(
            width: 500,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16,
                top: 16,
                bottom: 12,
              ),
              child: CupertinoSlidingSegmentedControl<int>(
                backgroundColor:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.20),
                thumbColor: compositeColors(
                  // this is needed, else component gets ugly with shadow.
                  Theme.of(context).colorScheme.background,
                  Theme.of(context).colorScheme.primary,
                  0.20,
                ),
                children: children,
                onValueChanged: onValueChanged,
                groupValue: currentSegment,
              ),
            ),
          ),
          Expanded(
            child: WatchBoxBuilder(
              box: Hive.box<dynamic>("settings"),
              builder: (BuildContext context, Box box) => currentSegment == 0
                  ? HSLuvSelector(
                      color: widget.hsLuvColor,
                      moreColors: box.get("moreItems", defaultValue: false),
                    )
                  : HSVSelector(
                      color: widget.color,
                      moreColors: box.get("moreItems", defaultValue: false),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class HSGenericScreen extends StatefulWidget {
  const HSGenericScreen({
    this.color,
    this.kind,
    this.fetchHue,
    this.fetchSat,
    this.fetchLight,
    this.hueTitle,
    this.satTitle,
    this.lightTitle,
    this.toneSize,
  });

  final HSInterColor color;
  final String kind;
  final List<ColorWithInter> Function() fetchHue;
  final List<ColorWithInter> Function() fetchSat;
  final List<ColorWithInter> Function() fetchLight;

  final int toneSize;
  final String hueTitle;
  final String satTitle;
  final String lightTitle;

  @override
  _HSGenericScreenState createState() => _HSGenericScreenState();
}

class _HSGenericScreenState extends State<HSGenericScreen> {
  double addValue = 0.0;
  double addSaturation = 0.0;
  bool satSelected = false;
  bool fiveSelected = false;
  int expanded = 0;

  @override
  void initState() {
    super.initState();
    expanded = PageStorage.of(context).readState(context,
            identifier: const ValueKey<String>("VerticalSelector")) ??
        0;
  }

  double interval(double value, double min, double max) {
    return math.min(math.max(value, min), max);
  }

  void modifyAndSaveExpanded(int updatedValue) {
    setState(() {
      expanded = updatedValue;
      PageStorage.of(context).writeState(context, expanded,
          identifier: const ValueKey<String>("VerticalSelector"));
    });
  }

  @override
  Widget build(BuildContext context) {
    final HSInterColor color = widget.color;
    final Color rgbColor = widget.color.toColor();

    // in the ideal the world they could be calculated in the Bloc &/or in parallel.
    final List<ColorWithInter> hue = widget.fetchHue();
    final int hueLen = hue.length;

    final List<ColorWithInter> tones = widget.fetchSat();
    final List<ColorWithInter> values = widget.fetchLight();

    final isColorBrighterThanContrast =
        color.outputLightness() >= kLightnessThreshold;

    final Color borderColor = isColorBrighterThanContrast
        ? Colors.black.withOpacity(0.40)
        : Colors.white.withOpacity(0.40);

    final Widget hueWidget = ExpandableColorBar(
        pageKey: widget.kind,
        title: widget.hueTitle,
        expanded: expanded,
        sectionIndex: 0,
        listSize: hueLen,
        isInfinite: true,
        colorsList: hue,
        onTitlePressed: () => modifyAndSaveExpanded(0),
        onColorPressed: (Color c) {
          modifyAndSaveExpanded(0);
          colorSelected(context, c);
        });

    final satWidget = ExpandableColorBar(
        pageKey: widget.kind,
        title: widget.satTitle,
        expanded: expanded,
        sectionIndex: 1,
        listSize: widget.toneSize,
        colorsList: tones,
        onTitlePressed: () => modifyAndSaveExpanded(1),
        onColorPressed: (Color c) {
          modifyAndSaveExpanded(1);
          colorSelected(context, c);
        });

    final valueWidget = ExpandableColorBar(
      pageKey: widget.kind,
      title: widget.lightTitle,
      expanded: expanded,
      sectionIndex: 2,
      listSize: widget.toneSize,
      colorsList: values,
      onTitlePressed: () => modifyAndSaveExpanded(2),
      onColorPressed: (Color c) {
        modifyAndSaveExpanded(2);
        colorSelected(context, c);
      },
    );

    final List<Widget> widgets = <Widget>[hueWidget, satWidget, valueWidget];

    return Theme(
      data: ThemeData.from(
        colorScheme: isColorBrighterThanContrast
            ? ColorScheme.light(surface: rgbColor)
            : ColorScheme.dark(surface: rgbColor),
        textTheme: Theme.of(context).textTheme.copyWith(
              caption: GoogleFonts.b612Mono(),
              button: GoogleFonts.b612Mono(),
            ),
      ).copyWith(
        cardTheme: Theme.of(context).cardTheme.copyWith(
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: borderColor),
                borderRadius: BorderRadius.circular(defaultRadius),
              ),
            ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 818),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(width: 8),
                    for (int i = 0; i < 3; i++) ...<Widget>[
                      const SizedBox(width: 8),
                      Flexible(
                        flex: (i == expanded) ? 1 : 0,
                        child: LayoutBuilder(
                          // thanks Remi Rousselet for the idea!
                          builder: (BuildContext ctx, BoxConstraints builder) {
                            return AnimatedContainer(
                              width: (i == expanded) ? builder.maxWidth : 64,
                              duration: const Duration(milliseconds: 250),
                              curve: (i == expanded)
                                  ? Curves.easeOut
                                  : Curves.easeIn,
                              child: widgets[i],
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    const SizedBox(width: 8),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: Text(
                  color.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.b612Mono(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
