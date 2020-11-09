import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hsluv/hsluvcolor.dart';

import '../../example/util/constants.dart';
import 'compacted_item.dart';
import 'expanded_item.dart';
import 'same_as.dart';
import 'widgets/expanded_section.dart';

class SchemeExpandableItem extends StatefulWidget {
  const SchemeExpandableItem(
    this.rgbColors,
    this.colorWithBlindness,
    this.hsluvColors,
    this.locked,
  );

  final Map<ColorType, Color> rgbColors;
  final Map<ColorType, Color> colorWithBlindness;
  final Map<ColorType, HSLuvColor> hsluvColors;
  final Map<ColorType, bool> locked;

  @override
  _SchemeExpandableItemState createState() => _SchemeExpandableItemState();
}

class _SchemeExpandableItemState extends State<SchemeExpandableItem> {
  int index = -1;

  @override
  void initState() {
    index = PageStorage.of(context).readState(context,
            identifier: const ValueKey<String>("SchemeExpandableItem")) ??
        -1;

    super.initState();
  }

  void onValueChanged(int newValue) {
    setState(() {
      index = newValue;
      PageStorage.of(context).writeState(
        context,
        index,
        identifier: const ValueKey<String>("SchemeExpandableItem"),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final rgbColorsList = widget.rgbColors.values.toList();
    final keysList = widget.rgbColors.keys.toList();

    return Column(
      children: <Widget>[
        for (int i = 0; i < widget.rgbColors.length; i++) ...[
          SchemeCompactedItem(
            rgbColor: rgbColorsList[i],
            currentType: keysList[i],
            expanded: index == i,
            locked: widget.locked[keysList[i]] ?? false,
            onPressed: () {
              onValueChanged(index == i ? -1 : i);
            },
          ),
          _ExpandedAnimated(
            expanded: index == i,
            rgbColor: rgbColorsList[i],
            hsluvColor: widget.hsluvColors[keysList[i]],
            rgbColorWithBlindness: widget.colorWithBlindness[keysList[i]],
            isLocked: widget.locked[keysList[i]],
            selected: keysList[i],
          ),
          // These dividers get ugly in web mode.
          if (!kIsWeb && i != widget.rgbColors.length - 1)
            Divider(
              height: 0,
              indent: (index == i) ? 0 : 56,
              endIndent: 1,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.30),
            ),
        ],
      ],
    );
  }
}

class _ExpandedAnimated extends StatelessWidget {
  const _ExpandedAnimated({
    this.expanded,
    this.rgbColor,
    this.hsluvColor,
    this.rgbColorWithBlindness,
    this.selected,
    this.isLocked,
  });

  final bool expanded;
  final Color rgbColor;
  final HSLuvColor hsluvColor;
  final Color rgbColorWithBlindness;
  final ColorType selected;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    final scheme = hsluvColor.lightness < kLightnessThreshold
        ? ColorScheme.dark(primary: rgbColor)
        : ColorScheme.light(primary: rgbColor);

    return ExpandedSection(
      expand: expanded,
      child: Theme(
        data: ThemeData.from(
          colorScheme: scheme,
          textTheme: TextTheme(
            button: GoogleFonts.lato(),
            bodyText2: GoogleFonts.lato(
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
        ).copyWith(
          buttonTheme: ButtonThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: scheme.onSurface.withOpacity(0.70),
              ),
            ),
          ),
        ),
        child: Container(
          color: rgbColorWithBlindness,
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            switchInCurve: Curves.easeInOut,
            transitionBuilder: (child, animation) {
              return SizeTransition(child: child, sizeFactor: animation);
            },
            child: (isLocked ?? false)
                ? SameAs(
                    selected: selected,
                    color: rgbColor,
                    lightness: hsluvColor.lightness,
                  )
                : SchemeExpandedItem(
                    rgbColor: rgbColor,
                    hsLuvColor: hsluvColor,
                    rgbColorWithBlindness: rgbColorWithBlindness,
                    selected: selected),
          ),
        ),
      ),
    );
  }
}
