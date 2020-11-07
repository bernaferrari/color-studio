import 'dart:math';
import 'dart:ui';

import 'package:hsluv/hsluvcolor.dart';

import 'calculate_contrast.dart';
import 'constants.dart';

class _ColorContrast {
  const _ColorContrast(this.color, this.contrast);

  final Color color;
  final double contrast;
}

extension on String {
  Color hexToColor() => Color(int.parse("0xFF${this}"));
}

Color shuffleColor(Color currentColor) {
  final contrasts = colorClaim.map((i) {
    final color = Color(int.parse("0xFF$i"));
    return _ColorContrast(color, calculateContrast(color, currentColor));
  }).toList();

  final count =
      contrasts.fold(0, (int t, e) => t + ((e.contrast > 3.0) ? 1 : 0));
  if (count < 5) {
    contrasts.shuffle();
    return contrasts.first.color;
  } else {
    final restrictedList = contrasts.where((c) => c.contrast > 3.0).toList()
      ..shuffle();
    return restrictedList.first.color;
  }
}

List<Color> getColorClaim() {
  return colorClaim.map((f) => f.hexToColor()).toList();
}

Color getShuffleColor() {
  final colorsList = colorClaim.toList()..shuffle();
  return colorsList.first.hexToColor();
}

List<Color> getShuffledColors([int n = 8]) {
  final colorsList = colorClaim.toList()..shuffle();
  return [for (int i = 0; i < n; i++) colorsList[i].hexToColor()];
}

// Also check RandomColorScheme: https://github.com/bernaferrari/RandomColorScheme
Map<ColorType, Color> getRandomMaterialDark() {
  final rng = Random();

  // avoid too similar values between background and surface.
  final backgroundLightness = rng.nextInt(26);
  var surfaceLightness = rng.nextInt(31);
  if ((surfaceLightness - backgroundLightness).abs() < 5) {
    surfaceLightness = backgroundLightness + 5;
  }

  final primaryHue = rng.nextInt(360);
  final primarySaturation = 60 + rng.nextInt(41).toDouble();
  final primaryLightness = 65 + rng.nextInt(21).toDouble();

  return {
    ColorType.Primary: HSLuvColor.fromHSL(
      primaryHue.toDouble(),
      primarySaturation,
      primaryLightness.toDouble(),
    ).toColor(),
    ColorType.Secondary: HSLuvColor.fromHSL(
      ((primaryHue + 90 + rng.nextInt(90)) % 360).toDouble(),
      primarySaturation,
      primaryLightness,
    ).toColor(),
    ColorType.Surface: HSLuvColor.fromHSL(
      rng.nextInt(360).toDouble(),
      rng.nextInt(101).toDouble(),
      surfaceLightness.toDouble(),
    ).toColor(),
    ColorType.Background: HSLuvColor.fromHSL(
      rng.nextInt(360).toDouble(),
      rng.nextInt(101).toDouble(),
      backgroundLightness.toDouble(),
    ).toColor(),
  };
}

// Also check RandomColorScheme: https://github.com/bernaferrari/RandomColorScheme
Map<ColorType, Color> getRandomMaterialLight() {
  final rng = Random();

  final primaryHue = rng.nextInt(360);
  final primarySaturation = 80.0 + rng.nextInt(16);
  final primaryLightness = 25 + rng.nextInt(21);

  return {
    ColorType.Primary: HSLuvColor.fromHSL(
      primaryHue.toDouble(),
      primarySaturation,
      primaryLightness.toDouble(),
    ).toColor(),
    ColorType.Secondary: HSLuvColor.fromHSL(
      ((primaryHue + 90 + rng.nextInt(90)) % 360).toDouble(),
      primarySaturation,
      primaryLightness.toDouble(),
    ).toColor(),
    ColorType.Surface: HSLuvColor.fromHSL(
      rng.nextInt(360).toDouble(),
      20.0 + rng.nextInt(81),
      primaryLightness + 45.0 + rng.nextInt(56 - primaryLightness),
    ).toColor(),
    ColorType.Background: HSLuvColor.fromHSL(
      rng.nextInt(360).toDouble(),
      rng.nextInt(71).toDouble(),
      primaryLightness + 45.0 + rng.nextInt(56 - primaryLightness),
    ).toColor(),
  };
}

