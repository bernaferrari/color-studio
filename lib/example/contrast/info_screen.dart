import 'package:colorstudio/example/blocs/multiple_contrast_color/multiple_contrast_color_state.dart';
import 'package:colorstudio/example/mdc/components.dart';
import 'package:colorstudio/example/util/when.dart';
import 'package:colorstudio/example/widgets/update_color_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen(this.list);

  final List<ContrastedColor> list;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: list[0].rgbColor,
      body: buildInfo(),
    );
  }

  Widget buildInfo() {
    return ListView.builder(
      key: const PageStorageKey("InfoKey"),
      itemCount: list.length,
      itemBuilder: (BuildContext context, int i) {
        if (i == 0) {
          return header(list, 0, true);
        }

        return Material(
          color: list[i].rgbColor,
          child: InkWell(
              onTap: () {
                showSlidersDialog(context, list[i].rgbColor);
              },
              onLongPress: () {
                showSlidersDialog(context, list[i].rgbColor);
              },
              child: header(list, i, false)
//              child: when({
//                () => currentSegment == 0: () =>
//                    rgbInfo(list[0].rgbColor, list[i].rgbColor, false, 1.0),
//                () => currentSegment == 1: () =>
//                    hsluvInfo(list[0].rgbColor, list[i].rgbColor, false, 1.0),
//                () => currentSegment == 2: () =>
//                    hsvInfo(list[0].rgbColor, list[i].rgbColor, false, 1.0),
//              }),
              ),
        );
      },
    );
  }

  Widget header(List<ContrastedColor> list, int index, bool skipDiff) {
    final firstColor = list[0].rgbColor;
    final nthColor = list[index].rgbColor;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: list[index].rgbColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _HeaderTitle("RGB", 0, nthColor),
          const SizedBox(height: 8),
          rgbInfo(
            firstColor,
            nthColor,
            skipDiff,
            1.0,
          ),
          const SizedBox(height: 16),
          _HeaderTitle("HSLuv", 1, nthColor),
          const SizedBox(height: 8),
          hsluvInfo(
            firstColor,
            nthColor,
            skipDiff,
            1.0,
          ),
          const SizedBox(height: 16),
          _HeaderTitle("HSV", 2, nthColor),
          const SizedBox(height: 8),
          hsvInfo(
            firstColor,
            nthColor,
            skipDiff,
            1.0,
          ),
        ],
      ),
    );
  }

  Widget rgbInfo(Color color1, Color color2, bool skipDiff, double opacity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _InfoItem(
          "R",
          color1.red.toDouble(),
          color2.red.toDouble(),
          color2,
          skipDiff,
          opacity,
        ),
        _InfoItem(
          "G",
          color1.green.toDouble(),
          color2.green.toDouble(),
          color2,
          skipDiff,
          opacity,
        ),
        _InfoItem(
          "B",
          color1.blue.toDouble(),
          color2.blue.toDouble(),
          color2,
          skipDiff,
          opacity,
        ),
      ],
    );
  }

  Widget hsluvInfo(Color color1, Color color2, bool skipDiff, double opacity) {
    final hsluv1 = HSLColor.fromColor(color1);
    final hsluv2 = HSLColor.fromColor(color2);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _InfoItem("H", hsluv1.hue, hsluv2.hue, color2, skipDiff, opacity),
        _InfoItem("S", hsluv1.saturation * 100, hsluv2.saturation * 100, color2,
            skipDiff, opacity),
        _InfoItem("L", hsluv1.lightness * 100, hsluv2.lightness * 100, color2,
            skipDiff, opacity),
      ],
    );
  }

  Widget hsvInfo(Color color1, Color color2, bool skipDiff, double opacity) {
    final hsv1 = HSVColor.fromColor(color1);
    final hsv2 = HSVColor.fromColor(color2);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _InfoItem("H", hsv1.hue, hsv2.hue, color2, skipDiff, opacity),
        _InfoItem("S", hsv1.saturation * 100, hsv2.saturation * 100, color2,
            skipDiff, opacity),
        _InfoItem(
            "V", hsv1.value * 100, hsv2.value * 100, color2, skipDiff, opacity),
      ],
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle(this.title, this.index, this.firstColor);

  final String title;
  final int index;
  final Color firstColor;

  @override
  Widget build(BuildContext context) {
    final contrasted = contrastingColor(firstColor);

    return Text(
      title,
      style: Theme.of(context).textTheme.body2.copyWith(color: contrasted),
      textAlign: TextAlign.center,
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem(this.letter, this.valueOrig, this.valueNew, this.color1,
      [this.skipDiff = false, this.opacity = 1.0]);

  final String letter;
  final double valueOrig;
  final double valueNew;
  final Color color1;
  final bool skipDiff;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final Color color = when({
      () => valueNew > valueOrig: () => const Color(0xff1da556),
      () => valueNew == valueOrig: () => const Color(0xff909090),
    }, orElse: () => const Color(0xfffb575f));

    final Color oppositeColor = contrastingColor(color1).withOpacity(opacity);

    String sign;
    if (valueOrig > valueNew) {
      sign = "-";
    } else {
      sign = "+";
    }

//    final percentValue = ((valueNew - valueOrig).abs() / valueOrig) * 100;
//    String percentDescription;
//    if (percentValue > 200) {
//      percentDescription = ">200";
//    } else {
//      percentDescription = percentValue.toStringAsFixed(0);
//    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: 64,
          child: Text(
            "$letter: ${valueNew.toStringAsFixed(0)}",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .title
                .copyWith(color: oppositeColor),
          ),
        ),
        const SizedBox(height: 8),
        if (!skipDiff)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (valueNew != valueOrig)
                Icon(
                  (valueNew > valueOrig)
                      ? FeatherIcons.arrowUp
                      : FeatherIcons.arrowDown,
                  size: 16,
                  color: oppositeColor,
                ),
              const SizedBox(width: 8),
              Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: Text(
                      "$sign${(valueOrig - valueNew).abs().toStringAsFixed(0)}",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .overline
                          .copyWith(color: Colors.white),
                    ),
                  ),
//                  const SizedBox(height: 4),
//                  Container(
//                    width: 52,
//                    decoration: BoxDecoration(
//                        color: color, borderRadius: BorderRadius.circular(4)),
//                    padding: const EdgeInsets.all(2),
//                    child: Text(
//                      "$sign$percentDescription%",
//                      textAlign: TextAlign.center,
//                      style: Theme.of(context)
//                          .textTheme
//                          .overline
//                          .copyWith(color: oppositeColor),
//                    ),
//                  ),
                ],
              ),
              const SizedBox(width: 8),
            ],
          )
      ],
    );
  }
}
