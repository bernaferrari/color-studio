import 'package:flutter/material.dart';
import 'package:infinite_listview/infinite_listview.dart';

import 'contrast_item.dart';
import 'inter_color_with_contrast.dart';

class ContrastList extends StatelessWidget {
  const ContrastList({
    this.pageKey,
    this.title,
    this.sectionIndex,
    this.listSize,
    this.colorsList,
    this.onColorPressed,
    this.buildWidget,
    this.isInfinite = false,
    this.isFirst = false,
  });

  final Function(Color) onColorPressed;
  final Function(int) buildWidget;

  final List<InterColorWithContrast> colorsList;
  final String title;
  final String pageKey;
  final int sectionIndex;
  final int listSize;
  final bool isInfinite;
  final bool isFirst;

  Widget colorCompare(int index) {
    return ContrastItem(
      kind: pageKey,
      color: colorsList[index],
      contrast: colorsList[index].contrast,
      compactText: isFirst,
      category: title,
      onPressed: () => onColorPressed(colorsList[index].color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: isInfinite
          ? InfiniteListView.builder(
              scrollDirection: Axis.horizontal,
              key: PageStorageKey<String>("$pageKey $sectionIndex"),
              itemBuilder: (BuildContext context, int absoluteIndex) {
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
                scrollDirection: Axis.horizontal,
                key: PageStorageKey<String>("$pageKey $sectionIndex"),
                itemBuilder: (BuildContext context, int index) {
                  return colorCompare(index);
                },
              ),
            ),
    );
  }
}
