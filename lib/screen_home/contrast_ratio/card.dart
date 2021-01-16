import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';
import '../../blocs/contrast_ratio_cubit.dart';
import '../../example/widgets/loading_indicator.dart';
import '../../util/constants.dart';
import '../../util/widget_space.dart';
import '../title_bar.dart';
import 'contrast_circle_group.dart';

class ContrastRatioCard extends StatelessWidget {
  const ContrastRatioCard(
    this.rgbColorsWithBlindness,
  );

  final Map<ColorType, Color> rgbColorsWithBlindness;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContrastRatioCubit, ContrastRatioState>(
        builder: (context, state) {
      if (state.contrastValues.isEmpty && state.elevationValues.isEmpty) {
        return const LoadingIndicator();
      }

      final shouldDisplayElevation =
          Theme.of(context).colorScheme.brightness == Brightness.dark;

      return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TitleBar(
              title: "Contrast Ratio",
              children: <Widget>[
                SizedBox(height: 36),
                // IconButton(
                //   tooltip: "Contrast compare",
                //   icon: Icon(
                //     FeatherIcons.menu,
                //     color: Theme.of(context).colorScheme.primary,
                //   ),
                //   onPressed: toContrastScreen,
                // ),
                // IconButton(
                //   tooltip: "Help",
                //   icon: Icon(
                //     Icons.help_outline,
                //     color: Theme.of(context).colorScheme.primary,
                //   ),
                //   onPressed: () {
                //     showDialog<dynamic>(
                //         context: context,
                //         builder: (BuildContext ctx) {
                //           return _HelpDialog(
                //             background: background,
                //           );
                //         });
                //   },
                // ),
              ],
            ),
            Container(
              height: 1,
              margin: EdgeInsets.all(1),
              width: double.infinity,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.20),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // if (state.selectedColorType != null)
                Expanded(
                  child: ContrastCircleGroup(state, rgbColorsWithBlindness),
                ),
                SizedBox(
                  width: 164,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: spaceColumn(
                        8,
                        [
                          ...[
                            ColorType.Primary,
                            ColorType.Secondary,
                            ColorType.Background,
                            ColorType.Surface
                          ].map((currentType) {
                            if (currentType == state.selectedColorType) {
                              return OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 24,
                                  ),
                                ),
                                child: Text(
                                  describeEnum(currentType),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                ),
                                onPressed: () {
                                  context
                                      .read<ColorsCubit>()
                                      .updateSelected(currentType);
                                },
                              );
                            } else {
                              return OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 24,
                                  ),
                                ),
                                child: Text(
                                  describeEnum(currentType),
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                onPressed: () {
                                  context
                                      .read<ColorsCubit>()
                                      .updateSelected(currentType);
                                },
                              );
                            }
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
                // else
                //   Expanded(
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         if (shouldDisplayElevation) ...[
                //           Text(
                //             "Primary x Surface with elevation",
                //             textAlign: TextAlign.center,
                //             style: TextStyle(
                //               fontSize: 14,
                //               color: Theme.of(context).colorScheme.onSurface,
                //             ),
                //           ),
                //           SizedBox(height: 16),
                //           DarkModeSurfaceContrast(state.elevationValues),
                //         ] else ...[
                //           Padding(
                //             padding: const EdgeInsets.symmetric(
                //               horizontal: 36.0,
                //               vertical: 8.0,
                //             ),
                //             child: Column(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               children: <Widget>[
                //                 Text(
                //                   "In dark surfaces, Material Design Components express depth by displaying lighter surface colors. "
                //                   "The higher a surface’s elevation (raising it closer to an implied light source), the lighter that surface becomes.\n",
                //                   style:
                //                       Theme.of(context).textTheme.bodyText1,
                //                   textAlign: TextAlign.center,
                //                 ),
                //                 Text(
                //                   "You are using a light surface color.",
                //                   style:
                //                       Theme.of(context).textTheme.bodyText1,
                //                   textAlign: TextAlign.center,
                //                 )
                //               ],
                //             ),
                //           ),
                //         ],
                //       ],
                //     ),
                //   ),            // const SizedBox(height: 16),
                // SizedBox(
                //   // width: 156,
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       // crossAxisAlignment: CrossAxisAlignment.stretch,
                //       children: spaceRow(
                //         8,
                //         [
                //           ...[
                //             ColorType.Primary,
                //             ColorType.Secondary,
                //             ColorType.Background,
                //             ColorType.Surface
                //           ].map((d) {
                //             if (d == state.selectedColorType) {
                //               return OutlinedButton(
                //                 style: OutlinedButton.styleFrom(
                //                   backgroundColor:
                //                       Theme.of(context).colorScheme.primary,
                //                   padding: EdgeInsets.symmetric(
                //                     vertical: 16,
                //                     horizontal: 24,
                //                   ),
                //                 ),
                //                 child: Text(
                //                   describeEnum(d),
                //                   style: Theme.of(context)
                //                       .textTheme
                //                       .subtitle1
                //                       .copyWith(
                //                         color:
                //                             Theme.of(context).colorScheme.onPrimary,
                //                       ),
                //                 ),
                //                 onPressed: () {
                //                   context
                //                       .read<ContrastRatioCubit>()
                //                       .set(selectedColorType: d);
                //                 },
                //               );
                //             } else {
                //               return OutlinedButton(
                //                 style: OutlinedButton.styleFrom(
                //                   padding: EdgeInsets.symmetric(
                //                     vertical: 16,
                //                     horizontal: 24,
                //                   ),
                //                 ),
                //                 child: Text(
                //                   describeEnum(d),
                //                   style: Theme.of(context).textTheme.subtitle1,
                //                 ),
                //                 onPressed: () {
                //                   context
                //                       .read<ContrastRatioCubit>()
                //                       .set(selectedColorType: d);
                //                 },
                //               );
                //             }
                //           }),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    });
  }
}

class _HelpDialog extends StatelessWidget {
  const _HelpDialog({this.background});

  final Color background;

  @override
  Widget build(BuildContext context) {
    /// I am REALLY NOT PROUD of this class!
    /// Really wish Flutter had a better Markdown support.
    /// The existing package was really buggy, so this approach was necessary.
    return AlertDialog(
      title: const Text("Contrast Ratio"),
      contentPadding: const EdgeInsets.only(top: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        color: background,
        child: SizedBox(
          width: 500,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // good resources:
                  // https://www.w3.org/TR/WCAG21/#contrast-minimum
                  // https://usecontrast.com/guide
                  // https://material.io/design/color/dark-theme.html
                  // https://blog.cloudflare.com/thinking-about-color/
                  Text(
                    "WACG recommends a contrast of:",
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "3.0:1 minimum for texts larger than 18pt or icons (AA+).\n4.5:1 minimum for texts smaller than 18pt (AA).\n7.0:1 minimum when possible, if possible (AAA).",
                  ),
                  Text(
                    "\nMost design specifications, including Material, follow this.",
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Text(
                    "There is a formula that calculates the apparent contrast between two colors.",
                    style: Theme.of(context).textTheme.caption,
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Surface with elevation",
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "In a dark theme, at higher levels of elevation, Material Design Components express depth by displaying a lighter surface color. "
                    "The higher a surface’s elevation (raising it closer to an implied light source), the lighter that surface becomes. "
                    "That lightness is expressed through the application of a semi-transparent overlay using the OnSurface color (default: white).",
                  ),
                  SizedBox(height: 24),
                  Text(
                    "HSLuv",
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "This app makes heavy usage of HSLuv."
                    " RGB is unintuitive, HSV and HSL are flawed. When you change the Hue or Saturation in them, the appearent lightness also changes. ",
                  ),
                  SizedBox(height: 8),
                  Text(
                    "HSLuv extends CIELUV, which was based on human experiments, for a perceptual uniform color model." +
                        " This means: when you change the Hue or Saturation in HSLuv, the appearent/perceptual lightness will not vary wildly. This makes a lot easier to design color systems, since you can adjust a color without changing the contrast.",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
