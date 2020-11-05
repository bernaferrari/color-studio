import 'package:colorstudio/example/util/when.dart';

const hsvStr = "HSV";
const hsluvStr = "HSLuv";

const hueStr = "Hue";
const satStr = "Saturation";
const valueStr = "Value";
const lightStr = "Lightness";

String getContrastLetters(double contrast) {
  return when({
    () => contrast < 2.9: () => "fail",
    () => contrast < 4.5: () => "AA+",
    () => contrast < 7.0: () => "AA",
    () => contrast < 25: () => "AAA",
  });
}
