import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:colorstudio/example/vertical_picker/app_bar_actions.dart';
import 'package:colorstudio/example/widgets/loading_indicator.dart';

import '../blocs/slider_color/slider_color.dart';
import '../widgets/color_sliders.dart';

class MultipleSliders extends StatelessWidget {
  const MultipleSliders();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SliderColorBloc, SliderColorState>(
        builder: (context, state) {
      if (state is SliderColorLoading) {
        return const Scaffold(body: Center(child: LoadingIndicator()));
      }

      final Widget rgb = RGBSlider(
          color: (state as SliderColorLoaded).rgbColor,
          onChanged: (r, g, b) {
            BlocProvider.of<SliderColorBloc>(context).add(MoveRGB(r, g, b));
          });

      final Widget hsl = HSLuvSlider(
          color: (state as SliderColorLoaded).hsluvColor,
          onChanged: (h, s, l) {
            BlocProvider.of<SliderColorBloc>(context).add(MoveHSLuv(h, s, l));
          });

      final Widget hsv = HSVSlider(
          color: (state as SliderColorLoaded).hsvColor,
          onChanged: (h, s, v) {
            BlocProvider.of<SliderColorBloc>(context).add(MoveHSV(h, s, v));
          });

      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 818),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              wrapInCard(rgb),
              wrapInCard(hsv),
              wrapInCard(hsl),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ColorSearchButton(color: (state as SliderColorLoaded).rgbColor),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget wrapInCard(Widget picker) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: picker,
      ),
    );
  }
}
