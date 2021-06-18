import 'package:flutter/material.dart';

class OutlinedIconButton extends StatelessWidget {
  const OutlinedIconButton(
      {this.child, this.borderColor, this.onPressed, Key? key})
      : super(key: key);

  final VoidCallback? onPressed;
  final Widget? child;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: const CircleBorder(),
          side: BorderSide(
            color: borderColor ??
                Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
          primary: Theme.of(context).colorScheme.onSurface,
          padding: EdgeInsets.zero,
        ),
        child: child!,
        onPressed: onPressed,
      ),
    );
  }
}
