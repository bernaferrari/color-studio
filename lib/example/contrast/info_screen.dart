import 'package:colorstudio/example/blocs/multiple_contrast_color/multiple_contrast_color_state.dart';
import 'package:colorstudio/example/mdc/components.dart';
import 'package:colorstudio/example/util/color_util.dart';
import 'package:colorstudio/example/util/constants.dart';
import 'package:colorstudio/example/util/when.dart';
import 'package:colorstudio/example/widgets/update_color_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen(this.list);

  final List<ContrastedColor> list;

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  int currentSegment = 1;

  void onValueChanged(int newValue) {
    setState(() {
      currentSegment = newValue;
    });
  }

  final Map<int, Widget> children = const <int, Widget>{
    0: Text('RGB'),
    1: Text('HSLuv'),
    2: Text('HSV'),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            width: 500,
            color: widget.list[0].rgbColor,
            padding: const EdgeInsets.only(
                left: 16.0, right: 16, top: 16, bottom: 12),
            child: CupertinoSlidingSegmentedControl<int>(
              backgroundColor:
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.20),
              thumbColor: compositeColors(
                Theme.of(context).colorScheme.background,
                Theme.of(context).colorScheme.primary,
                kVeryTransparent,
              ),
              children: children,
              onValueChanged: onValueChanged,
              groupValue: currentSegment,
            ),
          ),
          Expanded(child: buildInfo()),
        ],
      ),
    );
  }

  Widget buildInfo() {
    final list = widget.list;

    return ListView.builder(
      key: const PageStorageKey("InfoKey"),
      itemCount: list.length,
      itemBuilder: (BuildContext context, int i) {
        if (i == 0) {
          return header(list);
        }

        return SizedBox(
          height: 112,
          child: Material(
            color: list[i].rgbColor,
            child: InkWell(
              onTap: () {
                showSlidersDialog(context, list[i].rgbColor);
              },
              onLongPress: () {
                showSlidersDialog(context, list[i].rgbColor);
              },
              child: when({
                () => currentSegment == 0: () =>
                    rgbInfo(list[0].rgbColor, list[i].rgbColor, false, 1.0),
                () => currentSegment == 1: () =>
                    hsluvInfo(list[0].rgbColor, list[i].rgbColor, false, 1.0),
                () => currentSegment == 2: () =>
                    hsvInfo(list[0].rgbColor, list[i].rgbColor, false, 1.0),
              }),
            ),
          ),
        );
      },
    );
  }

  Widget header(List<ContrastedColor> list) {
    final firstColor = list[0].rgbColor;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: list[0].rgbColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          headerText("RGB", 0, firstColor),
          const SizedBox(height: 8),
          rgbInfo(
            firstColor,
            firstColor,
            true,
            currentSegment == 0 ? 1.0 : 0.5,
          ),
          const SizedBox(height: 16),
          headerText("HSLuv", 1, firstColor),
          const SizedBox(height: 8),
          hsluvInfo(
            firstColor,
            firstColor,
            true,
            currentSegment == 1 ? 1.0 : 0.5,
          ),
          const SizedBox(height: 16),
          headerText("HSV", 2, firstColor),
          const SizedBox(height: 8),
          hsvInfo(
            firstColor,
            firstColor,
            true,
            currentSegment == 2 ? 1.0 : 0.5,
          ),
        ],
      ),
    );
  }

  Widget headerText(String title, int index, Color firstColor) {
    final contrasted = contrastingColor(firstColor);

    return Text(
      title,
      style: Theme.of(context).textTheme.body2.copyWith(
            color: contrasted.withOpacity(currentSegment == index ? 1.0 : 0.5),
          ),
      textAlign: TextAlign.center,
    );
  }

  Widget rgbInfo(Color color1, Color color2, bool skipDiff, double opacity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        infoItem(
          "R",
          color1.red.toDouble(),
          color2.red.toDouble(),
          color2,
          skipDiff,
          opacity,
        ),
        infoItem(
          "G",
          color1.green.toDouble(),
          color2.green.toDouble(),
          color2,
          skipDiff,
          opacity,
        ),
        infoItem(
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
        infoItem("H", hsluv1.hue, hsluv2.hue, color2, skipDiff, opacity),
        infoItem("S", hsluv1.saturation * 100, hsluv2.saturation * 100, color2,
            skipDiff, opacity),
        infoItem("L", hsluv1.lightness * 100, hsluv2.lightness * 100, color2,
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
        infoItem("H", hsv1.hue, hsv2.hue, color2, skipDiff, opacity),
        infoItem("S", hsv1.saturation * 100, hsv2.saturation * 100, color2,
            skipDiff, opacity),
        infoItem(
            "V", hsv1.value * 100, hsv2.value * 100, color2, skipDiff, opacity),
      ],
    );
  }

  Widget infoItem(
    String letter,
    double valueOrig,
    double valueNew,
    Color color1,
    bool skipDiff, [
    double opacity = 1.0,
  ]) {
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
                        color: color, borderRadius: BorderRadius.circular(4)),
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
