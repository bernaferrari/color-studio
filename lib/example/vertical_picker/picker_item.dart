import 'package:colorstudio/example/util/constants.dart';
import 'package:colorstudio/example/util/selected.dart';
import 'package:colorstudio/example/util/when.dart';
import 'package:colorstudio/example/widgets/update_color_dialog.dart';
import 'package:flutter/material.dart';

import '../color_with_inter.dart';
import '../hsinter.dart';
import 'vertical_picker_main.dart';

class ColorCompareWidgetDetails extends StatelessWidget {
  const ColorCompareWidgetDetails({
    this.color,
    this.onPressed,
    this.compactText = true,
    this.category = "",
    this.kind,
  });

  final ColorWithInter color;
  final Function onPressed;
  final bool compactText;
  final String category;
  final String kind;

  @override
  Widget build(BuildContext context) {
    final Color textColor = (color.lum < kLumContrast)
        ? Colors.white.withOpacity(0.87)
        : Colors.black87;

    final HSInterColor inter = color.inter;

    final String writtenValue = when<String>({
      () => category == hueStr: () => inter.hue.round().toString(),
      () => category == satStr: () => "${inter.outputSaturation()}%",
      () => category == lightStr || category == valueStr: () =>
          "${inter.outputLightness()}%",
    });

    final Widget cornerText = Text(
      writtenValue,
      style: Theme.of(context).textTheme.caption.copyWith(color: textColor),
    );

    final Widget centeredText =
        richTextColorToHSV(context, inter, textColor, category[0]);

    return Padding(
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: 56,
        child: MaterialButton(
          color: color.color,
          elevation: 0,
          shape: const RoundedRectangleBorder(),
          onPressed: onPressed ??
              () {
                colorSelected(context, color.color);
              },
          onLongPress: () {
            showSlidersDialog(context, color.color);
          },
          child: compactText ? centeredText : cornerText,
        ),
      ),
    );
  }

  TextStyle themedHSVSpan(
    TextStyle theme,
    Color textColor,
    bool isHighlighted,
    double side,
  ) {
    return theme.copyWith(
      fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w400,
      color: textColor.withOpacity(isHighlighted ? 1 : 0.5),
      // 12 doesn't fit all screens.
      fontSize: side < 400 ? 10 : 12,
    );
  }

  Widget richTextColorToHSV(BuildContext context, HSInterColor hsi,
      Color textColor, String category) {
    final TextStyle theme = Theme.of(context).textTheme.caption;

    final shortestSide = MediaQuery.of(context).size.width;

    final String letterLorV = when({
      () => kind == hsluvStr: () => "L",
      () => kind == hsvStr: () => "V",
    });

    return RichText(
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: "H:${hsi.hue.round()} ",
            style: themedHSVSpan(
              theme,
              textColor,
              category == "H",
              shortestSide,
            ),
          ),
          TextSpan(
            text: 'S:${hsi.outputSaturation()}% ',
            style:
                themedHSVSpan(theme, textColor, category == "S", shortestSide),
          ),
          TextSpan(
            text: '$letterLorV:${hsi.outputLightness()}%',
            style: themedHSVSpan(
                theme, textColor, category == letterLorV, shortestSide),
          ),
        ],
      ),
    );
  }
}
