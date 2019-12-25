import 'package:colorstudio/example/blocs/blocs.dart';
import 'package:colorstudio/example/util/constants.dart';
import 'package:colorstudio/example/util/selected.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class TextFormColored extends StatelessWidget {
  const TextFormColored({this.controller, this.radius, this.autofocus = true});

  final double radius;
  final bool autofocus;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.only(
      topLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
    );

    return TextFormField(
      autofocus: autofocus,
      controller: controller,
      onChanged: (str) {
        BlocProvider.of<SliderColorBloc>(context).add(
            MoveColor(Color(int.parse("0xFF${str.padRight(6, "F")}")), false));
      },
      inputFormatters: [
        LengthLimitingTextInputFormatter(6),
      ],
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white38, width: 2),
          borderRadius: borderRadius,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black26, width: 2),
          borderRadius: borderRadius,
        ),
        filled: true,
        fillColor: (Theme.of(context).colorScheme.primary.computeLuminance() >
                kLumContrast)
            ? Colors.black12
            : Colors.white24,
        prefix: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Icon(FeatherIcons.hash, size: 16),
        ),
        suffixIcon: SizedBox(
          width: 48,
          height: 36,
          child: IconButton(
            onPressed: () {
              copyToClipboard(context, controller.text);
            },
            tooltip: "Copy to clipboard",
            icon: Icon(
              FeatherIcons.copy,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ),
      ),
      style: Theme.of(context).textTheme.title.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
    );
  }
}
