import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:colorstudio/example/blocs/blocs.dart';

void copyToClipboard(BuildContext context, String text) {
  Clipboard.setData(ClipboardData(text: text));

  Scaffold.of(context).hideCurrentSnackBar();
  final snackBar = SnackBar(
    content: Text('$text copied'),
    duration: const Duration(milliseconds: 1000),
  );
  Scaffold.of(context).showSnackBar(snackBar);
}

void colorSelected(BuildContext context, Color color) {

  BlocProvider.of<MdcSelectedBloc>(context).add(MDCLoadEvent(currentColor: color));



//  BlocProvider.of<MultipleContrastColorBloc>(context).add(MCMoveColor(color));

//  BlocProvider.of<SliderColorBloc>(context).add(MoveColor(color, true));
}
