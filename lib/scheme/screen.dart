import 'package:colorstudio/example/blocs/blocs.dart';
import 'package:colorstudio/example/contrast/shuffle_color.dart';
import 'package:colorstudio/scheme/expandable_item.dart';
import 'package:colorstudio/widgets/section_card.dart';
import 'package:colorstudio/widgets/title_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
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
    final isiPad = MediaQuery.of(context).size.width > 600;

    return Theme(
      data: ThemeData.from(
        colorScheme: Theme.of(context).colorScheme,
        textTheme: TextTheme(
          bodyText2: GoogleFonts.lato(),
          button: GoogleFonts.openSans(),
          headline6: GoogleFonts.openSans(
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
                  IconButton(
                    tooltip: "Randomise colors",
                    icon: Icon(
                      FeatherIcons.shuffle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () async {
                      final box = await Hive.openBox<dynamic>('settings');
                      final int pref = box.get('shuffle', defaultValue: 0);

                      BlocProvider.of<MdcSelectedBloc>(context).add(
                        MDCUpdateAllEvent(colors: getRandomPreference(pref)),
                      );
                    },
                  ),
                ],
              ),
              if (!kIsWeb)
                Divider(
                  height: 0,
                  indent: 1,
                  endIndent: 1,
                ),
              SchemeExpandableItem(rgbColorsWithBlindness, hsluvColors, locked),
            ],
          ),
        ),
      ),
    );
  }
}
