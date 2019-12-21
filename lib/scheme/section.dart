import 'package:colorstudio/example/blocs/blocs.dart';
import 'package:colorstudio/example/contrast/shuffle_color.dart';
import 'package:colorstudio/example/util/constants.dart';
import 'package:colorstudio/scheme/expandable_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hsluv/hsluvcolor.dart';

import '../home2.dart';

class ColorSchemeSection extends StatelessWidget {
  const ColorSchemeSection(
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

    final title = TitleBar(
      title: "Color Scheme",
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.shuffle,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            BlocProvider.of<MdcSelectedBloc>(context).add(
              MDCUpdateAllEvent(colors: getShuffledColors(3)),
            );
          },
        ),
      ],
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
        child: GenericMaterial(
          color: Theme.of(context).colorScheme.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              title,
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
