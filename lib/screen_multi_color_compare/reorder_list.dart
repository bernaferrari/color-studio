import 'package:colorstudio/blocs/multiple_contrast_compare/multiple_contrast_compare_cubit.dart';
import 'package:colorstudio/example/mdc/components.dart';
import 'package:colorstudio/example/util/color_util.dart';
import 'package:flutter/material.dart';

class ReorderList extends StatefulWidget {
  const ReorderList(this.list);

  final List<ColorCompareContrast> list;

  @override
  _ReorderListState createState() => _ReorderListState();
}

class _ReorderListState extends State<ReorderList> {
  List<ColorCompareContrast> elements;

  @override
  void initState() {
    super.initState();
    // copy the list.
    elements = List.from(widget.list);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              child: ReorderableListView(
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final ColorCompareContrast item = elements.removeAt(oldIndex);
                    elements.insert(newIndex, item);
                  });
                },
                children: <Widget>[
                  for (int i = 0; i < elements.length; i++)
                    Container(
                      key: ValueKey(i),
                      color: elements[i].rgbColor,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                elements[i].rgbColor.toHexStr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .copyWith(
                                      color: contrastingRGBColor(
                                        elements[i].rgbColor,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.reorder,
                            color: contrastingRGBColor(elements[i].rgbColor),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              width: 500,
              height: 36,
              child: RaisedButton(
                color: Theme.of(context).colorScheme.surface,
                onPressed: () {
                  Navigator.of(context).pop(
                    elements.map((f) => f.rgbColor).toList(),
                  );
                },
                shape: const RoundedRectangleBorder(),
                child: const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
