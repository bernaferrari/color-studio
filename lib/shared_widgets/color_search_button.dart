import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../example/widgets/update_color_dialog.dart';
import '../util/color_util.dart';
import '../util/constants.dart';
import '../util/selected.dart';

class ColorSearchButton extends StatelessWidget {
  const ColorSearchButton({
    required this.color,
    this.selected,
    Key? key,
  }) : super(key: key);

  final Color color;
  final ColorType? selected;

  @override
  Widget build(BuildContext context) {
    final Color onSurface =
        Theme.of(context).colorScheme.onSurface.withOpacity(0.7);

    return SizedBox(
      height: 36,
      child: OutlinedButton.icon(
        icon: const Icon(FeatherIcons.search, size: 16),
        style: OutlinedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: BorderSide(color: onSurface),
          foregroundColor: onSurface,
          // highlightedBorderColor: onSurface,
        ),

        label: Text(color.toHexStr()),
        // textColor: onSurface,
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
