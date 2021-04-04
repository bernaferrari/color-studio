import 'package:colorstudio/screen_home/color_blindness/card_simplified.dart';
import 'package:colorstudio/screen_home/page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../blocs/blocs.dart';
import '../util/widget_space.dart';
import 'color_blindness/card.dart';
import 'contrast_ratio/card.dart';
import 'new_screen.dart';
import 'scheme/card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.toMultiColor,
    required this.toSingleColor,
    required this.toSettings,
  });

  final VoidCallback toMultiColor;
  final VoidCallback toSingleColor;
  final VoidCallback toSettings;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ColorsCubit, ColorsState>(builder: (_, state) {
      if (state.rgbColors.isEmpty) {
        return SizedBox.shrink();
      }

      final bool isiPad = MediaQuery.of(context).size.width > 600;

      return Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: spaceColumn(
                    16,
                    [
                      Row(
                        children: <Widget>[
                          if (isiPad)
                            SizedBox(width: 24)
                          else
                            SizedBox(width: 16),
                          // if (!isiPad) ...[
                          //   Expanded(
                          //     child: RaisedButton.icon(
                          //       label: Text("Modify"),
                          //       icon: Icon(FeatherIcons.sliders, size: 16),
                          //       textColor:
                          //           Theme.of(context).colorScheme.onSurface,
                          //       color: Theme.of(context).colorScheme.surface,
                          //       onPressed: () {
                          //         Navigator.pushNamed(context, "/colordetails");
                          //       },
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(16),
                          //         side: BorderSide(
                          //           color: Theme.of(context)
                          //               .colorScheme
                          //               .onSurface
                          //               .withOpacity(0.3),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          //   const SizedBox(width: 16),
                          // ],
                          // Expanded(
                          //   child: RaisedButton.icon(
                          //     label: Text("Preview"),
                          //     icon: Icon(FeatherIcons.layout, size: 16),
                          //     textColor: colorScheme.onSurface,
                          //     color: colorScheme.surface,
                          //     onPressed: () {
                          //       Navigator.pushNamed(context, "/componentspreview");
                          //     },
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(16),
                          //       side: BorderSide(
                          //         color: colorScheme.onSurface.withOpacity(0.30),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          if (isiPad)
                            const SizedBox(width: 8)
                          else
                            const SizedBox(width: 16),
                        ],
                      ),
                      // PageHeader(
                      //   title: "Color Studio",
                      //   subtitle: "",
                      //   iconData: FeatherIcons.home,
                      //   isFeather: true,
                      // ),
                      // NewScreen(
                      //   rgbColors: state.rgbColors,
                      //   rgbColorsWithBlindness: state.rgbColorsWithBlindness,
                      //   hsluvColors: state.hsluvColors,
                      //   locked: state.locked,
                      // ),
                      ColorSchemeCard(
                        rgbColors: state.rgbColors,
                        rgbColorsWithBlindness: state.rgbColorsWithBlindness,
                        hsluvColors: state.hsluvColors,
                        locked: state.locked,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: spaceRow(
                          16.0,
                          [
                            MiddleButton(
                              "Compare",
                              Icons.compare_arrows_rounded,
                              toMultiColor,
                            ),
                            MiddleButton(
                              "Single",
                              FeatherIcons.sliders,
                              toSingleColor,
                            ),
                            MiddleButton(
                              "Settings",
                              FeatherIcons.settings,
                              toSettings,
                            ),
                          ],
                        ),
                      ),
                      ContrastRatioCard(state.rgbColorsWithBlindness),
                      // ColorBlindnessCardSimplified(
                      //   state.rgbColors,
                      //   state.locked,
                      // ),
                      ColorBlindnessCard(
                        state.rgbColors,
                        state.locked,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class MiddleButton extends StatelessWidget {
  const MiddleButton(this.title, this.iconData, this.toPage);

  final String title;
  final IconData iconData;
  final VoidCallback toPage;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    Theme.of(context).colorScheme.onPrimary.withOpacity(0.90),
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.90),
                  ),
            ),
          ],
        ),
        onPressed: toPage,
      ),
    );
  }
}
