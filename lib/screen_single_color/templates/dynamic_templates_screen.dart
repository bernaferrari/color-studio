import 'package:flutter/material.dart';

import '../../blocs/blocs.dart';
import '../../shared_widgets/color_search_button.dart';
import '../../util/constants.dart';
import '../../util/shuffle_color.dart';
import 'templates_themes.dart';

class DynamicTemplatesScreen extends StatelessWidget {
  const DynamicTemplatesScreen({
    super.key,
    required this.backgroundColor,
    required this.state,
  });

  final Color backgroundColor;
  final ColorsState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dynamic Templates",
            style: Theme.of(context).textTheme.titleLarge),
        elevation: 0,
        centerTitle: false,
        actions: <Widget>[
          Center(child: ColorSearchButton(color: backgroundColor)),
          const SizedBox(width: 8),
        ],
      ),
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        key: const PageStorageKey("TemplatesScrollView"),
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
                  final colors = getRandomDarkFrom(
                      state.selected, state.hsluvColors[state.selected]!);

                  final struct = TemplateStruct(
                    title: "1",
                    colors: [
                      colors[ColorType.Surface]!,
                      colors[ColorType.Background]!,
                      colors[ColorType.Secondary]!,
                    ],
                    contrastingColors: [
                      Colors.black,
                      Colors.white,
                      Colors.white
                    ],
                  );
                  return const Text("");
                  // return DynamicTemplatePreview(
                  //   struct.title,
                  //   struct.colors,
                  //   struct.contrastingColors,
                  // );
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