Map<ColorType, Color> getRandomMoleTheme() {
  final rng = Random();

  // ### Primary Color Study
  // ## Light Theme
  // # Material colors in HSV:
  // H: 265 S: 100 V: 93
  // H: 174 S: 99 V: 85
  // Therefore, S > 90 and V > 80
  //
  // # Material colors in HSLuv:
  // H: 272 S: 100 L: 36
  // H: 177 S: 100 L: 79
  // Therefore, S > 90 and 35 < L < 80

  final backgroundLightness = 5 + rng.nextInt(55);
  final backgroundSat = (25 + rng.nextInt(75)).toDouble();
  final backgroundHue = rng.nextInt(360).toDouble();

  return {
    ColorType.Primary:
        HSLuvColor.fromHSL(rng.nextInt(360).toDouble(), 0, 100).toColor(),
    ColorType.Background: HSLuvColor.fromHSL(
      backgroundHue,
      backgroundSat,
      backgroundLightness.toDouble(),
    ).toColor(),
    ColorType.Surface: HSLuvColor.fromHSL(
      backgroundHue,
      backgroundSat,
      backgroundLightness + 5.0,
    ).toColor(),
  };
}

Map<ColorType, Color> getRandomMaterial() {
  final rng = Random();
  final isDark = rng.nextInt(2) % 2 == 0;
  return isDark ? getRandomMaterialDark() : getRandomMaterialLight();
}

Map<ColorType, Color> getRandomPreference(int prefs) {
  if (prefs == 0) {
    return getRandomMaterialDark();
  } else if (prefs == 1) {
    return getRandomMaterialLight();
  } else if (prefs == 2) {
    return getRandomMaterial();
  } else if (prefs == 3) {
    final rng = Random();

    // return [
    //   for (int i = 0; i < 3; i++)
    //     Color.fromARGB(
    //       255,
    //       rng.nextInt(256),
    //       rng.nextInt(256),
    //       rng.nextInt(256),
    //     )
    // ];
  }

  // return <Color>[];
}

// https://www.vanschneider.com/colors
const List<String> colorClaim = [
  "FF8B8B",
  "F9F7E8",
  "61BFAD",
  "E54B4B",
  "167C80",
  "B7E3E4",
  "EFE8D8",
  "005397",
  "32B67A",
  "FACA0C",
  "F3C9DD",
  "0BBCD6",
  "BFB5D7",
  "BEA1A5",
  "F0CF61",
  "0E38B1",
  "A6CFE2",
  "371722",
  "C7C6C4",
  "DABAAE",
  "DB9AAD",
  "F1C3B8",
  "EF3E4A",
  "C0C2CE",
  "EEC0DB",
  "B6CAC0",
  "C5BEAA",
  "FDF06F",
  "EDB5BD",
  "17C37B",
  "2C3979",
  "1B1D1C",
  "E88565",
  "FFEFE5",
  "F4C7EE",
  "77EEDF",
  "E57066",
  "EED974",
  "FBFE56",
  "A7BBC3",
  "3C485E",
  "055A5B",
  "178E96",
  "D3E8E1",
  "CBA0AA",
  "9C9CDD",
  "20AD65",
  "E75153",
  "4F3A4B",
  "112378",
  "A82B35",
  "FEDCCC",
  "00B28B",
  "9357A9",
  "C6D7C7",
  "B1FDEB",
  "BEF6E9",
  "776EA7",
  "EAEAEA",
  "EF303B",
  "1812D6",
  "FFFDE7",
  "D1E9E3",
  "7DE0E6",
  "3A745F",
  "CE7182",
  "340B0B",
  "F8EBEE",
  "FF9966",
  "002CFC",
  "75FFC0",
  "FB9B2A",
  "FF8FA4",
  "000000",
  "083EA7",
  "674B7C",
  "19AAD1",
  "12162D",
  "121738",
  "0C485E",
  "FC3C2D",
  "864BFF",
  "EF5B09",
  "97B8A3",
  "FFD101",
  "C26B6A",
  "E3E3E3",
  "FF4C06",
  "CDFF06",
  "0C485E",
  "1F3B34",
  "384D9D",
  "E10000",
  "F64A00",
  "89937A",
  "C39D63",
  "00FDFF",
  "B18AE0",
  "96D0FF",
  "3C225F",
  "FF6B61",
  "EEB200"
];

