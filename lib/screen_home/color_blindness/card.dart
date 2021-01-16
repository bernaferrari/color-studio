import 'package:colorstudio/screen_home/color_blindness/list_simplified.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/color_blindness_cubit.dart';
import '../../util/constants.dart';
import '../title_bar.dart';
import 'list.dart';

class ColorBlindnessCard extends StatefulWidget {
  final Map<ColorType, Color> rgbColors;
  final Map<ColorType, bool> locked;

  const ColorBlindnessCard(
    this.rgbColors,
    this.locked,
  );

  @override
  _ColorBlindnessCardState createState() => _ColorBlindnessCardState();
}

class _ColorBlindnessCardState extends State<ColorBlindnessCard> {
  bool proMode = false;

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
                tooltip: "Pro Mode",
                icon: Icon(
                  Icons.list_alt_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  setState(() {
                    proMode = !proMode;
                  });
                },
              ),
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
          if (proMode)
            ColorBlindnessList(
              contrastedList: widget.rgbColors,
              locked: widget.locked,
            )
          else
            ColorBlindnessListSimplified(
              contrastedList: widget.rgbColors,
              locked: widget.locked,
            )
        ],
      ),
    );
  }
}
