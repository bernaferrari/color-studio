import 'package:colorstudio/color_blindness/list.dart';
import 'package:colorstudio/example/blocs/color_blind/color_blind_bloc.dart';
import 'package:colorstudio/example/util/constants.dart';
import 'package:colorstudio/widgets/section_card.dart';
import 'package:colorstudio/widgets/title_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hsluv/hsluvcolor.dart';

import '../home.dart';

class ColorBlindnessScreen extends StatelessWidget {
  const ColorBlindnessScreen(
    this.contrastedColors,
    this.locked,
  );

  final Map<String, Color> contrastedColors;
  final Map<String, bool> locked;

  @override
  Widget build(BuildContext context) {
    final surfaceHSLuv = HSLuvColor.fromColor(contrastedColors[kBackground]);
    final surfaceColor = surfaceHSLuv.toColor();

    final colorScheme = (surfaceHSLuv.lightness > 100 - kLumContrast * 100)
        ? ColorScheme.light(
            primary: contrastedColors[kPrimary],
            background: surfaceColor,
            surface: contrastedColors[kSurface],
          )
        : ColorScheme.dark(
            primary: contrastedColors[kPrimary],
            background: surfaceColor,
            surface: contrastedColors[kSurface],
          );

    final isiPad = MediaQuery.of(context).size.width > 600;

    return Theme(
      data: ThemeData.from(
        colorScheme: colorScheme,
        textTheme: TextTheme(
          title: GoogleFonts.openSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          caption: GoogleFonts.openSans(),
        ),
      ).copyWith(),
      child: Padding(
        padding: EdgeInsets.only(
          top: 8.0,
          bottom: 8.0,
          left: (isiPad == true) ? 8.0 : 16.0,
          right: isiPad ? 24.0 : 16.0,
        ),
        child: SectionCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              ColorBlindnessList(
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
