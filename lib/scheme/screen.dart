import 'package:colorstudio/example/blocs/blocs.dart';
import 'package:colorstudio/example/contrast/shuffle_color.dart';
import 'package:colorstudio/example/util/constants.dart';
import 'package:colorstudio/scheme/expandable_item.dart';
import 'package:colorstudio/widgets/section_card.dart';
import 'package:colorstudio/widgets/title_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hsluv/hsluvcolor.dart';

class ColorSchemeScreen extends StatelessWidget {
  const ColorSchemeScreen(
    this.rgbColorsWithBlindness,
    this.hsluvColors,
    this.locked,
  );

  final Map<String, Color> rgbColorsWithBlindness;
  final Map<String, HSLuvColor> hsluvColors;
  final Map<String, bool> locked;

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        (rgbColorsWithBlindness[kSurface].computeLuminance() > kLumContrast)
            ? ColorScheme.light(
                primary: rgbColorsWithBlindness[kPrimary],
                secondary: rgbColorsWithBlindness[kPrimary],
                background: rgbColorsWithBlindness[kBackground],
                surface: rgbColorsWithBlindness[kSurface],
              )
            : ColorScheme.dark(
                primary: rgbColorsWithBlindness[kPrimary],
                secondary: rgbColorsWithBlindness[kPrimary],
                background: rgbColorsWithBlindness[kBackground],
                surface: rgbColorsWithBlindness[kSurface],
              );

    final isiPad = MediaQuery.of(context).size.width > 600;

    return Theme(
      data: ThemeData.from(
        colorScheme: colorScheme,
        textTheme: TextTheme(
          body1: GoogleFonts.lato(),
          button: GoogleFonts.openSans(),
          title: GoogleFonts.openSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ).copyWith(
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
          color: Theme.of(context).colorScheme.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TitleBar(
                title: "Color Scheme",
                children: <Widget>[
                  // only show the mole button when nothing is locked up.
                  // it adds white to the primary color, if there is only primary
                  // color available, it will always get white. If there is primary + surface,
                  // material random is already sufficient.
                  if (locked[kBackground] != true && locked[kSurface] != true)
                    IconButton(
                      tooltip: "Random mole dark theme",
                      icon: Icon(
                        FeatherIcons.penTool,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        BlocProvider.of<MdcSelectedBloc>(context).add(
                          MDCUpdateAllEvent(colors: getRandomMoleTheme()),
                        );
                      },
                    ),
                  IconButton(
                    tooltip: "Random Material dark theme",
                    icon: Icon(
                      FeatherIcons.moon,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      BlocProvider.of<MdcSelectedBloc>(context).add(
                        MDCUpdateAllEvent(colors: getRandomMaterialDark()),
                      );
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
              SchemeExpandableItem(rgbColorsWithBlindness, hsluvColors, locked),
              Divider(
                height: 0,
                indent: 1,
                endIndent: 1,
                color: colorScheme.onSurface.withOpacity(0.30),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
