import 'package:colorstudio/example/widgets/loading_indicator.dart';
import 'package:colorstudio/scheme/section.dart';
import 'package:colorstudio/widgets/contrast/contrast_widgets.dart';
import 'package:colorstudio/widgets/contrast/scaling_info.dart';
import 'package:colorstudio/widgets/dark_mode_surface_contrast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hsluv/hsluvcolor.dart';

import 'example/blocs/blocs.dart';
import 'example/mdc/blindness.dart';
import 'example/screens/single_color_blindness.dart';
import 'example/util/color_blindness.dart';
import 'example/util/constants.dart';
import 'example/vertical_picker/app_bar_actions.dart';

class Home2 extends StatelessWidget {
  const Home2();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MdcSelectedBloc, MdcSelectedState>(
        builder: (context, state) {
      final currentState = state as MDCLoadedState;

      final primary = currentState.rgbColorsWithBlindness[kPrimary];
      final secondary = currentState.rgbColorsWithBlindness[kSecondary];
      final background = currentState.rgbColorsWithBlindness[kBackground];
      final surface = currentState.rgbColorsWithBlindness[kSurface];

      print("Secundary is $secondary | ${currentState.rgbColorsWithBlindness}");

      final colorScheme = (background.computeLuminance() > kLumContrast)
          ? ColorScheme.light(
              primary: primary,
              secondary: secondary,
              background: background,
              surface: surface,
            )
          : ColorScheme.dark(
              primary: primary,
              secondary: secondary,
              background: background,
              surface: surface,
            );

      final bool shouldDisplayElevation =
          currentState.rgbColors[kSurface].computeLuminance() < kLumContrast;

      return Theme(
        data: ThemeData.from(
          // todo it would be nice if there were a ThemeData.join
          // because you need to copyWith manually everything every time.
          colorScheme: colorScheme,
//          textTheme: TextTheme(button: TextStyle(fontFamily: "B612Mono")),
        ).copyWith(
          cardTheme: Theme.of(context).cardTheme,
          buttonTheme: Theme.of(context).buttonTheme.copyWith(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
        ),
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(width: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              "Material Design",
                              style: Theme.of(context)
                                  .textTheme
                                  .title
                                  .copyWith(color: colorScheme.onSurface),
                            ),
                          ),
                          Expanded(
                            child: SizedBox.shrink(),
                          ),
                          BorderedIconButton(
                            child: Icon(FeatherIcons.maximize, size: 16),
                            onPressed: () {
                              Navigator.pushNamed(context, "/colordetails");
                            },
                          ),
                          SizedBox(width: 16),
                        ],
                      ),
                      ColorSchemeSection(
                        currentState.rgbColorsWithBlindness,
                        currentState.hsluvColors,
                        currentState.locked,
                      ),
                      ContrastRatio2(
                        currentState.rgbColorsWithBlindness,
                        shouldDisplayElevation,
                      ),
                      ColorBlindness2(
                        currentState.rgbColors,
                        currentState.locked,
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class ColorBlindness2 extends StatelessWidget {
  const ColorBlindness2(
    this.contrastedColors,
    this.locked,
  );

  final Map<String, Color> contrastedColors;
  final Map<String, bool> locked;

  @override
  Widget build(BuildContext context) {
    final surfaceHSLuv = HSLuvColor.fromColor(contrastedColors[kBackground]);
    final surfaceColor = surfaceHSLuv.toColor();

    final colorScheme = (surfaceHSLuv.lightness > kLumContrast * 100)
        ? ColorScheme.light(
            primary: contrastedColors[kPrimary],
            secondary: contrastedColors[kSecondary],
            background: surfaceColor,
            surface: contrastedColors[kSurface],
          )
        : ColorScheme.dark(
            primary: contrastedColors[kPrimary],
            secondary: contrastedColors[kSecondary],
            background: surfaceColor,
            surface: contrastedColors[kSurface],
          );

    return Theme(
      data: ThemeData.from(colorScheme: colorScheme),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: GenericMaterial(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TitleBar(
                title: "Color Blindness",
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.chevron_left,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      int newState =
                          (BlocProvider.of<ColorBlindBloc>(context)).state - 1;
                      if (newState < 0) {
                        newState = 8;
                      }
                      BlocProvider.of<ColorBlindBloc>(context).add(newState);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.chevron_right,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      int newState =
                          (BlocProvider.of<ColorBlindBloc>(context)).state + 1;
                      if (newState > 8) {
                        newState = 0;
                      }
                      BlocProvider.of<ColorBlindBloc>(context).add(newState);
                    },
                  ),
                ],
              ),
              Divider(
                height: 0,
                indent: 1,
                endIndent: 1,
                color: colorScheme.onSurface.withOpacity(0.30),
              ),
              ColorBlindnessTheme(
                contrastedList: contrastedColors,
                locked: locked,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// sources:
// https://www.color-blindness.com/
// https://www.color-blindness.com/category/tools/
// https://en.wikipedia.org/wiki/Color_blindness
// https://en.wikipedia.org/wiki/Dichromacy
List<ColorWithBlind> retrieveColorBlindList(Color color) {
  const m = "of males";
  const f = "of females";
  const p = "of population";

  return [
    ColorWithBlind(color, "None", "default"),
    ColorWithBlind(protanomaly(color), "Protanomaly", "1% $m, 0.01% $f"),
    ColorWithBlind(deuteranomaly(color), "Deuteranomaly", "6% $m, 0.4% $f"),
    ColorWithBlind(tritanomaly(color), "Tritanomaly", "0.01% $p"),
    ColorWithBlind(protanopia(color), "Protanopia", "1% $m"),
    ColorWithBlind(deuteranopia(color), "Deuteranopia", "1% $m"),
    ColorWithBlind(tritanopia(color), "Tritanopia", "less than 1% $p"),
    ColorWithBlind(achromatopsia(color), "Achromatopsia", "0.003% $p"),
    ColorWithBlind(achromatomaly(color), "Achromatomaly", "0.001% $p"),
  ];
}

class TitleBar extends StatelessWidget {
  const TitleBar({this.title, this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}

class ContrastRatio2 extends StatelessWidget {
  const ContrastRatio2(this.contrastedColors, this.shouldDisplayElevation);

  final Map<String, Color> contrastedColors;
  final bool shouldDisplayElevation;

  @override
  Widget build(BuildContext context) {
    final surfaceHSLuv = HSLuvColor.fromColor(contrastedColors[kBackground]);

    final colorScheme = ColorScheme.dark(
      primary: contrastedColors[kPrimary],
      secondary: contrastedColors[kSecondary],
      background: surfaceHSLuv.withLightness(10).toColor(),
      surface: contrastedColors[kSurface],
    );

    if (!ScalingInfo.initialized) {
      ScalingInfo.init(context);
    }

    return BlocBuilder<ContrastRatioBloc, ContrastRatioState>(
        builder: (context, state) {
      if (state is InitialContrastRatioState) {
        return Center(child: LoadingIndicator());
      }

      final currentState = (state as ContrastRatioSuccess);

      return Theme(
        data: ThemeData.from(colorScheme: colorScheme),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: GenericMaterial(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TitleBar(
                  title: "Contrast Ratio",
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        FeatherIcons.menu,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                            context, "/multiplecontrastcompare");
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.help_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                Divider(
                  height: 0,
                  indent: 1,
                  endIndent: 1,
                  color: colorScheme.onSurface.withOpacity(0.30),
                ),
                SizedBox(height: 16),
                Text(
                  'PRIMARY',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ContrastCircleBar(
                      title: kSecondary,
                      contrast: currentState.contrastValues[0],
                    ),
                    ContrastCircleBar(
                      title: kBackground,
                      contrast: currentState.contrastValues[1],
                    ),
                    ContrastCircleBar(
                      title: kSurface,
                      contrast: currentState.contrastValues[2],
                    ),
                  ],
                ),
                // surface qualifies as dark mode
                if (shouldDisplayElevation) ...[
                  Text(
                    'Surface with elevation',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  DarkModeSurfaceContrast(currentState.elevationValues),
                ],
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class GenericMaterial extends StatelessWidget {
  const GenericMaterial({this.child, this.color});

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.30),
          width: 1,
        ),
      ),
      color: color,
      child: child,
    );
  }
}
