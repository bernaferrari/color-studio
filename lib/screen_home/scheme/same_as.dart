import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../blocs/blocs.dart';
import '../../util/color_util.dart';
import '../../util/constants.dart';

class SameAs extends StatelessWidget {
  const SameAs({
    super.key,
    required this.selected,
    required this.color,
    required this.lightness,
    this.children,
  });

  final ColorType selected;
  final Color color;
  final double lightness;
  final List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    final Color textColor =
        (lightness < kLightnessThreshold) ? Colors.white : Colors.black;

    return Center(
      child: Column(
        children: <Widget>[
          // Divider(height: 0, color: textColor),
          const SizedBox(height: 16),
          Text(
            color.toHexStr(),
            style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            sameAs(),
            style: TextStyle(color: textColor, fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
                // highlightedBorderColor: textColor.withOpacity(0.70),
                // borderSide: BorderSide(color: textColor.withOpacity(0.70)),
                // textColor: textColor,
                ),
            onPressed: () {
              context
                  .read<ColorsCubit>()
                  .updateLock(shouldLock: false, selectedLock: selected);
            },
            icon: Icon(
              FeatherIcons.unlock,
              size: 16,
              color: textColor,
            ),
            label: Text(
              "Manual",
              style: GoogleFonts.b612Mono(
                textStyle: const TextStyle(fontWeight: FontWeight.w700),
                color: textColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (children != null) ...children!
        ],
      ),
    );
  }

  String sameAs() {
    if (selected == ColorType.Surface) {
      return "${kBackground.toUpperCase()} + 5% LIGHTNESS";
    } else if (selected == ColorType.Background) {
      return "8% ${kPrimary.toUpperCase()} + #121212";
    } else if (selected == ColorType.Secondary) {
      return "${kPrimary.toUpperCase()} + 90 OF HUE";
    }
    return "Error";
  }
}
