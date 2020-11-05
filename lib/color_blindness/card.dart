import 'package:colorstudio/color_blindness/list.dart';
import 'package:colorstudio/example/blocs/color_blind/color_blindness_cubit.dart';
import 'package:colorstudio/example/util/constants.dart';
import 'package:colorstudio/widgets/title_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorBlindnessCard extends StatelessWidget {
  const ColorBlindnessCard(
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
                  context.bloc<ColorBlindnessCubit>().decrement();
                },
              ),
              IconButton(
                tooltip: "Next",
                icon: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  context.bloc<ColorBlindnessCubit>().increment();
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
          ColorBlindnessList(
            contrastedList: rgbColors,
            locked: locked,
          ),
        ],
      ),
    );
  }
}
