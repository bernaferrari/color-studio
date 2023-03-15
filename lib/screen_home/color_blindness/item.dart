import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../example/screens/single_color_blindness.dart';

class ColorBlindnessItem extends StatelessWidget {
  const ColorBlindnessItem({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.primaryColor,
    required this.colorWithBlindList,
    required this.onChanged,
  }) : super(key: key);

  final int value;
  final int groupValue;
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color primaryColor;
  final List<ColorWithBlind> colorWithBlindList;
  final ValueChanged<int?> onChanged;

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
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.openSans(
                        textStyle: Theme.of(context).textTheme.bodySmall,
                      ),
                      // style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 12 + 12.0 * colorWithBlindList.length,
                child: Stack(
                  children: <Widget>[
                    const SizedBox(height: 24),
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
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
