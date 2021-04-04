import 'package:flutter/material.dart';

import '../../shared_widgets/color_search_button.dart';
import 'templates_item.dart';
import 'templates_themes.dart';

class TemplatesScreen extends StatelessWidget {
  const TemplatesScreen({required this.backgroundColor});

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pre-Defined Templates",
            style: Theme.of(context).textTheme.headline6),
        elevation: 0,
        centerTitle: false,
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
                childAspectRatio: MediaQuery.of(context).size.width / 700,
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
