import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../blocs/blocs.dart';
import '../screens/single_color_blindness.dart';
import '../util/constants.dart';
import '../vertical_picker/app_bar_actions.dart';
import 'util/color_blind_from_index.dart';

class ColorBlindnessBar extends StatelessWidget {
  const ColorBlindnessBar({this.onPressed});

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MdcSelectedBloc, MdcSelectedState>(builder: (_, state) {
      final currentState = state as MDCLoadedState;

      final ColorWithBlind blindPrimary = getColorBlindFromIndex(
        currentState.rgbColors[ColorType.Primary],
        currentState.blindnessSelected,
      );

      return Center(
        child: Container(
          height: 56,
          width: 500,
          child: Row(
            children: <Widget>[
              const SizedBox(width: 8),
              OutlinedIconButton(
                child: Transform.rotate(
                  angle: 0.5 * math.pi,
                  child: const Icon(FeatherIcons.sliders, size: 16),
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
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w600,
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
                "${currentState.blindnessSelected}/8",
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
                color: currentState.rgbColorsWithBlindness[kBackground],
                clipBehavior: Clip.antiAlias,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: FlatButton(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(),
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
                      child: FlatButton(
                        padding: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(),
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
      );
    });
  }
}
