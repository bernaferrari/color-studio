import 'package:colorstudio/example/contrast/inter_color_with_contrast.dart';
import 'package:colorstudio/example/mdc/widgets/container_with_number.dart';
import 'package:colorstudio/example/util/color_util.dart';
import 'package:colorstudio/example/util/constants.dart';
import 'package:colorstudio/example/util/selected.dart';
import 'package:flutter/material.dart';

import 'util/elevation_overlay.dart';
import 'widgets/FAProgressBar.dart';

class ColorWithContrast {
  ColorWithContrast(this.color, Color color2, [this.name = ""])
      : lum = color.computeLuminance(),
        contrast = calculateContrast(color, color2);

  final Color color;
  final String name;
  final double contrast;
  final double lum;
}

class ContrastComparison extends StatelessWidget {
  const ContrastComparison(
      {this.primaryColor, this.surfaceColor, this.backgroundColor});

  final Color primaryColor;
  final Color surfaceColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: ListView(
        children: <Widget>[
          const SizedBox(height: 16),
          Text(
            "Contrast Ratio",
            style: Theme.of(context).textTheme.title,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Material Design Guidelines follow WCAG.\n3.0:1 minimum for texts larger than 18pt (AA+).\n4.5:1 minimum for texts smaller than 18pt (AA).\n7.0:1 minimum is preferred, when possible (AAA).",
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          if (backgroundColor.computeLuminance() > kLumContrast) ...[
//            VerticalContrastCompare(ColorSchemeData(kPrimary, primaryColor),
//                ColorSchemeData(kSurface, surfaceColor)),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "When using dark surfaces, Material Design Components express depth by displaying lighter surface colors.\n\nYou are using a light surface color.",
                style: Theme.of(context).textTheme.caption,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
          ] else ...[
//            Padding(
//              padding: const EdgeInsets.symmetric(horizontal: 32.0),
//              child: Text(
//                "In a dark theme, at higher levels of elevation, components express depth by displaying lighter surface color. "
//                "The higher a surface’s elevation (raising it closer to an implied light source), the lighter that surface becomes.",
////                    "That lightness is expressed through the application of a semi-transparent overlay using the On Surface color (default: white).",
//                style: Theme.of(context).textTheme.caption,
//                textAlign: TextAlign.justify,
//              ),
//            ),
//            const SizedBox(height: 16),
//            Text(
//              "Primary vs Surface",
//              style: Theme.of(context).textTheme.title,
//              textAlign: TextAlign.center,
//            ),
            const SizedBox(height: 8),
//            ListContrast(),
//            const SizedBox(height: 16),
//            for (int i = 0; i < elevationEntriesList.length; i++)
//              compareWidget(context, i)
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget compareWidget(BuildContext context, int i) {
    final colorWithContrast = ColorWithContrast(
      compositeColors(
        Colors.white,
        surfaceColor,
        elevationEntries[i].overlay,
      ),
      primaryColor,
      "Surface ${elevationEntries[i].elevation.round()}pt",
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      child: RowContrastCompare(
          colorWithContrast: colorWithContrast,
          defaultColor: primaryColor,
          index: elevationEntries[i].elevation.round(),
          onPressed: () {
            colorSelected(context, colorWithContrast.color);
          }),
    );
  }
}

class RowContrastCompare extends StatelessWidget {
  const RowContrastCompare(
      {this.colorWithContrast, this.defaultColor, this.index, this.onPressed});

  final ColorWithContrast colorWithContrast;
  final Color defaultColor;
  final int index;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    final double contrast = colorWithContrast.contrast;

    return OutlineButton(
      onPressed: onPressed,
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: <Widget>[
          ContainerWithNumber(
            index.toString(),
            defaultColor,
            colorWithContrast.color,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        colorWithContrast.name,
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ContrastText(contrast),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 56,
                      child: HexCaption(
                        colorWithContrast.color,
                        Theme.of(context).textTheme.caption.color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ContrastProgressBar(contrast: contrast),
                    const SizedBox(width: 4),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ContrastText extends StatelessWidget {
  const ContrastText(this.contrast, {this.withSizedBox = true});

  final double contrast;
  final bool withSizedBox;

  @override
  Widget build(BuildContext context) {
    final widget = RichText(
      text: TextSpan(
        text: contrast.toStringAsPrecision(3),
        style: Theme.of(context).textTheme.title,
        children: <TextSpan>[
          TextSpan(
            text: ':1',
            style: Theme.of(context).textTheme.title.copyWith(fontSize: 14),
          ),
        ],
      ),
    );

    if (withSizedBox) {
      return SizedBox(
        width: 56,
        child: widget,
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
      style: Theme.of(context).textTheme.caption.copyWith(color: textColor),
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
    final bgColor = (Theme.of(context).brightness == Brightness.light)
        ? Colors.grey[500]
        : Colors.grey[800];

    final progressBar = RectangularPercentageWidget(
      percent: getNormalised(contrast) / 100,
      size: 10,
      backgroundColor: bgColor.withOpacity(0.4),
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
      return Colors.redAccent[200];
    } else if (contrast < 4.5) {
      return Colors.orangeAccent[200];
    } else if (contrast < 7) {
      return Colors.lightGreen[200];
    } else {
      return Colors.greenAccent[200];
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

//class VerticalContrastCompare extends StatelessWidget {
//  const VerticalContrastCompare(this.first, this.second);
//
//  final ColorSchemeData first;
//  final ColorSchemeData second;
//
//  @override
//  Widget build(BuildContext context) {
//    final double contrast = calculateContrast(first.color, second.color);
//
//    return Padding(
//      padding: const EdgeInsets.symmetric(horizontal: 16),
//      child: OutlineButton(
//        onPressed: () {},
//        child: Container(
//          margin: const EdgeInsets.all(16),
//          child: IntrinsicHeight(
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.start,
//              children: <Widget>[
//                Expanded(
//                  child: Column(
//                    children: <Widget>[
//                      ColorCompareWidget(first, second),
//                      const SizedBox(height: 16),
//                      ColorCompareWidget(second, first),
//                    ],
//                  ),
//                ),
//                Column(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    Text(
//                      "contrast",
//                      style: Theme.of(context)
//                          .textTheme
//                          .overline
//                          .copyWith(fontSize: 12),
//                    ),
//                    RichText(
//                      text: TextSpan(
//                        text: contrast.toStringAsPrecision(3),
//                        style: Theme.of(context).textTheme.headline,
//                        children: <TextSpan>[
//                          TextSpan(
//                            text: ':1',
//                            style: Theme.of(context)
//                                .textTheme
//                                .headline
//                                .copyWith(fontSize: 18),
//                          ),
//                        ],
//                      ),
//                    ),
//                  ],
//                ),
//                const SizedBox(width: 16),
//                ContrastProgressBar(
//                  contrast: contrast,
//                  direction: Axis.vertical,
//                ),
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//}

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
              style: Theme.of(context).textTheme.headline.copyWith(
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
                style: Theme.of(context).textTheme.title.copyWith(fontSize: 18),
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
