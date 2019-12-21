import 'dart:math' as math;

import 'package:colorstudio/example/screens/single_color_blindness.dart';
import 'package:flutter/material.dart';

class ColorBlindnessItem extends StatelessWidget {
  const ColorBlindnessItem({
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
                      style: Theme.of(context).textTheme.title,
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.caption,
                    ),
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
                              borderRadius: BorderRadius.circular(6),
//                              border: Border.all(
//                                color: Theme.of(context)
//                                    .colorScheme
//                                    .onSurface
//                                    .withOpacity(0.5),
//                                width: 1,
//                              ),
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
