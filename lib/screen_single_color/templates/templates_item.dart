import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../blocs/blocs.dart';
import '../../util/color_util.dart';
import '../../util/widget_space.dart';

class TemplatePreview extends StatelessWidget {
  const TemplatePreview(this.title, this.colors, this.contrastingColors,
      {super.key});

  final String title;
  final List<Color> colors;
  final List<Color> contrastingColors;

  @override
  Widget build(BuildContext context) {
    final primary = colors[0];
    final background = colors[1];

    final onPrimary = contrastingColors[0];
    final onBackground = contrastingColors[1];

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      color: background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16, top: 12),
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontFamily: "",
                    fontWeight: FontWeight.w900,
                    color: primary,
                  ),
            ),
          ),
          Expanded(
            child: Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  elevation: 0, backgroundColor: primary,
                  // textStyle: TextStyle(color: primary),
                  // side: BorderSide(color: primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: Icon(
                  Icons.graphic_eq,
                  color: onPrimary,
                  size: 16,
                ),
                label: Text(
                  "Select Theme",
                  style: GoogleFonts.b612Mono(
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                    fontSize: 12,
                    color: onPrimary,
                  ),
                ),
                onPressed: () {
                  context.read<ColorsCubit>().fromTemplate(colors: colors);
                },
              ),
            ),
          ),
          // Container(
          //   color: Theme.of(context).colorScheme.onSurface.withOpacity(0.24),
          //   height: 1,
          // ),
          Container(
            color: onBackground.withOpacity(0.10),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: spaceRow(8.0, [
                for (int i = 0; i < colors.length; i++)
                  HexButton(
                    colors[i].toHexStr(),
                    colors[i],
                    contrastingColors[i],
                  )
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class HexButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color onColor;

  const HexButton(this.text, this.color, this.onColor, {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onPressed: () {
        context.read<ColorsCubit>().updateRgbColor(rgbColor: color);
      },
      child: Text(
        text,
        style: GoogleFonts.b612Mono(
          textStyle: Theme.of(context).textTheme.bodyMedium,
          fontSize: 10,
          color: onColor,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
