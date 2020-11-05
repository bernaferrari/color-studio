import 'package:colorstudio/blocs/multiple_contrast_compare/rgb_hsluv_tuple.dart';
import 'package:colorstudio/example/hsinter.dart';
import 'package:flutter/material.dart';
import 'package:hsluv/hsluvcolor.dart';
import 'package:infinite_listview/infinite_listview.dart';

import 'contrast_item.dart';

class ContrastList extends StatelessWidget {
  const ContrastList({
    this.kind,
    this.title,
    this.sectionIndex,
    this.listSize,
    this.colorsList,
    this.onColorPressed,
    this.buildWidget,
    this.isInfinite = false,
    this.isFirst = false,
  });

  final Function(HSLuvColor) onColorPressed;
  final Function(int) buildWidget;

  final List<RgbHSLuvTuple> colorsList;
  final String title;
  final HSInterType kind;
  final int sectionIndex;
  final int listSize;
  final bool isInfinite;
  final bool isFirst;

  Widget colorCompare(int index) {
    return ContrastItem2(
      rgbHsluvTuple: colorsList[index],
      category: title,
      onPressed: () => onColorPressed(colorsList[index].hsluvColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: isInfinite
          ? InfiniteListView.builder(
              scrollDirection: Axis.horizontal,
              key: PageStorageKey<String>("$kind $sectionIndex"),
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
                key: PageStorageKey<String>("$kind $sectionIndex"),
                itemBuilder: (BuildContext context, int index) {
                  return colorCompare(index);
                },
              ),
            ),
    );
  }
}