// https://github.com/andrewfiorillo/sketch-palettes
const List<String> materialColors = [
  "F44336",
  "FFEBEE",
  "FFCDD2",
  "EF9A9A",
  "E57373",
  "EF5350",
  "E53935",
  "D32F2F",
  "C62828",
  "B71C1C",
  "FF8A80",
  "FF5252",
  "FF1744",
  "D50000",
  "E91E63",
  "FCE4EC",
  "F8BBD0",
  "F48FB1",
  "F06292",
  "EC407A",
  "D81B60",
  "C2185B",
  "AD1457",
  "880E4F",
  "FF80AB",
  "FF4081",
  "F50057",
  "C51162",
  "9C27B0",
  "F3E5F5",
  "E1BEE7",
  "CE93D8",
  "BA68C8",
  "AB47BC",
  "8E24AA",
  "7B1FA2",
  "6A1B9A",
  "4A148C",
  "EA80FC",
  "E040FB",
  "D500F9",
  "AA00FF",
  "673AB7",
  "EDE7F6",
  "D1C4E9",
  "B39DDB",
  "9575CD",
  "7E57C2",
  "5E35B1",
  "512DA8",
  "4527A0",
  "311B92",
  "B388FF",
  "7C4DFF",
  "651FFF",
  "6200EA",
  "3F51B5",
  "E8EAF6",
  "C5CAE9",
  "9FA8DA",
  "7986CB",
  "5C6BC0",
  "3949AB",
  "303F9F",
  "283593",
  "1A237E",
  "8C9EFF",
  "536DFE",
  "3D5AFE",
  "304FFE",
  "2196F3",
  "E3F2FD",
  "BBDEFB",
  "90CAF9",
  "64B5F6",
  "42A5F5",
  "1E88E5",
  "1976D2",
  "1565C0",
  "0D47A1",
  "82B1FF",
  "448AFF",
  "2979FF",
  "2962FF",
  "03A9F4",
  "E1F5FE",
  "B3E5FC",
  "81D4FA",
  "4FC3F7",
  "29B6F6",
  "039BE5",
  "0288D1",
  "0277BD",
  "01579B",
  "80D8FF",
  "40C4FF",
  "00B0FF",
  "0091EA",
  "00BCD4",
  "E0F7FA",
  "B2EBF2",
  "80DEEA",
  "4DD0E1",
  "26C6DA",
  "00ACC1",
  "0097A7",
  "00838F",
  "006064",
  "84FFFF",
  "18FFFF",
  "00E5FF",
  "00B8D4",
  "009688",
  "E0F2F1",
  "B2DFDB",
  "80CBC4",
  "4DB6AC",
  "26A69A",
  "00897B",
  "00796B",
  "00695C",
  "004D40",
  "A7FFEB",
  "64FFDA",
  "1DE9B6",
  "00BFA5",
  "4CAF50",
  "E8F5E9",
  "C8E6C9",
  "A5D6A7",
  "81C784",
  "66BB6A",
  "43A047",
  "388E3C",
  "2E7D32",
  "1B5E20",
  "B9F6CA",
  "69F0AE",
  "00E676",
  "00C853",
  "8BC34A",
  "F1F8E9",
  "DCEDC8",
  "C5E1A5",
  "AED581",
  "9CCC65",
  "7CB342",
  "689F38",
  "558B2F",
  "33691E",
  "CCFF90",
  "B2FF59",
  "76FF03",
  "64DD17",
  "CDDC39",
  "F9FBE7",
  "F0F4C3",
  "E6EE9C",
  "DCE775",
  "D4E157",
  "C0CA33",
  "AFB42B",
  "9E9D24",
  "827717",
  "F4FF81",
  "EEFF41",
  "C6FF00",
  "AEEA00",
  "FFEB3B",
  "FFFDE7",
  "FFF9C4",
  "FFF59D",
  "FFF176",
  "FFEE58",
  "FDD835",
  "FBC02D",
  "F9A825",
  "F57F17",
  "FFFF8D",
  "FFFF00",
  "FFEA00",
  "FFD600",
  "FFC107",
  "FFF8E1",
  "FFECB3",
  "FFE082",
  "FFD54F",
  "FFCA28",
  "FFB300",
  "FFA000",
  "FF8F00",
  "FF6F00",
  "FFE57F",
  "FFD740",
  "FFC400",
  "FFAB00",
  "FF9800",
  "FFF3E0",
  "FFE0B2",
  "FFCC80",
  "FFB74D",
  "FFA726",
  "FB8C00",
  "F57C00",
  "EF6C00",
  "E65100",
  "FFD180",
  "FFAB40",
  "FF9100",
  "FF6D00",
  "FF5722",
  "FBE9E7",
  "FFCCBC",
  "FFAB91",
  "FF8A65",
  "FF7043",
  "F4511E",
  "E64A19",
  "D84315",
  "BF360C",
  "FF9E80",
  "FF6E40",
  "FF3D00",
  "DD2C00",
  "9E9E9E",
  "FAFAFA",
  "F5F5F5",
  "EEEEEE",
  "E0E0E0",
  "BDBDBD",
  "757575",
  "616161",
  "424242",
  "212121",
  "607D8B",
  "ECEFF1",
  "CFD8DC",
  "B0BEC5",
  "90A4AE",
  "78909C",
  "546E7A",
  "455A64",
  "37474F",
  "263238",
  "795548",
  "EFEBE9",
  "D7CCC8",
  "BCAAA4",
  "A1887F",
  "8D6E63",
  "6D4C41",
  "5D4037",
  "4E342E",
  "3E2723",
  "000000",
  "FFFFFF",
];
