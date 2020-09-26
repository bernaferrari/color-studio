import 'package:colorstudio/contrast_ratio/dark_mode_surface_contrast.dart';
import 'package:colorstudio/contrast_ratio/widgets/contrast_widgets.dart';
import 'package:colorstudio/example/blocs/blocs.dart';
import 'package:colorstudio/example/blocs/contrast_ratio/contrast_ratio_cubit.dart';
import 'package:colorstudio/example/util/constants.dart';
import 'package:colorstudio/example/widgets/loading_indicator.dart';
import 'package:colorstudio/widgets/section_card.dart';
import 'package:colorstudio/widgets/title_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class ContrastRatioCard extends StatelessWidget {
  const ContrastRatioCard(
    this.rgbColorsWithBlindness,
    this.shouldDisplayElevation,
    this.locked,
  );

  final Map<String, Color> rgbColorsWithBlindness;
  final Map<String, bool> locked;
  final bool shouldDisplayElevation;

  @override
  Widget build(BuildContext context) {
    final state =
        BlocProvider.of<MdcSelectedBloc>(context).state as MDCLoadedState;
    context.bloc<ContrastRatioCubit>().set(state.rgbColorsWithBlindness);

    return BlocBuilder<ContrastRatioCubit, ContrastRatioState>(
        builder: (context, state) {
      if (state.contrastValues.isEmpty) {
        return const Center(child: LoadingIndicator());
      }

      final background = rgbColorsWithBlindness[kSurface];

      final isiPad = MediaQuery.of(context).size.width > 600;

      const areValuesLocked = false;

      return Theme(
        data: ThemeData.from(
          colorScheme: Theme.of(context).colorScheme,
          textTheme: TextTheme(
            bodyText2: GoogleFonts.firaSans(
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
            headline6: GoogleFonts.firaSans(fontWeight: FontWeight.w600),
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
            color: background,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TitleBar(
                  title: "Contrast Ratio",
                  children: <Widget>[
                    IconButton(
                      tooltip: "Contrast compare",
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
                      tooltip: "Help",
                      icon: Icon(
                        Icons.help_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        showDialog<dynamic>(
                            context: context,
                            builder: (BuildContext ctx) {
                              return _HelpDialog(
                                background: background,
                              );
                            });
                      },
                    ),
                  ],
                ),
                const Divider(
                  height: 0,
                  indent: 1,
                  endIndent: 1,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ContrastCircleBar(
                      title: kPrimary,
                      subtitle: kBackground,
                      contrast: state.contrastValues[0],
                      contrastingColor: rgbColorsWithBlindness[kPrimary],
                      circleColor: rgbColorsWithBlindness[kBackground],
                    ),
                    if (!areValuesLocked) ...[
                      ContrastCircleBar(
                        title: kPrimary,
                        subtitle: kSurface,
                        contrast: state.contrastValues[1],
                        contrastingColor: rgbColorsWithBlindness[kPrimary],
                        circleColor: rgbColorsWithBlindness[kSurface],
                      ),
                      ContrastCircleBar(
                        title: kSurface,
                        subtitle: kBackground,
                        contrast: state.contrastValues[2],
                        contrastingColor: rgbColorsWithBlindness[kSurface],
                        circleColor: rgbColorsWithBlindness[kBackground],
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                // surface qualifies as dark mode
                Text(
                  "Primary / Surface with elevation",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                if (shouldDisplayElevation) ...[
                  const SizedBox(height: 8),
                  DarkModeSurfaceContrast(state.elevationValues),
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
                            style: Theme.of(context).textTheme.caption,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "You are using a light surface color.",
                            style: Theme.of(context).textTheme.bodyText1,
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  )
                ],
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _HelpDialog extends StatelessWidget {
  const _HelpDialog({this.background});

  final Color background;

  @override
  Widget build(BuildContext context) {
    /// I am REALLY NOT PROUD of this class!
    /// Really wish Flutter had a better Markdown support.
    /// The existing package was really buggy, so this approach was necessary.
    return AlertDialog(
      title: const Text("Contrast Ratio"),
      contentPadding: const EdgeInsets.only(top: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        color: background,
        child: SizedBox(
          width: 500,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // good resources:
                  // https://www.w3.org/TR/WCAG21/#contrast-minimum
                  // https://usecontrast.com/guide
                  // https://material.io/design/color/dark-theme.html
                  // https://blog.cloudflare.com/thinking-about-color/
                  Text(
                    "WACG recommends a contrast of:",
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "3.0:1 minimum for texts larger than 18pt or icons (AA+).\n4.5:1 minimum for texts smaller than 18pt (AA).\n7.0:1 minimum when possible, if possible (AAA).",
                  ),
                  Text(
                    "\nMost design specifications, including Material, follow this.",
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Text(
                    "There is a formula that calculates the apparent contrast between two colors.",
                    style: Theme.of(context).textTheme.caption,
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Surface with elevation",
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "In a dark theme, at higher levels of elevation, Material Design Components express depth by displaying a lighter surface color. " +
                        "The higher a surface’s elevation (raising it closer to an implied light source), the lighter that surface becomes. " +
                        "That lightness is expressed through the application of a semi-transparent overlay using the OnSurface color (default: white).",
                  ),
                  SizedBox(height: 24),
                  Text(
                    "HSLuv",
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "This app makes heavy usage of HSLuv."
                    " RGB is unintuitive, HSV and HSL are flawed. When you change the Hue or Saturation in them, the appearent lightness also changes. ",
                  ),
                  SizedBox(height: 8),
                  Text(
                    "HSLuv extends CIELUV, which was based on human experiments, for a perceptual uniform color model." +
                        " This means: when you change the Hue or Saturation in HSLuv, the appearent/perceptual lightness will not vary wildly. This makes a lot easier to design color systems, since you can adjust a color without changing the contrast.",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
