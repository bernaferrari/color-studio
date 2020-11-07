import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hsluv/hsluvcolor.dart';
import 'package:rxdart/rxdart.dart';

import '../blocs.dart';
import 'slider_color_event.dart';
import 'slider_color_state.dart';

class SliderColorBloc extends Bloc<SliderColorEvent, SliderColorState> {
  SliderColorBloc() : super(SliderColorLoading());

  @override
  Stream<Transition<SliderColorEvent, SliderColorState>> transformEvents(
      Stream<SliderColorEvent> events,
      TransitionFunction<SliderColorEvent, SliderColorState> transitionFn) {
    return events.switchMap(transitionFn);
  }

  @override
  Stream<SliderColorState> mapEventToState(
    SliderColorEvent event,
  ) async* {
    if (event is MoveRGB) {
      yield* _mapRGB(event);
    }
    if (event is MoveHSV) {
      yield* _mapHSV(event);
    }
    if (event is MoveHSLuv) {
      yield* _mapHSLuv(event);
    }
    if (event is MoveColor) {
      yield* _mapColor(event);
    }
  }

  Stream<SliderColorState> _mapHSLuv(MoveHSLuv load) async* {
    final hsluv = HSLuvColor.fromHSL(load.h, load.s, load.l);
    final color = hsluv.toColor();
    yield SliderColorLoaded(HSVColor.fromColor(color), color, hsluv, true);
  }

  Stream<SliderColorState> _mapHSV(MoveHSV load) async* {
    final hsv = HSVColor.fromAHSV(1, load.h, load.s, load.v);
    final color = hsv.toColor();
    yield SliderColorLoaded(
      hsv,
      color,
      HSLuvColor.fromColor(color),
      true,
    );
  }

  Stream<SliderColorState> _mapRGB(MoveRGB load) async* {
    final rgb = Color.fromARGB(255, load.r, load.g, load.b);
    yield SliderColorLoaded(
      HSVColor.fromColor(rgb),
      rgb,
      HSLuvColor.fromColor(rgb),
      true,
    );
  }

  Stream<SliderColorState> _mapColor(MoveColor load) async* {
    yield SliderColorLoaded(
      HSVColor.fromColor(load.color),
      load.color,
      HSLuvColor.fromColor(load.color),
      load.updateTextField,
    );
  }
}
