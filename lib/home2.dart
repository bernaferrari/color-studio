import 'package:colorstudio/color_blindness/screen.dart';
import 'package:colorstudio/contrast_ratio/screen.dart';
import 'package:colorstudio/scheme/section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import 'example/blocs/blocs.dart';
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
//      final secondary = currentState.rgbColorsWithBlindness[kSecondary];
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

      final bool shouldDisplayElevation =
          currentState.rgbColors[kSurface].computeLuminance() < kLumContrast;

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
            SizedBox(width: 16),
          ],
        ),
        ColorSchemeSection(
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
            style: GoogleFonts.openSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ...children,
      ],
    );
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
