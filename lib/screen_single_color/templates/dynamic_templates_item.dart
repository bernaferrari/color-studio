import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';
import '../../util/widget_space.dart';

class DynamicTemplatePreview extends StatelessWidget {
  const DynamicTemplatePreview({
    required this.backgroundColor,
    required this.surfaceColor,
    this.title = '',
    this.isDynamic,
    Key? key,
  }) : super(key: key);

  final Color backgroundColor;
  final Color surfaceColor;
  final String title;
  final bool? isDynamic;

  @override
  Widget build(BuildContext context) {
    // final onPrimary = contrastingColors[0];
    // final onBackground = contrastingColors[1];

    final colorWithBlindList = [
      Theme.of(context).colorScheme.primary,
      surfaceColor,
      backgroundColor,
    ];

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide(
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.40),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      onPressed: () {},
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SizedBox(
                //   width: 12 + 12.0 * colorWithBlindList.length,
                //   child: Stack(
                //     children: <Widget>[
                //       SizedBox(height: 24),
                //       for (int i = colorWithBlindList.length - 1; i >= 0; i--)
                //         Positioned.fill(
                //           left: 12.0 * i,
                //           right: null,
                //           top: 0,
                //           bottom: 0,
                //           child: Transform.rotate(
                //             angle: math.pi / 4,
                //             child: Container(
                //               width: 24,
                //               decoration: BoxDecoration(
                //                 color: colorWithBlindList[i],
                //                 borderRadius: BorderRadius.circular(6),
                //                 border: Border.all(
                //                   width: 1,
                //                   color: Theme.of(context)
                //                       .colorScheme
                //                       .onSurface
                //                       .withOpacity(0.20),
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ),
                //     ],
                //   ),
                // ),

                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Container(
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            ),
                            if (isDynamic!)
                              Expanded(
                                flex: 2,
                                child: Container(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Center(
                      //   child: Text(title,
                      //   style: TextStyle(
                      //     color: Theme.of(context).colorScheme.primary,
                      //     fontSize: 26,
                      //     fontWeight: FontWeight.bold,
                      //   ),),
                      // )
                      if (isDynamic!)
                        Positioned(
                          top: 0,
                          bottom: 0,
                          left: 22,
                          child: Center(
                            child: Transform.rotate(
                              angle: math.pi / 4,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (!isDynamic!)
                        Center(
                          child: Transform.rotate(
                            angle: math.pi / 4,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Expanded(
                //   flex: 1,
                //   child: Column(
                //     children: [
                //       Expanded(
                //         child: Container(
                //           color: Theme.of(context).colorScheme.primary,
                //         ),
                //       ),
                //       Expanded(
                //         child: Container(
                //           color: Theme.of(context).colorScheme.secondary,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // Expanded(
                //   flex: 1,
                //   child: Column(
                //     children: [
                //       Expanded(
                //         child: Container(
                //           color: backgroundColor,
                //         ),
                //       ),
                //       Expanded(
                //         child: Container(
                //           color: surfaceColor,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
          //       Positioned(
          //         left: 8,
          //         right: 8,
          //         bottom: 8,
          //         child: Container(
          // height: 20,
          //         decoration: BoxDecoration(
          //             color: Theme.of(context).colorScheme.primary,
          //             borderRadius: BorderRadius.circular(8)
          //         ),
          //           child: Text("Select"),
          //         ),
          // ),
          // child: ElevatedButton(
          //   style: ElevatedButton.styleFrom(
          //     primary: Theme.of(context).colorScheme.primary,
          //     padding: const EdgeInsets.all(8.0),
          //     elevation: 0,
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(8),
          //       side: BorderSide(color: Colors.white.withOpacity(0.15)),
          //     ),
          //   ),
          //   onPressed: () {},
          //   child: Text("Select Theme"),
          // ),
          // ),
        ],
      ),
    );

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.background,
        padding: const EdgeInsets.all(8.0),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.white.withOpacity(0.15)),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: spaceRow(
          8.0,
          [
            SizedBox(
              width: 36,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: spaceColumn(
                  4,
                  [
                    Transform.rotate(
                      angle: -1 * math.pi / 180,
                      child: _CalendarView(),
                    ),
                    // _MissionControlView(),
                  ],
                ),
              ),
            ),
            Transform.rotate(
              angle: 0.5 * math.pi / 180,
              child: SizedBox(
                width: 64,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: spaceColumn(
                    4,
                    [
                      const Text(
                        "Sat, Dec 5",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        children: spaceRow(
                          4,
                          [
                            Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              child: Icon(
                                Icons.wifi_rounded,
                                color: Theme.of(context).colorScheme.background,
                                size: 12,
                              ),
                            ),
                            Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Theme.of(context).colorScheme.surface,
                              ),
                              child: Icon(
                                Icons.alt_route,
                                color: Theme.of(context).colorScheme.primary,
                                size: 12,
                              ),
                            ),
                            Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Theme.of(context).colorScheme.surface,
                              ),
                              child: Icon(
                                Icons.highlight_outlined,
                                color: Theme.of(context).colorScheme.background,
                                size: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // _FakeSlider(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HexButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color onColor;

  const HexButton(this.text, this.color, this.onColor, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          shape: const CircleBorder(
              // borderRadius: BorderRadius.circular(8.0),
              ),
        ),
        onPressed: () {
          context.read<ColorsCubit>().updateRgbColor(rgbColor: color);
        },
        child: null,
      ),
    );
  }
}

class RowColorItem extends StatelessWidget {
  const RowColorItem({
    required this.color,
    this.isPrimary = false,
    Key? key,
  }) : super(key: key);

  final Color color;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: color.withOpacity(0.20),
          // borderRadius: BorderRadius.circular(4),
          border: Border(
            //   color: color,
            left: BorderSide(color: color, width: 2),
            // right: BorderSide(color: color, width: 2),
          ),
        ),
        // child: Center(
        //   child: Icon(
        //     Icons.horizontal_rule,
        //     size: 16,
        //     color: color,
        //   ),
        // ),
        child: Center(
          child: Icon(
            isPrimary ? Icons.waves : Icons.ac_unit_rounded,
            size: 16,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _CalendarView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Text(
              "DEC",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontFamily: "SF Pro Text",
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
                color: Theme.of(context).colorScheme.surface,
              ),
              child: const Center(
                child: Text(
                  "5",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MissionControlView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 8,
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: const Color(0xff383838),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: const Color(0xffeb5757),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
                color: Colors.white.withOpacity(0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FakeSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 6,
      child: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: [
            Positioned(
              right: 0,
              top: 2,
              child: Container(
                width: constraints.maxWidth / 2,
                height: 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 2,
              child: Container(
                width: constraints.maxWidth / 2,
                height: 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
