import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MultipleContrastColorEvent extends Equatable {
  const MultipleContrastColorEvent();
}

class MultipleContrastUpdated extends MultipleContrastColorEvent {
  const MultipleContrastUpdated(this.colors);

  final List<Color> colors;

  @override
  String toString() => "LoadInit...";

  @override
  List<Object> get props => colors;
}

// all classes get C in front of them to differentiate from SliderColorBloc.
class MCMoveColor extends MultipleContrastColorEvent {
  const MCMoveColor(this.color, [this.index]);

  final Color color;
  final int index;

  @override
  String toString() => "MCMoveColor $color..";

  @override
  List<Object> get props => [color, index];
}
