import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hsluv/hsluvcolor.dart';

import '../blocs/blocs.dart';
import '../example/widgets/color_sliders.dart';
import '../example/widgets/selectable_sliders.dart';
import '../screen_single_color/screen_single.dart';
import '../shared_widgets/outlined_icon_button.dart';
import '../util/constants.dart';

class HorizontalSlidersBar extends StatelessWidget {
  const HorizontalSlidersBar({this.onPressed});

  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ColorsCubit, ColorsState>(builder: (_, state) {
      final rgbColor = state.rgbColors[state.selected]!;

      final rgb = RGBSlider(
          color: rgbColor,
          onChanged: (r, g, b) {
            context
                .read<ColorsCubit>()
                .updateColor(rgbColor: Color.fromARGB(255, r, g, b));
          });

      final hsluv = HSLuvSlider(
          color: state.hsluvColors[state.selected]!,
          onChanged: (h, s, l) {
            context
                .read<ColorsCubit>()
                .updateColor(hsLuvColor: HSLuvColor.fromHSL(h, s, l));
          });

      final hsv = HSVSlider(
          color: HSVColor.fromColor(rgbColor),
          onChanged: (h, s, v) {
            final updatedHSV = HSVColor.fromAHSV(1.0, h, s, v);
            context
                .read<ColorsCubit>()
                .updateColor(rgbColor: updatedHSV.toColor());
          });

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                left: 8.0, right: 8.0, top: 12.0, bottom: 8.0),
            child: SliderWithSelector(
              sliders: [rgb, hsluv, hsv],
              color: rgbColor,
              thumbColor: state.rgbColors[ColorType.Background]!,
              context: context,
            ),
          ),
          ThemeBar(
            selected: state.selected,
            rgbColors: state.rgbColors,
            locked: state.locked,
            isExpanded: null,
            leading: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: OutlinedIconButton(
                child: const Icon(FeatherIcons.x, size: 16),
                onPressed: onPressed as void Function()?,
              ),
            ),
          ),
        ],
      );
    });
  }
}
