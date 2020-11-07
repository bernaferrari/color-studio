import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../util/color_util.dart';
import '../util/constants.dart';
import '../util/selected.dart';
import '../widgets/update_color_dialog.dart';

class ColorSearchButton extends StatelessWidget {
  const ColorSearchButton({
    @required this.color,
    this.selected,
  });

  final Color color;
  final ColorType selected;

  @override
  Widget build(BuildContext context) {
    final Color onSurface =
        Theme.of(context).colorScheme.onSurface.withOpacity(0.7);

    return SizedBox(
      height: 36,
      child: OutlineButton.icon(
        icon: Icon(FeatherIcons.search, size: 16),
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultRadius),
        ),
        borderSide: BorderSide(color: onSurface),
        highlightedBorderColor: onSurface,
        label: Text(color.toHexStr()),
        textColor: onSurface,
        onPressed: () {
          showSlidersDialog(context, color, selected);
        },
        onLongPress: () {
          copyToClipboard(context, color.toHexStr());
        },
      ),
    );
  }
}

class OutlinedIconButton extends StatelessWidget {
  const OutlinedIconButton({this.child, this.borderColor, this.onPressed});

  final VoidCallback onPressed;
  final Widget child;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: CircleBorder(
            side: BorderSide(
              color: borderColor ??
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          primary: Theme.of(context).colorScheme.onSurface,
          padding: EdgeInsets.zero,
        ),
        child: child,
        onPressed: onPressed,
      ),
    );
  }
}
