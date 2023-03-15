import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';
import '../blocs/multiple_contrast_compare/rgb_hsluv_tuple.dart';
import '../contrast_util.dart';
import '../util/constants.dart';

class SingleRowContrastColorPicker extends StatelessWidget {
  const SingleRowContrastColorPicker({
    required this.colorsRange,
    required this.currentKey,
    Key? key,
  }) : super(key: key);

  final ColorType currentKey;
  final List<RgbHSLuvTupleWithContrast> colorsRange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (int i = 0; i < colorsRange.length; i++)
              SizedBox(
                width: 56,
                height: 56,
                child: _ContrastItemCompacted(
                  rgbHsluvTuple: colorsRange[i],
                  contrast: colorsRange[i].contrast,
                  onPressed: () {
                    context.read<ColorsCubit>().updateColor(
                          rgbColor: colorsRange[i].rgbColor,
                          selected: currentKey,
                        );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ContrastItemCompacted extends StatelessWidget {
  const _ContrastItemCompacted({
    required this.rgbHsluvTuple,
    required this.contrast,
    this.onPressed,
  });

  final RgbHSLuvTupleWithContrast rgbHsluvTuple;
  final double contrast;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final textColor = (rgbHsluvTuple.hsluvColor.lightness < kLightnessThreshold)
        ? Colors.white.withOpacity(0.87)
        : Colors.black87;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: rgbHsluvTuple.rgbColor,
        padding: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(),
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            rgbHsluvTuple.hsluvColor.lightness.round().toString(),
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: textColor),
          ),
          Text(
            contrast.toStringAsPrecision(3),
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontSize: 10, color: textColor),
          ),
          Text(
            getContrastLetters(contrast),
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontSize: 8, color: textColor),
          )
        ],
      ),
    );
  }
}
