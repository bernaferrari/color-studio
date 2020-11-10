import 'package:color_blindness/color_blindness.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';
import '../../example/screens/single_color_blindness.dart';
import '../../example/util/constants.dart';
import 'item.dart';
import 'item_simplified.dart';

class ColorBlindnessListSimplified extends StatelessWidget {
  const ColorBlindnessListSimplified({this.contrastedList, this.locked});

  final Map<ColorType, Color> contrastedList;
  final Map<ColorType, bool> locked;

  @override
  Widget build(BuildContext context) {
    final mappedValues = <ColorType, List<ColorWithBlind>>{};
    contrastedList.forEach((key, value) {
      mappedValues[key] = retrieveColorBlindList(value);
    });

    final List<ColorWithBlind> primaryBlind = mappedValues[ColorType.Primary];
    final surfaceBlind = mappedValues[ColorType.Surface];

    return BlocBuilder<ColorBlindnessCubit, int>(builder: (_, state) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          runSpacing: 8,
          spacing: 8,
          alignment: WrapAlignment.center,
          children: <Widget>[
            for (int i = 0; i < primaryBlind.length; i++)
              ColorBlindnessItemSimplified(
                value: i,
                groupValue: state,
                backgroundColor: surfaceBlind[i].color,
                colorWithBlindList: [
                  for (var item in mappedValues.keys)
                    if (item != ColorType.Surface) mappedValues[item][i],
                ],
                primaryColor: primaryBlind[i].color,
                onChanged: (selectedIndex) {
                  context.read<ColorBlindnessCubit>().set(selectedIndex);
                },
                title: primaryBlind[i].name,
                subtitle: primaryBlind[i].affects,
              ),
          ],
        ),
      );
    });
  }

  /// sources:
  /// https://www.color-blindness.com/
  /// https://www.color-blindness.com/category/tools/
  /// https://en.wikipedia.org/wiki/Color_blindness
  /// https://en.wikipedia.org/wiki/Dichromacy
  List<ColorWithBlind> retrieveColorBlindList(Color color) {
    const m = "of males";
    const f = "of females";
    const p = "of population";

    return [
      ColorWithBlind(color, "None", "default"),
      ColorWithBlind(protanomaly(color), "Protanomaly", "1% $m, 0.01% $f"),
      ColorWithBlind(deuteranomaly(color), "Deuteranomaly", "6% $m, 0.4% $f"),
      ColorWithBlind(tritanomaly(color), "Tritanomaly", "0.01% $p"),
      ColorWithBlind(protanopia(color), "Protanopia", "1% $m"),
      ColorWithBlind(deuteranopia(color), "Deuteranopia", "1% $m"),
      ColorWithBlind(tritanopia(color), "Tritanopia", "less than 1% $p"),
      ColorWithBlind(achromatopsia(color), "Achromatopsia", "0.003% $p"),
      ColorWithBlind(achromatomaly(color), "Achromatomaly", "0.001% $p"),
    ];
  }
}
