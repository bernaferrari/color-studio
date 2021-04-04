import 'package:flutter/material.dart';

import '../../util/color_util.dart';
import '../../util/constants.dart';
import '../util/constants.dart';
import 'widgets/horizontal_progress_bar.dart';

class ContrastText extends StatelessWidget {
  const ContrastText(this.contrast, {this.color, this.withSizedBox = true});

  final double contrast;
  final bool withSizedBox;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final widget = RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: contrast.toStringAsPrecision(3),
        style: Theme.of(context).textTheme.headline6!.copyWith(color: color),
        children: <TextSpan>[
          TextSpan(
            text: ':1',
            style:
                Theme.of(context).textTheme.subtitle1!.copyWith(color: color),
          ),
        ],
      ),
    );

    if (withSizedBox) {
      return SizedBox(
        width: 48,
        child: FittedBox(child: widget),
      );
    } else {
      return widget;
    }
  }
}

class HexCaption extends StatelessWidget {
  const HexCaption(this.color, this.textColor);

  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Text(
      color.toHexStr(),
      style: Theme.of(context).textTheme.caption!.copyWith(color: textColor),
    );
  }
}

class ContrastProgressBar extends StatelessWidget {
  const ContrastProgressBar({
    this.contrast = 0.5,
    this.direction = Axis.horizontal,
  });

  final double contrast;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).colorScheme.onSurface;

    final progressBar = RectangularPercentageWidget(
      percent: getNormalised(contrast) / 100,
      size: 10,
      backgroundColor: bgColor.withOpacity(0.15),
      borderWidth: 0,
      progressColor: getProgressColor(contrast),
      direction: direction,
      verticalDirection: VerticalDirection.up,
    );

    return (direction == Axis.horizontal)
        ? Expanded(child: progressBar)
        : progressBar;
  }

  Color getProgressColor(double contrast) {
    if (contrast < 3.0) {
      return Colors.redAccent[200]!;
    } else if (contrast < 4.5) {
      return Colors.orangeAccent[200]!;
    } else if (contrast < 7) {
      return Colors.lightGreen[200]!;
    } else {
      return Colors.greenAccent[200]!;
    }
  }

  int getNormalised(double contrast) {
    double normalized;

    if (contrast < 7) {
      normalized = (contrast - 1.0) / (7 - 1.0) * 100 * 0.75;
    } else {
      normalized = 75 + (contrast - 7) / (21.0 - 7) * 100 * 0.25;
    }

    return normalized.round();
  }
}

class ColorCompareWidget extends StatelessWidget {
  const ColorCompareWidget(this.firstData, this.secondData);

  final ColorSchemeData firstData;
  final ColorSchemeData secondData;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 48,
          height: 48,
          margin: const EdgeInsets.only(right: 16),
          child: Center(
            child: Text(
              secondData.name[0],
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: secondData.color,
                  ),
            ),
          ),
          decoration: BoxDecoration(
            color: firstData.color,
            // we want primary color border on surface but not the opposite
            // this will give the outline effect.
            border: (secondData.name != kSurface)
                ? Border.all(color: secondData.color)
                : const Border(),
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                firstData.color.toHexStr(),
                style: Theme.of(context).textTheme.caption,
              ),
              Text(
                firstData.name,
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ColorSchemeData {
  ColorSchemeData(this.name, this.color);

  final String name;
  final Color color;
}
