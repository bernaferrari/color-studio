import 'package:flutter/material.dart';

import '../../example/vertical_picker/app_bar_actions.dart';
import 'templates_item.dart';
import 'templates_themes.dart';

class TemplatesScreen extends StatelessWidget {
  const TemplatesScreen({this.backgroundColor, this.isSplitView});

  final Color backgroundColor;
  final bool isSplitView;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Templates", style: Theme.of(context).textTheme.headline6),
        elevation: 0,
        centerTitle: isSplitView,
        leading: isSplitView ? SizedBox.shrink() : null,
        actions: <Widget>[
          Center(child: ColorSearchButton(color: backgroundColor)),
          const SizedBox(width: 8),
        ],
      ),
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        key: PageStorageKey("TemplatesScrollView"),
        primary: false,
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: MediaQuery.of(context).size.width / 600,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              delegate: SliverChildBuilderDelegate(
                (_, index) {
                  return TemplatePreview(
                    templateThemes[index].title,
                    templateThemes[index].colors,
                    templateThemes[index].contrastingColors,
                  );
                },
                childCount: templateThemes.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
