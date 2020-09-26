import 'package:colorstudio/example/util/constants.dart';
import 'package:colorstudio/scheme/compacted_item.dart';
import 'package:colorstudio/scheme/expanded_item.dart';
import 'package:colorstudio/scheme/same_as.dart';
import 'package:colorstudio/scheme/widgets/expanded_section.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hsluv/hsluvcolor.dart';

class SchemeExpandableItem extends StatefulWidget {
  const SchemeExpandableItem(
      this.contrastedColors, this.hsluvColors, this.locked);

  final Map<String, Color> contrastedColors;
  final Map<String, HSLuvColor> hsluvColors;
  final Map<String, bool> locked;

  @override
  _SchemeExpandableItemState createState() => _SchemeExpandableItemState();
}

class _SchemeExpandableItemState extends State<SchemeExpandableItem> {
  int index = -1;

  @override
  void initState() {
    index = PageStorage.of(context).readState(context,
            identifier: const ValueKey("SchemeExpandableItem")) ??
        -1;

    super.initState();
  }

  void onValueChanged(int newValue) {
    setState(() {
      index = newValue;
      PageStorage.of(context).writeState(
        context,
        index,
        identifier: const ValueKey("SchemeExpandableItem"),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final mappedList = widget.contrastedColors.values.toList();
    final keysList = widget.contrastedColors.keys.toList();

    return Column(
      children: <Widget>[
        for (int i = 0; i < widget.contrastedColors.length; i++) ...[
          SchemeCompactedItem(
            rgbColor: mappedList[i],
            title: keysList[i],
            expanded: index == i,
            locked: widget.locked[keysList[i]] ?? false,
            onPressed: () {
              onValueChanged(index == i ? -1 : i);
            },
          ),
          _ExpandedAnimated(
            i: i,
            expanded: index == i,
            color: mappedList[i],
            selected: keysList[i],
            isLocked: widget.locked[keysList[i]],
            lightness: widget.hsluvColors[keysList[i]].lightness,
          ),
          // These dividers get ugly in web mode.
          if (!kIsWeb && i != widget.contrastedColors.length - 1)
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
    this.i,
    this.expanded,
    this.color,
    this.selected,
    this.isLocked,
    this.lightness,
  });

  final int i;
  final bool expanded;
  final Color color;
  final String selected;
  final bool isLocked;
  final double lightness;

  @override
  Widget build(BuildContext context) {
    final scheme = color.computeLuminance() > kLumContrast
        ? ColorScheme.light(primary: color)
        : ColorScheme.dark(primary: color);

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
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          switchInCurve: Curves.easeInOut,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SizeTransition(child: child, sizeFactor: animation);
          },
          child: (isLocked ?? false)
              ? SameAs(selected: selected, color: color, contrast: lightness)
              : SchemeExpandedItem(selected: selected),
        ),
      ),
    );
  }
}
