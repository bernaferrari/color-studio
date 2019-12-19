import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:hsluv/hsluvcolor.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SliderColorState extends Equatable {
  const SliderColorState();
}

class SliderColorLoading extends SliderColorState {
  @override
  String toString() => 'BlindColorsLoading state';

  @override
  List<Object> get props => [];
}

class SliderColorLoaded extends SliderColorState {
  const SliderColorLoaded(this.hsvColor,
      this.rgbColor,
      this.hsluvColor, [
        this.updateTextField = false,
      ]);

  final Color rgbColor;
  final HSVColor hsvColor;
  final HSLuvColor hsluvColor;
  final bool updateTextField;

  @override
  String toString() => 'BlindColorsLoaded state';

  @override
  List<Object> get props => [hsvColor, rgbColor, hsluvColor, updateTextField];
}
