import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../blocs/blocs.dart';
import '../../util/color_util.dart';
import '../../util/constants.dart';
import '../../util/widget_space.dart';

class ExportColorsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ColorsCubit, ColorsState>(builder: (_, state) {
      final primary = state.rgbColorsWithBlindness[ColorType.Primary]!;
      final background = state.rgbColorsWithBlindness[ColorType.Background]!;
      final surface = state.rgbColorsWithBlindness[ColorType.Surface]!;

      final onPrimary =
          state.hsluvColors[ColorType.Primary]!.lightness >= kLightnessThreshold
              ? Colors.black
              : Colors.white;

      final onSurface =
          state.hsluvColors[ColorType.Surface]!.lightness >= kLightnessThreshold
              ? Colors.black
              : Colors.white;

      final onBackground = state.hsluvColors[ColorType.Background]!.lightness >=
              kLightnessThreshold
          ? Colors.black
          : Colors.white;

      return Scaffold(
        appBar: AppBar(
          title: Text("Export Colors"),
        ),
        backgroundColor: background,
        body: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 818),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: spaceColumn(
                  24,
                  [
                    SizedBox(),
                    _CardTitle(primary, background, surface, onPrimary,
                        onBackground, onSurface, "Flutter"),
                    _CardTitle(primary, background, surface, onPrimary,
                        onBackground, onSurface, "Android (colors.xml)"),
                    _CardTitle(primary, background, surface, onPrimary,
                        onBackground, onSurface, "Android (styles.xml)"),
                    _CardTitle(primary, background, surface, onPrimary,
                        onBackground, onSurface, "iOS (Swift)"),
                    _CardTitle(primary, background, surface, onPrimary,
                        onBackground, onSurface, "iOS (Objective C)"),
                    _CardTitle(primary, background, surface, onPrimary,
                        onBackground, onSurface, "Hex List"),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle(this.primary, this.background, this.surface, this.onPrimary,
      this.onSurface, this.onBackground, this.kind);

  final Color primary;
  final Color background;
  final Color surface;
  final Color onPrimary;
  final Color onSurface;
  final Color onBackground;
  final String kind;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          kind,
          style: GoogleFonts.firaSans(
            textStyle: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: onBackground),
          ),
        ),
        _ExportRow(primary, background, surface, onPrimary, onBackground,
            onSurface, kind),
      ],
    );
  }
}

class _ExportRow extends StatelessWidget {
  const _ExportRow(
    this.primary,
    this.background,
    this.surface,
    this.onPrimary,
    this.onBackground,
    this.onSurface,
    this.kind,
  );

  final Color primary;
  final Color background;
  final Color surface;
  final Color onPrimary;
  final Color onSurface;
  final Color onBackground;
  final String kind;

  String generateUIColor(Color color) {
    return """UIColor(red: ${color.red} / 255.0, green: ${color.green} / 255.0, blue: ${color.blue} / 255.0, alpha: 1.0)""";
  }

  String retrieveString() {
    if (kind == "Android (styles.xml)") {
      return '''
<item name="colorPrimary">${primary.toHexStr()}</item>
<item name="colorSecondary">${primary.toHexStr()}</item>
<item name="colorBackground">${background.toHexStr()}</item>
<item name="colorSurface">${surface.toHexStr()}</item>

<item name="colorOnPrimary">${onPrimary.toHexStr()}</item>
<item name="colorOnBackground">${onBackground.toHexStr()}</item>
<item name="colorOnSurface">${onSurface.toHexStr()}</item>''';
    } else if (kind == "Android (colors.xml)") {
      return '''
<color name="colorPrimary">${primary.toHexStr()}</color>
<color name="colorSecondary">${primary.toHexStr()}</color>
<color name="colorBackground">${background.toHexStr()}</color>
<color name="colorSurface">${surface.toHexStr()}</color>

<color name="colorOnPrimary">${onPrimary.toHexStr()}</color>
<color name="colorOnBackground">${onBackground.toHexStr()}</color>
<color name="colorOnSurface">${onSurface.toHexStr()}</color>''';
    } else if (kind == "Flutter") {
      final String light = onBackground == Colors.white ? "dark" : "light";

      return '''
ColorScheme.$light(
    primary: $primary,
    secondary: $primary,
    background: $background,
    surface: $surface,
    
    onPrimary: $onPrimary,
    onBackground: $onBackground,
    onSurface: $onSurface,
)''';
    } else if (kind == "iOS (Swift)") {
      return '''
let colorScheme = MDCSemanticColorScheme()

colorScheme.primaryColor = ${generateUIColor(primary)}

colorScheme.secondaryColor = ${generateUIColor(primary)}

colorScheme.backgroundColor = ${generateUIColor(background)}

colorScheme.surfaceColor = ${generateUIColor(surface)}


colorScheme.onPrimaryColor = ${generateUIColor(onPrimary)}

colorScheme.onBackgroundColor = ${generateUIColor(onBackground)}

colorScheme.onSurfaceColor = ${generateUIColor(onSurface)}
''';
    } else if (kind == "iOS (Objective C)") {
      return '''
// A helper method for creating colors from hex values.
static UIColor *ColorFromRGB(uint32_t colorValue) {
  return [[UIColor alloc] initWithRed:(CGFloat)(((colorValue >> 16) & 0xFF) / 255.0)
                                green:(CGFloat)(((colorValue >> 8) & 0xFF) / 255.0)
                                 blue:(CGFloat)((colorValue & 0xFF) / 255.0) alpha:1];
}

MDCSemanticColorScheme *colorScheme = [[MDCSemanticColorScheme alloc] initWithDefaults:MDCColorSchemeDefaultsMaterial201804];

colorScheme.primaryColor = ColorFromRGB(0x${primary.toStr()});
colorScheme.secondaryColor = colorScheme.primaryColor;
colorScheme.backgroundColor = ColorFromRGB(0x${background.toStr()});
colorScheme.surfaceColor = ColorFromRGB(0x${surface.toStr()});

colorScheme.onPrimaryColor = ColorFromRGB(0x${onPrimary.toStr()});
colorScheme.onBackgroundColor = ColorFromRGB(0x${onBackground.toStr()});
colorScheme.onSurfaceColor = ColorFromRGB(0x${onSurface.toStr()});
''';
    } else if (kind == "Hex List") {
      return "${primary.toHexStr()}, ${surface.toHexStr()}, ${background.toHexStr()}, ${onPrimary.toHexStr()}, ${onSurface.toHexStr()}, ${onBackground.toHexStr()}";
    }

    return "";
  }

  @override
  Widget build(BuildContext context) {
    final retrievedText = retrieveString();

    return Card(
      color: surface,
      margin: const EdgeInsets.all(16.0),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: SelectableText(
                retrievedText,
                style: GoogleFonts.firaSans(
                  fontSize: 14,
                  textStyle: TextStyle(color: onSurface),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    label: Text("Copy"),
                    icon: Icon(FeatherIcons.copy, size: 16),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: retrievedText));

                      ScaffoldMessenger.maybeOf(context)!.hideCurrentSnackBar();
                      final snackBar = SnackBar(
                        content: Text('$kind copied!'),
                        duration: const Duration(milliseconds: 1000),
                      );
                      ScaffoldMessenger.maybeOf(context)!
                          .showSnackBar(snackBar);
                    },
                  ),
                ),
//                SizedBox(width: 16),
//                Expanded(
//                  child: RaisedButton.icon(
//                    label: Text("Share"),
//                    icon: Icon(FeatherIcons.share2, size: 16),
//                    color: primary,
//                    textColor: onPrimary,
//                    onPressed: () {},
//                  ),
//                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
