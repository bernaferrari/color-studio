import 'package:colorstudio/color_blindness/screen.dart';
import 'package:colorstudio/contrast_ratio/screen.dart';
import 'package:colorstudio/scheme/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'example/blocs/blocs.dart';
import 'example/util/constants.dart';
import 'example/vertical_picker/app_bar_actions.dart';

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

      final colorScheme = (background.computeLuminance() > kLumContrast)
          ? ColorScheme.light(
              primary: primary,
              secondary: primary,
              background: background,
              surface: surface,
            )
          : ColorScheme.dark(
              primary: primary,
              secondary: primary,
              background: background,
              surface: surface,
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
          cardTheme: Theme.of(context).cardTheme,
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
        Row(
          children: <Widget>[
            SizedBox(width: 28),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Color Studio",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.title.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                      ),
                ),
              ),
            ),
//            Expanded(
//              child: SizedBox.shrink(),
//            ),
            BorderedIconButton(
              child: Icon(FeatherIcons.maximize, size: 16),
              onPressed: () {
                Navigator.pushNamed(context, "/colordetails");
              },
            ),
            BorderedIconButton(
              child: Icon(FeatherIcons.send, size: 16),
              onPressed: () {
                Navigator.pushNamed(context, "/componentspreview");
              },
            ),
            SizedBox(width: 8),
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
