import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';
import '../vertical_picker/app_bar_actions.dart';
import '../widgets/color_sliders.dart';
import '../widgets/loading_indicator.dart';

class MultipleSliders extends StatelessWidget {
  const MultipleSliders({this.color, this.isSplitView = false});

  final Color color;
  final bool isSplitView;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SliderColorBloc, SliderColorState>(
        builder: (context, state) {
      if (state is SliderColorLoading) {
        return const Scaffold(body: LoadingIndicator());
      }

      final Widget rgb = RGBSlider(
          color: (state as SliderColorLoaded).rgbColor,
          onChanged: (r, g, b) {
            context.read<SliderColorBloc>().add(MoveRGB(r, g, b));
          });

      final Widget hsl = HSLuvSlider(
          color: (state as SliderColorLoaded).hsluvColor,
          onChanged: (h, s, l) {
            context.read<SliderColorBloc>().add(MoveHSLuv(h, s, l));
          });

      final Widget hsv = HSVSlider(
          color: (state as SliderColorLoaded).hsvColor,
          onChanged: (h, s, v) {
            context.read<SliderColorBloc>().add(MoveHSV(h, s, v));
          });

      return Scaffold(
        appBar: AppBar(
          title: Text("Multiple Sliders"),
          centerTitle: isSplitView,
          elevation: 0,
          backgroundColor: color,
          leading: isSplitView ? SizedBox.shrink() : null,
          actions: <Widget>[
            ColorSearchButton(color: color),
          ],
        ),
        backgroundColor: color,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 818),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                wrapInCard(rgb),
                wrapInCard(hsv),
                wrapInCard(hsl),
              ],
            ),
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
