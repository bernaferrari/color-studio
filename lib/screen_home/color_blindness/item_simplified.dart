import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../example/screens/single_color_blindness.dart';

class ColorBlindnessItemSimplified extends StatelessWidget {
  const ColorBlindnessItemSimplified({
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
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: value == groupValue ? primaryColor : null,
        padding: const EdgeInsets.all(24),
      ),
      onPressed: () => onChanged(value),
      child: SizedBox(
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
                      border: Border.all(
                        width: 1,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.20),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
