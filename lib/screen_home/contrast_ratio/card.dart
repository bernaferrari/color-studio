import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';
import '../../example/widgets/loading_indicator.dart';
import '../../util/constants.dart';
import '../../util/widget_space.dart';
import '../title_bar.dart';
import 'contrast_circle_group.dart';

class ContrastRatioCard extends StatelessWidget {
  const ContrastRatioCard(
    this.rgbColorsWithBlindness, {
    Key? key,
  }) : super(key: key);

  final Map<ColorType, Color> rgbColorsWithBlindness;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContrastRatioCubit, ContrastRatioState>(
        builder: (context, state) {
      if (state.contrastValues.isEmpty && state.elevationValues.isEmpty) {
        return const LoadingIndicator();
      }

      final screenWidth = MediaQuery.of(context).size.width;

      return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const TitleBar(
              title: "Contrast Ratio",
              children: <Widget>[
                SizedBox(height: 48),
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
              margin: const EdgeInsets.all(1),
              width: double.infinity,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.20),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // if (state.selectedColorType != null)
                Flexible(
                  child: ContrastCircleGroup(
                    state: state,
                    rgbColorsWithBlindness: rgbColorsWithBlindness,
                    isInCard: true,
                  ),
                ),
                SizedBox(
                  width: screenWidth < 800 ? 160 : 180,
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
                            return OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor:
                                    currentType == state.selectedColorType
                                        ? Theme.of(context).colorScheme.primary
                                        : null,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 8,
                                ),
                              ),
                              child: Text(
                                describeEnum(currentType),
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color:
                                          currentType == state.selectedColorType
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                    ),
                              ),
                              onPressed: () {
                                context
                                    .read<ColorsCubit>()
                                    .updateSelected(currentType);
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    });
  }
}
