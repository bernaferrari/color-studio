import 'package:colorstudio/example/contrast/rgb_hsluv_tuple.dart';
import 'package:colorstudio/example/util/constants.dart';
import 'package:colorstudio/example/util/when.dart';
import 'package:flutter/material.dart';

import 'contrast_util.dart';

// class ContrastItem extends StatelessWidget {
//   const ContrastItem({
//     this.color,
//     this.onPressed,
//     this.contrast,
//     this.compactText = false,
//     this.category = "",
//   });
//
//   final InterColorWithContrast color;
//   final Function onPressed;
//   final bool compactText;
//   final double contrast;
//   final String category;
//
//   @override
//   Widget build(BuildContext context) {
//     final Color textColor = (color.lum < kLumContrast)
//         ? Colors.white.withOpacity(0.87)
//         : Colors.black87;
//
//     final HSInterColor inter = color.inter;
//
//     final String writtenValue = when<String>({
//       () => category == hueStr: () => inter.hue.round().toString(),
//       () => category == satStr: () => "${inter.outputSaturation()}",
//       () => category == lightStr || category == valueStr: () =>
//           "${inter.outputLightness()}",
//     });
//
//     Widget cornerText;
//     if (compactText) {
//       cornerText = Text(
//         writtenValue,
//         style: Theme.of(context).textTheme.caption.copyWith(color: textColor),
//       );
//     } else {
//       cornerText = Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Text(
//             writtenValue,
//             style:
//                 Theme.of(context).textTheme.caption.copyWith(color: textColor),
//           ),
//           Text(
//             contrast.toStringAsPrecision(3),
//             style: Theme.of(context)
//                 .textTheme
//                 .caption
//                 .copyWith(fontSize: 10, color: textColor),
//           ),
//           Text(
//             getContrastLetters(contrast),
//             style: Theme.of(context)
//                 .textTheme
//                 .caption
//                 .copyWith(fontSize: 8, color: textColor),
//           )
//         ],
//       );
//     }
//
//     return SizedBox(
//       width: 56,
//       child: MaterialButton(
//         elevation: 0,
//         padding: EdgeInsets.zero,
//         color: color.color,
//         shape: const RoundedRectangleBorder(),
//         onPressed: onPressed,
//         child: cornerText,
//       ),
//     );
//   }
// }

class ContrastItem3 extends StatelessWidget {
  const ContrastItem3({
    this.rgbHsluvTuple,
    this.onPressed,
    this.contrast,
    this.category = "",
  });

  final RgbHSLuvTupleWithContrast rgbHsluvTuple;
  final Function onPressed;
  final double contrast;
  final String category;

  @override
  Widget build(BuildContext context) {
    final hsluvColor = rgbHsluvTuple.hsluvColor;

    final Color textColor = (hsluvColor.lightness < kLightnessThreshold)
        ? Colors.white.withOpacity(0.87)
        : Colors.black87;

    final String writtenValue = when<String>({
      () => category == hueStr: () => hsluvColor.hue.round().toString(),
      () => category == satStr: () => hsluvColor.saturation.round().toString(),
      () => category == lightStr || category == valueStr: () =>
          hsluvColor.lightness.round().toString(),
    });

    return SizedBox(
      width: 56,
      child: MaterialButton(
        elevation: 0,
        padding: EdgeInsets.zero,
        color: hsluvColor.toColor(),
        shape: const RoundedRectangleBorder(),
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              writtenValue,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(color: textColor),
            ),
            Text(
              contrast.toStringAsPrecision(3),
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(fontSize: 10, color: textColor),
            ),
            Text(
              getContrastLetters(contrast),
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(fontSize: 8, color: textColor),
            )
          ],
        ),
      ),
    );
  }
}

class ContrastItem2 extends StatelessWidget {
  const ContrastItem2({
    this.rgbHsluvTuple,
    this.onPressed,
    this.category = "",
  });

  final RgbHSLuvTuple rgbHsluvTuple;
  final Function onPressed;
  final String category;

  @override
  Widget build(BuildContext context) {
    final hsluv = rgbHsluvTuple.hsluvColor;

    final Color textColor = (hsluv.lightness < kLightnessThreshold)
        ? Colors.white.withOpacity(0.87)
        : Colors.black87;

    final String writtenValue = when<String>({
      () => category == hueStr: () => hsluv.hue.round().toString(),
      () => category == satStr: () => hsluv.saturation.round().toString(),
      () => category == lightStr || category == valueStr: () =>
          hsluv.lightness.round().toString(),
    });

    return SizedBox(
      width: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: EdgeInsets.zero,
          primary: rgbHsluvTuple.rgbColor,
          shape: const RoundedRectangleBorder(),
        ),
        onPressed: onPressed,
        child: Text(
          writtenValue,
          style: Theme.of(context).textTheme.caption.copyWith(color: textColor),
        ),
      ),
    );
  }
}
