import 'package:colorstudio/screen_home/color_blindness/list_simplified.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/color_blindness_cubit.dart';
import '../../example/util/constants.dart';
import '../title_bar.dart';
import 'list.dart';

class ColorBlindnessCardSimplified extends StatelessWidget {
  const ColorBlindnessCardSimplified(
    this.rgbColors,
    this.locked,
  );

  final Map<ColorType, Color> rgbColors;
  final Map<ColorType, bool> locked;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TitleBar(
            title: "Color Blindness",
            children: <Widget>[
              IconButton(
                tooltip: "Previous",
                icon: Icon(
                  Icons.chevron_left,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  context.read<ColorBlindnessCubit>().decrement();
                },
              ),
              IconButton(
                tooltip: "Next",
                icon: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  context.read<ColorBlindnessCubit>().increment();
                },
              ),
            ],
          ),
          Container(
            height: 1,
            margin: EdgeInsets.only(top: 1),
            width: double.infinity,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.20),
          ),
          ColorBlindnessListSimplified(
            contrastedList: rgbColors,
            locked: locked,
          ),
        ],
      ),
    );
  }
}
