import 'package:colorstudio/blocs/blocs.dart';
import 'package:colorstudio/blocs/multiple_contrast_compare/rgb_hsluv_tuple.dart';
import 'package:colorstudio/example/mdc/components.dart';
import 'package:colorstudio/example/util/color_util.dart';
import 'package:colorstudio/example/util/constants.dart';
import 'package:colorstudio/example/util/selected.dart';
import 'package:colorstudio/example/util/shuffle_color.dart';
import 'package:colorstudio/example/util/widget_space.dart';
import 'package:colorstudio/example/widgets/loading_indicator.dart';
import 'package:colorstudio/example/widgets/update_color_dialog.dart';
import 'package:colorstudio/screen_home/scheme/same_as.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hsluv/hsluvcolor.dart';

import '../contrast_util.dart';
import 'multi_row_color_picker.dart';
import 'single_row_contrast_color_picker.dart';

class ColorsCompareScreen extends StatelessWidget {
  const ColorsCompareScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MultipleContrastCompareCubit, MultipleColorCompareState>(
        builder:
            (BuildContext builderContext, MultipleColorCompareState state) {
      if (state.colorsCompared.isEmpty) {
        return const Scaffold(body: LoadingIndicator());
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
    // final dynamic result = await showDialog<dynamic>(
    //     context: context,
    //     builder: (BuildContext ctx) {
    //       return AlertDialog(
    //         title: const Text("Drag to reorder"),
    //         contentPadding: const EdgeInsets.only(top: 16),
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(16),
    //         ),
    //         content: Card(
    //           clipBehavior: Clip.antiAlias,
    //           margin: EdgeInsets.zero,
    //           color: compositeColors(
    //             Theme.of(context).colorScheme.background,
    //             Theme.of(context).colorScheme.primary,
    //             0.20,
    //           ),
    //           child: ReorderList(list),
    //         ),
    //       );
    //     });

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
                  _TopSection(
                    rgbColor: colorsCompared[currentKey].rgbColor,
                    hsluvColor: colorsCompared[currentKey].hsluvColor,
                    colorFromSelected: colorsCompared[selectedKey].rgbColor,
                    contrast: colorsCompared[currentKey].contrast,
                    isSelected: currentKey == selectedKey,
                    currentKey: currentKey,
                  ),
                  SingleRowContrastColorPicker(
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
            _TopSection(
              rgbColor: colorsMap[currentKey].rgbColor,
              hsluvColor: colorsMap[currentKey].hsluvColor,
              colorFromSelected: colorsMap[selectedKey].rgbColor,
              contrast: colorsMap[selectedKey].contrast,
              isSelected: selectedKey == currentKey,
              currentKey: currentKey,
            ),
          ],
        ),
        SizedBox(height: 8),
        MultiRowColorPicker(
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

class _TopSection extends StatelessWidget {
  const _TopSection({
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: space(
        16,
        <Widget>[
          if (!isSelected)
            _ContrastWithLetters(
              contrast: contrast,
              colorFromSelected: colorFromSelected,
            ),
          _TopSectionButtons(
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

class _ContrastWithLetters extends StatelessWidget {
  const _ContrastWithLetters({
    @required this.colorFromSelected,
    @required this.contrast,
  });

  final Color colorFromSelected;
  final double contrast;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: colorFromSelected,
    );

    return Column(
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
    );
  }
}

class _TopSectionButtons extends StatelessWidget {
  const _TopSectionButtons({
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
