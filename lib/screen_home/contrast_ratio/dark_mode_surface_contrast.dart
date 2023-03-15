import 'package:flutter/material.dart';

import '../../blocs/blocs.dart';
import '../../blocs/contrast_ratio_cubit.dart';
import '../../contrast_util.dart';
import '../../example/mdc/contrast_compare.dart';
import '../../example/mdc/util/elevation_overlay.dart';

class DarkModeSurfaceContrast extends StatelessWidget {
  const DarkModeSurfaceContrast(this.elevationValues, {super.key});

  final List<ColorContrast> elevationValues;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Center(
        child: ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: <Widget>[
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("0pt", style: Theme.of(context).textTheme.labelSmall),
                ContrastText(elevationValues[0].contrast, withSizedBox: true),
                Text(
                  getContrastLetters(elevationValues[0].contrast),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
            const SizedBox(width: 8),
            Row(
              children: <Widget>[
                for (int i = 0; i < elevationEntriesList.length; i++)
                  _VerticalBarWithText(elevationValues[i], i),
              ],
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("24pt", style: Theme.of(context).textTheme.labelSmall),
                ContrastText(
                  elevationValues[elevationEntriesList.length - 1].contrast,
                  withSizedBox: true,
                ),
                Text(
                  getContrastLetters(
                    elevationValues[elevationEntriesList.length - 1].contrast,
                  ),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

class _VerticalBarWithText extends StatelessWidget {
  const _VerticalBarWithText(this.colorContrast, this.i);

  final ColorContrast colorContrast;
  final int i;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message:
          "[${elevationEntries[i].elevation}] ${colorContrast.contrast.toStringAsPrecision(3)}:1",
      child: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                width: 12,
                child: ContrastProgressBar(
                  contrast: colorContrast.contrast,
                  direction: Axis.vertical,
                ),
              ),
            ),
          ),
          Container(
            width: 20,
            color: colorContrast.color,
            child: Text(
              elevationEntries[i].elevation.toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
