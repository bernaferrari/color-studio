import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../blocs/blocs.dart';
import '../../util/constants.dart';
import 'widgets/contrast_widgets.dart';

class ContrastCircleGroup extends StatelessWidget {
  const ContrastCircleGroup({
    super.key,
    required this.state,
    required this.rgbColorsWithBlindness,
    required this.isInCard,
  });

  final ContrastRatioState state;
  final Map<ColorType, Color>? rgbColorsWithBlindness;
  final bool isInCard;

  @override
  Widget build(BuildContext context) {
    final sizeCondition = MediaQuery.of(context).size.width > 850 || !isInCard;

    return Flex(
      direction: sizeCondition ? Axis.horizontal : Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (state.selectedColorType == ColorType.Primary ||
            state.selectedColorType == ColorType.Secondary) ...[
          ContrastCircle(
            title: describeEnum(state.selectedColorType),
            subtitle: describeEnum(ColorType.Background),
            contrast: state.contrastValues[0],
            contrastingColor: rgbColorsWithBlindness![state.selectedColorType],
            circleColor: rgbColorsWithBlindness![ColorType.Background],
            sizeCondition: sizeCondition,
          ),
          ContrastCircle(
            title: describeEnum(state.selectedColorType),
            subtitle: describeEnum(ColorType.Surface),
            contrast: state.contrastValues[1],
            contrastingColor: rgbColorsWithBlindness![state.selectedColorType],
            circleColor: rgbColorsWithBlindness![ColorType.Surface],
            sizeCondition: sizeCondition,
          ),
        ] else if (state.selectedColorType == ColorType.Background ||
            state.selectedColorType == ColorType.Surface) ...[
          ContrastCircle(
            title: describeEnum(state.selectedColorType),
            subtitle: describeEnum(ColorType.Primary),
            contrast: state.contrastValues[0],
            contrastingColor: rgbColorsWithBlindness![ColorType.Primary],
            circleColor: rgbColorsWithBlindness![state.selectedColorType],
            sizeCondition: sizeCondition,
          ),
          ContrastCircle(
            title: describeEnum(state.selectedColorType),
            subtitle: describeEnum(ColorType.Secondary),
            contrast: state.contrastValues[1],
            contrastingColor: rgbColorsWithBlindness![ColorType.Secondary],
            circleColor: rgbColorsWithBlindness![state.selectedColorType],
            sizeCondition: sizeCondition,
          ),
        ]
      ],
    );
  }
}
