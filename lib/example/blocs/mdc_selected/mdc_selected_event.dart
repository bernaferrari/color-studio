import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hsluv/hsluvcolor.dart';

abstract class MdcSelectedEvent extends Equatable {
  const MdcSelectedEvent();
}

class MDCBlindnessEvent extends MdcSelectedEvent {
  const MDCBlindnessEvent({this.blindnessSelected});

  final int blindnessSelected;

  @override
  String toString() => "MDCBlindnessEvent... | $blindnessSelected";

  @override
  List<Object> get props => [blindnessSelected];
}

class MDCInitEvent extends MdcSelectedEvent {
  const MDCInitEvent(this.initialList);

  final List<Color> initialList;

  @override
  String toString() => "MDC Init Event";

  @override
  List<Object> get props => [];
}

class MDCLoadEvent extends MdcSelectedEvent {
  const MDCLoadEvent({
    @required this.currentColor,
    this.selected,
  });

  final Color currentColor;
  final String selected;

  @override
  String toString() => "MDCLoadEvent... $currentColor | $selected";

  @override
  List<Object> get props => [currentColor, selected];
}

class MDCUpdateLock extends MdcSelectedEvent {
  const MDCUpdateLock({
    this.isLock,
    this.selected,
  });

  final bool isLock;
  final String selected;

  @override
  String toString() => "MDCUpdateLock... lock: $isLock on: $selected";

  @override
  List<Object> get props => [isLock, selected];
}

class MDCUpdateColor extends MdcSelectedEvent {
  const MDCUpdateColor({
    this.color,
    this.hsLuvColor,
    this.selected,
  });

  final Color color;
  final HSLuvColor hsLuvColor;
  final String selected;

  @override
  String toString() => "MDCLoadEvent... $color | $selected | $hsLuvColor";

  @override
  List<Object> get props => [color, hsLuvColor, selected];
}

class MDCUpdateAllEvent extends MdcSelectedEvent {
  const MDCUpdateAllEvent({
    this.colors,
    this.ignoreLock = false,
  });

  final List<Color> colors;
  final bool ignoreLock;

  @override
  String toString() => "MDCUpdateAllEvent... $colors";

  @override
  List<Object> get props => [colors];
}
