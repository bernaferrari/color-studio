import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SliderColorEvent extends Equatable {
  const SliderColorEvent();
}

class MoveColor extends SliderColorEvent {
  const MoveColor(this.color, this.updateTextField);

  final Color color;
  final bool updateTextField;

  @override
  String toString() => "MoveColor...";

  @override
  List<Object> get props => [color, updateTextField];
}

class MoveRGB extends SliderColorEvent {
  const MoveRGB(this.r, this.g, this.b);

  final int r;
  final int g;
  final int b;

  @override
  String toString() => "MoveRGB...";

  @override
  List<Object> get props => [r, g, b];
}

class MoveHSV extends SliderColorEvent {
  const MoveHSV(this.h, this.s, this.v) : super();

  final double h;
  final double s;
  final double v;

  @override
  String toString() => "MoveHSV...";

  @override
  List<Object> get props => [h, s, v];
}

class MoveHSLuv extends SliderColorEvent {
  const MoveHSLuv(this.h, this.s, this.l) : super();

  final double h;
  final double s;
  final double l;

  @override
  String toString() => "MoveHSL...";

  @override
  List<Object> get props => [h, s, l];
}
