import 'package:colorstudio/example/blocs/blocs.dart';
import 'package:colorstudio/example/util/constants.dart';
import 'package:colorstudio/scheme/expanded_item.dart';
import 'package:colorstudio/scheme/header_item.dart';
import 'package:colorstudio/widgets/expanded_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
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
          SchemeHeaderItem(
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
          if (i != widget.contrastedColors.length - 1)
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

class SameAs extends StatelessWidget {
  const SameAs({
    @required this.selected,
    @required this.color,
    @required this.contrast,
  });

  final String selected;
  final Color color;
  final double contrast;

  @override
  Widget build(BuildContext context) {
    Color textColor;

    if (contrast > 100 - kLumContrast * 100) {
      textColor = Colors.black;
    } else {
      textColor = Colors.white;
    }

    return Container(
      color: color,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Divider(height: 0, color: textColor),
          SizedBox(height: 16),
          Text(
            sameAs(),
            style: TextStyle(
              color: textColor,
              fontFamily: 'Lato',
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          SizedBox(height: 8),
          OutlineButton.icon(
            onPressed: () {
              BlocProvider.of<MdcSelectedBloc>(context).add(
                MDCUpdateLock(
                  isLock: false,
                  selected: selected,
                ),
              );
            },
            highlightedBorderColor: textColor.withOpacity(0.70),
            borderSide: BorderSide(color: textColor.withOpacity(0.70)),
            textColor: textColor,
            icon: Icon(
              FeatherIcons.unlock,
              size: 16,
            ),
            label: Text(
              "Manual",
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  String sameAs() {
    if (selected == kSecondary) {
      return "SAME AS ${kPrimary.toUpperCase()}";
    } else if (selected == kSurface) {
      return "SAME AS ${kBackground.toUpperCase()}";
    } else if (selected == kBackground) {
      return "8% PRIMARY + #121212";
    }
    return "Error";
  }
}
