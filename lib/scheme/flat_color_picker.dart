import 'package:colorstudio/example/blocs/blocs.dart';
import 'package:colorstudio/example/contrast/contrast_util.dart';
import 'package:colorstudio/example/util/constants.dart';
import 'package:colorstudio/example/util/when.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hsluv/hsluvcolor.dart';

class FlatColorPicker extends StatelessWidget {
  const FlatColorPicker({this.kind, this.selected, this.colors});

  final String kind;
  final String selected;
  final List<HSLuvColor> colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 24, right: 24),
      child: Material(
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
            for (int i = 0; i < colors.length; i++)
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: _SelectorItem(
                    color: colors[i].toColor(),
                    hsLuvColor: colors[i],
                    category: kind,
                    onPressed: () {
                      BlocProvider.of<MdcSelectedBloc>(context).add(
                        MDCUpdateColor(
                          hsLuvColor: colors[i],
                          selected: selected,
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
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

  final Color color;
  final String category;
  final HSLuvColor hsLuvColor;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    final Color textColor = (hsLuvColor.lightness < kLightnessThreshold)
        ? Colors.white.withOpacity(0.87)
        : Colors.black87;

    final String writtenValue = when<String>({
      () => category == hueStr: () => hsLuvColor.hue.round().toString(),
      () => category == satStr: () =>
          "${hsLuvColor.saturation.toStringAsFixed(0)}",
      () => category == lightStr || category == valueStr: () =>
          "${hsLuvColor.lightness.toStringAsFixed(0)}",
    });

    final cornerText = Text(
      writtenValue,
      style: Theme.of(context)
          .textTheme
          .caption
          .copyWith(color: textColor, fontWeight: FontWeight.w700),
    );

    return SizedBox(
      width: 56,
      child: MaterialButton(
        elevation: 0,
        padding: EdgeInsets.zero,
        color: color,
        shape: const RoundedRectangleBorder(),
        onPressed: onPressed,
        child: cornerText,
      ),
    );
  }
}
