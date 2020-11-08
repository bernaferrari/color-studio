import 'package:colorstudio/example/color_with_inter.dart';
import 'package:colorstudio/example/hsinter.dart';
import 'package:colorstudio/example/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:infinite_listview/infinite_listview.dart';

import 'picker_item.dart';

class ExpandableColorBar extends StatelessWidget {
  const ExpandableColorBar({
    this.kind,
    this.title,
    this.expanded,
    this.sectionIndex,
    this.listSize,
    this.colorsList,
    this.onTitlePressed,
    this.onColorPressed,
    this.isInfinite = false,
  });

  final Function onTitlePressed;
  final Function(Color) onColorPressed;
  final List<ColorWithInter> colorsList;
  final String title;
  final HSInterType kind;
  final int expanded;
  final int sectionIndex;
  final int listSize;
  final bool isInfinite;

  Widget colorCompare(int index) {
    return ColorCompareWidgetDetails(
      kind: kind,
      color: colorsList[index],
      compactText: expanded == sectionIndex,
      category: title,
      onPressed: () => onColorPressed(colorsList[index].color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      SizedBox(
        width: double.infinity,
        child: _ExpandableTitle(
          title: title,
          index: sectionIndex,
          expanded: expanded,
          onTitlePressed: onTitlePressed,
        ),
      ),
      Expanded(
        child: Card(
          child: isInfinite
              ? InfiniteListView.builder(
                  key: PageStorageKey<String>("$kind $sectionIndex"),
                  itemBuilder: (_, absoluteIndex) {
                    return colorCompare(absoluteIndex % listSize);
                  },
                )
              : MediaQuery.removePadding(
                  // this is necessary on iOS, else there will be a bottom padding.
                  removeBottom: true,
                  context: context,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: listSize,
                    key: PageStorageKey<String>("$kind $sectionIndex"),
                    itemBuilder: (_, index) {
                      return colorCompare(index);
                    },
                  ),
                ),
        ),
      ),
    ]);
  }
}

/// Title that expands horizontally.
/// For example, "H" => "Hue", "S" => "Saturation" and so on...
class _ExpandableTitle extends StatelessWidget {
  const _ExpandableTitle({
    this.title,
    this.expanded,
    this.index,
    this.onTitlePressed,
  });

  final VoidCallback onTitlePressed;
  final String title;
  final int expanded;
  final int index;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        primary: Theme.of(context).colorScheme.onBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultRadius),
        ),
      ),
      onPressed: onTitlePressed,
      child: Text(
        expanded == index ? title : title[0],
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
    );
  }
}
