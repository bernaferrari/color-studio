import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hsluv/hsluvcolor.dart';

import '../../blocs/blocs.dart';
import '../../contrast_util.dart';
import '../../util/constants.dart';
import '../../util/when.dart';

class FlatColorPicker extends StatelessWidget {
  const FlatColorPicker({this.kind, this.selected, this.colors});

  final String? kind;
  final ColorType? selected;
  final List<HSLuvColor>? colors;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          for (int i = 0; i < colors!.length; i++)
            Expanded(
              child: SizedBox(
                height: 48,
                child: _SelectorItem(
                  color: colors![i].toColor(),
                  hsLuvColor: colors![i],
                  category: kind,
                  onPressed: () {
                    context.read<ColorsCubit>().updateColor(
                        hsLuvColor: colors![i], selected: selected);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SelectorItem extends StatelessWidget {
  const _SelectorItem({
    this.color,
    this.onPressed,
    this.category = "",
    this.hsLuvColor,
  });

  final Color? color;
  final String? category;
  final HSLuvColor? hsLuvColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final Color textColor = (hsLuvColor!.lightness < kLightnessThreshold)
        ? Colors.white.withOpacity(0.87)
        : Colors.black87;

    final String writtenValue = when<String>({
      () => category == hueStr: () => hsLuvColor!.hue.round().toString(),
      () => category == satStr: () => hsLuvColor!.saturation.toStringAsFixed(0),
      () => category == lightStr || category == valueStr: () =>
          hsLuvColor!.lightness.toStringAsFixed(0),
    });

    final cornerText = Text(
      writtenValue,
      style: Theme.of(context)
          .textTheme
          .caption!
          .copyWith(color: textColor, fontWeight: FontWeight.w700),
    );

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: EdgeInsets.zero,
        primary: color,
        shape: const RoundedRectangleBorder(),
      ),
      onPressed: onPressed,
      child: cornerText,
    );
  }
}
