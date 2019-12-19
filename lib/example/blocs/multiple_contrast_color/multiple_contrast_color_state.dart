import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:hsluv/hsluvcolor.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MultipleContrastColorState extends Equatable {
  const MultipleContrastColorState();
}

class MultipleContrastColorLoading extends MultipleContrastColorState {
  @override
  String toString() => 'BlindColorsLoading state';

  @override
  List<Object> get props => [];
}

class MultipleContrastColorLoaded extends MultipleContrastColorState {
  const MultipleContrastColorLoaded(this.colorsList, this.selected);

  final List<ContrastedColor> colorsList;
  final int selected;

  @override
  String toString() => 'BlindColorsLoaded state $colorsList';

  @override
  List<Object> get props => [colorsList, selected];
}

class ContrastedColor {
  ContrastedColor(this.rgbColor, this.contrast)
      : hsluvColor = HSLuvColor.fromColor(rgbColor);

  final Color rgbColor;
  final double contrast;
  final HSLuvColor hsluvColor;

  @override
  String toString() => "$rgbColor";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContrastedColor &&
          runtimeType == other.runtimeType &&
          rgbColor == other.rgbColor;

  @override
  int get hashCode => rgbColor.hashCode;
}
