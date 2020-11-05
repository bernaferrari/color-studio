import 'package:colorstudio/example/blocs/blocs.dart';
import 'package:colorstudio/example/screens/home.dart';
import 'package:colorstudio/example/util/constants.dart';
import 'package:colorstudio/example/vertical_picker/app_bar_actions.dart';
import 'package:colorstudio/example/widgets/color_sliders.dart';
import 'package:colorstudio/example/widgets/selectable_sliders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hsluv/hsluvcolor.dart';

class HorizontalSlidersBar extends StatelessWidget {
  const HorizontalSlidersBar({this.onPressed});

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    final MDCLoadedState currentState =
        context.bloc<MdcSelectedBloc>().state as MDCLoadedState;

    final color = currentState.rgbColors[currentState.selected];

    final rgb = RGBSlider(
        color: color,
        onChanged: (r, g, b) {
          BlocProvider.of<MdcSelectedBloc>(context)
              .add(MDCLoadEvent(currentColor: Color.fromARGB(255, r, g, b)));
        });

    final hsluv = HSLuvSlider(
        color: currentState.hsluvColors[currentState.selected],
        onChanged: (h, s, l) {
          BlocProvider.of<MdcSelectedBloc>(context).add(
            MDCUpdateColor(
              hsLuvColor: HSLuvColor.fromHSL(h, s, l),
              selected: currentState.selected,
            ),
          );
        });

    final hsv = HSVSlider(
        color: HSVColor.fromColor(color),
        onChanged: (h, s, v) {
          final updatedHSV = HSVColor.fromAHSV(1.0, h, s, v);

          BlocProvider.of<MdcSelectedBloc>(context).add(
            MDCLoadEvent(currentColor: updatedHSV.toColor()),
          );
        });

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              left: 8.0, right: 8.0, top: 12.0, bottom: 8.0),
          child: SliderWithSelector(
            [rgb, hsluv, hsv],
            color,
            currentState.rgbColors[kBackground],
            context,
          ),
        ),
        ThemeBar(
          selected: currentState.selected,
          rgbColors: currentState.rgbColors,
          locked: currentState.locked,
          isExpanded: null,
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: OutlinedIconButton(
              child: Icon(FeatherIcons.x, size: 16),
              onPressed: onPressed,
              borderColor: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ),
      ],
    );
  }
}
