import 'package:colorstudio/contrast_ratio/dark_mode_surface_contrast.dart';
import 'package:colorstudio/contrast_ratio/widgets/contrast_widgets.dart';
import 'package:colorstudio/example/blocs/blocs.dart';
import 'package:colorstudio/example/blocs/contrast_ratio/contrast_ratio_state.dart';
import 'package:colorstudio/example/util/constants.dart';
import 'package:colorstudio/example/widgets/loading_indicator.dart';
import 'package:colorstudio/widgets/section_card.dart';
import 'package:colorstudio/widgets/title_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hsluv/hsluvcolor.dart';

class ContrastRatioScreen extends StatelessWidget {
  const ContrastRatioScreen(
    this.rgbColorsWithBlindness,
    this.shouldDisplayElevation,
    this.locked,
  );

  final Map<String, Color> rgbColorsWithBlindness;
  final Map<String, bool> locked;
  final bool shouldDisplayElevation;

  @override
  Widget build(BuildContext context) {
    final surfaceHSLuv =
        HSLuvColor.fromColor(rgbColorsWithBlindness[kBackground]);

    final colorScheme = ColorScheme.dark(
      primary: rgbColorsWithBlindness[kPrimary],
      background: surfaceHSLuv.withLightness(10).toColor(),
      surface: rgbColorsWithBlindness[kSurface],
    );

    return BlocBuilder<ContrastRatioBloc, ContrastRatioState>(
        builder: (context, state) {
      if (state is InitialContrastRatioState) {
        return Center(child: LoadingIndicator());
      }

      final currentState = (state as ContrastRatioSuccess);

      final isiPad = MediaQuery.of(context).size.width > 600;

      final areValuesLocked =
          locked[kSurface] == true && locked[kBackground] == true;

      return Theme(
        data: ThemeData.from(
          colorScheme: colorScheme,
          textTheme: TextTheme(
            body1: GoogleFonts.lato(
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
            title: GoogleFonts.firaSans(fontWeight: FontWeight.w600),
//            title: GoogleFonts.firaMono(fontSize: isiPad ? 16 : 13),
//            subtitle: GoogleFonts.firaMono(fontSize: isiPad ? 14 : 11),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: 8.0,
            bottom: 8.0,
            left: (isiPad == true) ? 24.0 : 16.0,
            right: isiPad ? 8.0 : 16.0,
          ),
          child: SectionCard(
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
                          context,
                          "/multiplecontrastcompare",
                        );
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ContrastCircleBar(
                      title: kPrimary,
                      subtitle: kBackground,
                      contrast: currentState.contrastValues[0],
                      contrastingColor: rgbColorsWithBlindness[kPrimary],
                      circleColor: rgbColorsWithBlindness[kBackground],
                    ),
                    if (!areValuesLocked) ...[
                      ContrastCircleBar(
                        title: kPrimary,
                        subtitle: kSurface,
                        contrast: currentState.contrastValues[1],
                        contrastingColor: rgbColorsWithBlindness[kPrimary],
                        circleColor: rgbColorsWithBlindness[kSurface],
                      ),
                      ContrastCircleBar(
                        title: kSurface,
                        subtitle: kBackground,
                        contrast: currentState.contrastValues[2],
                        contrastingColor: rgbColorsWithBlindness[kSurface],
                        circleColor: rgbColorsWithBlindness[kBackground],
                      ),
                    ],
                  ],
                ),
                // surface qualifies as dark mode
                Text(
                  "Primary / Surface with elevation",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                  ),
                ),
                if (shouldDisplayElevation) ...[
                  SizedBox(height: 8),
                  DarkModeSurfaceContrast(currentState.elevationValues),
                ] else ...[
                  SizedBox(
                    height: 128,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 36.0,
                        vertical: 8.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "In dark surfaces, Material Design Components express depth by displaying lighter surface colors. "
                            "The higher a surface’s elevation (raising it closer to an implied light source), the lighter that surface becomes.\n",
                            style: Theme.of(context).textTheme.caption.copyWith(
                                  color: Colors.white.withOpacity(0.70),
                                ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "You are using a light surface color.",
                            style: Theme.of(context)
                                .textTheme
                                .body2
                                .copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  )
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
