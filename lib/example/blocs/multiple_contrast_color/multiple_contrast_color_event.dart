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
