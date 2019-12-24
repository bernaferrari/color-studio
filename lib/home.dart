import 'package:colorstudio/color_blindness/screen.dart';
import 'package:colorstudio/contrast_ratio/screen.dart';
import 'package:colorstudio/scheme/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'example/blocs/blocs.dart';
import 'example/util/constants.dart';

class Home extends StatelessWidget {
  const Home();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MdcSelectedBloc, MdcSelectedState>(
        builder: (context, state) {
      final currentState = state as MDCLoadedState;

      final primary = currentState.rgbColorsWithBlindness[kPrimary];
      final background = currentState.rgbColorsWithBlindness[kBackground];
      final surface = currentState.rgbColorsWithBlindness[kSurface];

      final onSurface = (currentState.hsluvColors[kSurface].lightness >
              100 - kLumContrast * 100)
          ? Colors.black
          : Colors.white;

      final colorScheme = (background.computeLuminance() > kLumContrast)
          ? ColorScheme.light(
              primary: primary,
              secondary: primary,
              background: background,
              surface: surface,
              onSurface: onSurface,
            )
          : ColorScheme.dark(
              primary: primary,
              secondary: primary,
              background: background,
              surface: surface,
              onSurface: onSurface,
            );

      // this should be faster than rgbColors[kSurface].computeLuminance < kLumContrast
      final bool shouldDisplayElevation =
          currentState.hsluvColors[kSurface].lightness < kLumContrast * 100;

      final isiPad = MediaQuery.of(context).size.width > 600;

      return Theme(
        data: ThemeData.from(
          // todo it would be nice if there were a ThemeData.join
          // because you need to copyWith manually everything every time.
          colorScheme: colorScheme,
//          textTheme: TextTheme(button: TextStyle(fontFamily: "B612Mono")),
        ).copyWith(
          buttonTheme: Theme.of(context).buttonTheme.copyWith(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
        ),
        child: Scaffold(
          body: SafeArea(
            child: isiPad
                ? Center(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: SingleChildScrollView(
                            child: schemeContrast(
                              context,
                              colorScheme,
                              currentState,
                              shouldDisplayElevation,
                            ),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: ColorBlindnessScreen(
                              currentState.rgbColors,
                              currentState.locked,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    children: <Widget>[
                      schemeContrast(
                        context,
                        colorScheme,
                        currentState,
                        shouldDisplayElevation,
                      ),
                      ColorBlindnessScreen(
                        currentState.rgbColors,
                        currentState.locked,
                      ),
                    ],
                  ),
          ),
        ),
      );
    });
  }

  Widget schemeContrast(
    BuildContext context,
    ColorScheme colorScheme,
    MDCLoadedState currentState,
    bool shouldDisplayElevation,
  ) {

    return Column(
      children: <Widget>[
        SizedBox(height: 4),
        Row(
          children: <Widget>[
            SizedBox(width: 16),
            Expanded(
              child: RaisedButton.icon(
                label: Text("Modify"),
                textColor: colorScheme.onSurface,
                icon: Icon(FeatherIcons.sliders, size: 16),
                onPressed: () {
                  Navigator.pushNamed(context, "/colordetails");
                },
                color: colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.3),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: RaisedButton.icon(
                label: Text("Preview"),
                icon: Icon(FeatherIcons.layout, size: 16),
                textColor: colorScheme.onSurface,
                color: colorScheme.surface,
                onPressed: () {
                  Navigator.pushNamed(context, "/componentspreview");
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.3),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
          ],
        ),
        ColorSchemeScreen(
          currentState.rgbColorsWithBlindness,
          currentState.hsluvColors,
          currentState.locked,
        ),
        ContrastRatioScreen(
          currentState.rgbColorsWithBlindness,
          shouldDisplayElevation,
        ),
      ],
    );
  }
}
