import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../shared_widgets/color_search_button.dart';
import '../../util/color_util.dart';
import '../../util/constants.dart';
import '../../util/selected.dart';
import '../../util/shuffle_color.dart';
import '../mdc/components.dart';
import '../widgets/update_color_dialog.dart';

class ColorLibrary extends StatelessWidget {
  const ColorLibrary({
    required this.backgroundColor,
    Key? key,
  }) : super(key: key);

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final colorsList = getColorClaim();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title:
            Text("Color Library", style: Theme.of(context).textTheme.headline6),
        elevation: 0,
        centerTitle: false,
        actions: <Widget>[
          Center(child: ColorSearchButton(color: backgroundColor)),
          const SizedBox(width: 8),
          // IconButton(
          //   icon: Icon(FeatherIcons.externalLink),
          //   onPressed: () async =>
          //       await launch("https://www.vanschneider.com/colors"),
          // )
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 818),
          child: LayoutBuilder(builder: (_, builder) {
            return CustomScrollView(
              key: const PageStorageKey("ColorLibrary"),
              primary: false,
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid.count(
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.8,
                    crossAxisCount:
                        (math.min(builder.maxWidth, 818) / 120).ceil(),
                    children: <Widget>[
                      for (int i = 0; i < colorsList.length; i++)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(kVeryTransparent),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                            primary: colorsList[i],
                            padding: const EdgeInsets.all(8),
                          ),
                          onPressed: () {
                            colorSelected(context, colorsList[i]);
                          },
                          onLongPress: () {
                            showSlidersDialog(context, colorsList[i]);
                          },
                          child: Center(
                            child: Text(
                              colorsList[i].toHexStr(),
//                                when<String>({
//                                  () => currentSegment == 0: () =>
//                                      colorsList[i].toHexStr(),
//                                  () => currentSegment == 1: () =>
//                                      "R:${colorsList[i].red}\nG:${colorsList[i].green}\nB${colorsList[i].blue}",
//                                  () => currentSegment == 2: () =>
//                                      "H:${colorsList[i].red}\nS:${colorsList[i].green}\nV${colorsList[i].blue}",
//                                }),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: contrastingRGBColor(colorsList[i])
                                        .withOpacity(0.70),
                                  ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
