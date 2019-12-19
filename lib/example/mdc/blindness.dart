import 'dart:math' as math;

import 'package:colorstudio/example/blocs/blocs.dart';
import 'package:colorstudio/example/util/color_blindness.dart';
import 'package:colorstudio/example/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../screens/single_color_blindness.dart';

class ColorBlindnessTheme extends StatelessWidget {
  const ColorBlindnessTheme({this.contrastedList, this.locked});

  final Map<String, Color> contrastedList;
  final Map<String, bool> locked;

  @override
  Widget build(BuildContext context) {
    final mappedValues = Map<String, List<ColorWithBlind>>();
//    final Map<String, Color> mutableMap = Map.from(contrastedList);
//    mutableMap.removeWhere((String key, Color _) => locked[key] == true);
    contrastedList.forEach((String key, Color value) {
      mappedValues[key] = retrieveColorBlindList(value);
    });

    final List<ColorWithBlind> primaryBlind = mappedValues[kPrimary];
    final surfaceBlind = mappedValues[kBackground];

    return BlocBuilder<ColorBlindBloc, int>(
        builder: (BuildContext context, int state) {
      return Column(
        children: <Widget>[
          for (int i = 0; i < primaryBlind.length; i++) ...[
            _RadioTile(
              value: i,
              groupValue: state,
              backgroundColor: surfaceBlind[i].color,
              colorWithBlindList: [
                for (String item in mappedValues.keys) mappedValues[item][i],
              ],
              primaryColor: primaryBlind[i].color,
              onChanged: (int event) {
                BlocProvider.of<ColorBlindBloc>(context).add(event);
              },
              title: primaryBlind[i].name,
              subtitle: primaryBlind[i].affects,
            ),
            Divider(
              height: 0,
              indent: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.30),
            ),
          ],
        ],
      );
    });
  }

  // sources:
// https://www.color-blindness.com/
// https://www.color-blindness.com/category/tools/
// https://en.wikipedia.org/wiki/Color_blindness
// https://en.wikipedia.org/wiki/Dichromacy
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

class _RadioTile extends StatelessWidget {
  const _RadioTile({
    Key key,
    this.value,
    this.groupValue,
    this.title,
    this.subtitle,
    this.backgroundColor,
    this.primaryColor,
    this.colorWithBlindList,
    this.onChanged,
  }) : super(key: key);

  final int value;
  final int groupValue;
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color primaryColor;
  final List<ColorWithBlind> colorWithBlindList;
  final Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      // According to https://github.com/flutter/flutter/issues/3782,
      // InkWell should be a child of Material, not Container.
      color: backgroundColor,
      child: InkWell(
        onTap: () => onChanged(value),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Radio(
                value: value,
                groupValue: groupValue,
                onChanged: onChanged,
                activeColor: primaryColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    Text(subtitle, style: Theme.of(context).textTheme.caption),
                  ],
                ),
              ),
              SizedBox(
                width: 12 + 12.0 * colorWithBlindList.length,
                child: Stack(
                  children: <Widget>[
                    SizedBox(height: 24),
                    for (int i = colorWithBlindList.length - 1; i >= 0; i--)
                      Positioned.fill(
                        left: 12.0 * i,
                        right: null,
                        top: 0,
                        bottom: 0,
                        child: Transform.rotate(
                          angle: math.pi / 4,
                          child: Container(
                            width: 24,
                            decoration: BoxDecoration(
                              color: colorWithBlindList[i].color,
//                            shape: BoxShape.circle,
                              borderRadius: BorderRadius.circular(6),
//                            border: Border.all(
//                              color: Theme.of(context)
//                                  .colorScheme
//                                  .onSurface
//                                  .withOpacity(0.5),
//                              width: 2,
//                            ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
