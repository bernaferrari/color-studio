import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../blocs/blocs.dart';
import '../../shared_widgets/outlined_icon_button.dart';
import '../../util/constants.dart';
import '../screens/single_color_blindness.dart';
import 'util/color_blind_from_index.dart';

class ColorBlindnessBar extends StatelessWidget {
  const ColorBlindnessBar({this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ColorsCubit, ColorsState>(builder: (_, state) {
      final ColorWithBlind? blindPrimary = getColorBlindFromIndex(
        state.rgbColors[ColorType.Primary]!,
        state.blindnessSelected,
      );

      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: Container(
            height: 56,
            child: Row(
              children: <Widget>[
                const SizedBox(width: 8),
                OutlinedIconButton(
                  child: Transform.rotate(
                    angle: 0.5 * math.pi,
                    child: Icon(
                      FeatherIcons.sliders,
                      size: 16,
                    ),
                  ),
                  onPressed: onPressed,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        blindPrimary?.name ?? "Color Blindness",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.openSans(
                          textStyle:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                      Text(
                        blindPrimary?.affects ?? "None selected",
                        style: GoogleFonts.openSans(
                          textStyle: Theme.of(context).textTheme.caption,
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                Text(
                  "${state.blindnessSelected}/8",
                  style: GoogleFonts.b612Mono(),
                ),
                const SizedBox(width: 8),
                Material(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.20),
                    ),
                  ),
                  color: state.rgbColorsWithBlindness[kBackground],
                  clipBehavior: Clip.antiAlias,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 48,
                        height: 48,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(),
                          ),
                          child: Icon(FeatherIcons.chevronLeft),
                          onPressed: () {
                            context.read<ColorBlindnessCubit>().decrement();
                          },
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 48,
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.20),
                      ),
                      SizedBox(
                        width: 48,
                        height: 48,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(),
                          ),
                          child: Icon(FeatherIcons.chevronRight),
                          onPressed: () {
                            context.read<ColorBlindnessCubit>().increment();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      );
    });
  }
}
