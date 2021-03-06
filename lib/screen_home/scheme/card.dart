import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hsluv/hsluvcolor.dart';

import '../../blocs/blocs.dart';
import '../../util/constants.dart';
import '../../util/shuffle_color.dart';
import '../title_bar.dart';
import 'expandable_item.dart';

class ColorSchemeCard extends StatelessWidget {
  const ColorSchemeCard({
    required this.rgbColors,
    required this.rgbColorsWithBlindness,
    required this.hsluvColors,
    required this.locked,
    Key? key,
  }) : super(key: key);

  final Map<ColorType, Color> rgbColors;
  final Map<ColorType, Color> rgbColorsWithBlindness;
  final Map<ColorType, HSLuvColor> hsluvColors;
  final Map<ColorType, bool> locked;

  @override
  Widget build(BuildContext context) {
    // final isiPad = MediaQuery.of(context).size.width > 600;

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TitleBar(
            title: "Color Scheme",
            children: <Widget>[
              IconButton(
                tooltip: "Randomise colors",
                icon: Icon(
                  Icons.shuffle_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () async {
                  final box = await Hive.openBox<dynamic>('settings');
                  final int? pref = box.get('shuffle', defaultValue: 0);
                  context.read<ColorsCubit>().updateAllColors(
                        ignoreLock: false,
                        colors: getRandomPreference(pref),
                      );
                },
              ),
            ],
          ),
          Container(
            height: 1,
            margin: const EdgeInsets.all(1),
            width: double.infinity,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.20),
          ),
          // if (!kIsWeb)
          //   Divider(
          //     height: 0,
          //     indent: 1,
          //     endIndent: 1,
          //   ),
          SchemeExpandableItem(
            rgbColors,
            rgbColorsWithBlindness,
            hsluvColors,
            locked,
          ),
        ],
      ),
    );
  }
}
