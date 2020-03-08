import 'package:flutter/material.dart';

class ContainerWithNumber extends StatelessWidget {
  const ContainerWithNumber(this.letter, this.backgroundColor, this.indexColor);

  final String letter;
  final Color backgroundColor;
  final Color indexColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      margin: const EdgeInsets.only(right: 16),
      child: Center(
        child: Text(
          letter,
          style: Theme.of(context).textTheme.headline5.copyWith(
              fontWeight: FontWeight.w500,
              color: backgroundColor,
              fontSize: (letter.length < 3) ? 24 : 20
              // auto-scale if index has 3 digits.
              ),
        ),
      ),
      decoration: BoxDecoration(
        color: indexColor,
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
    );
  }
}
