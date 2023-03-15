import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hsluv/hsluvcolor.dart';
import 'package:rxdart/rxdart.dart';

import '../blocs.dart';

EventTransformer<MyEvent> switchMap<MyEvent>() {
  return (events, mapper) => events.switchMap(mapper);
}

class SliderColorBloc extends Bloc<SliderColorEvent, SliderColorState> {
  SliderColorBloc() : super(SliderColorLoading()) {
    on<MoveRGB>(
      (event, emit) => _mapRGB(event, emit),
      transformer: switchMap(),
    );
    on<MoveHSV>(
      (event, emit) => _mapHSV(event, emit),
      transformer: switchMap(),
    );
    on<MoveHSLuv>(
      (event, emit) => _mapHSLuv(event, emit),
      transformer: switchMap(),
    );
    on<MoveColor>(
      (event, emit) => _mapColor(event, emit),
      transformer: switchMap(),
    );
  }

  void _mapHSLuv(MoveHSLuv load, Emitter<SliderColorState> emit) {
    final hsluv = HSLuvColor.fromHSL(load.h, load.s, load.l);
    final color = hsluv.toColor();
    emit(SliderColorLoaded(HSVColor.fromColor(color), color, hsluv, true));
  }

  void _mapHSV(MoveHSV load, Emitter<SliderColorState> emit) {
    final hsv = HSVColor.fromAHSV(1, load.h, load.s, load.v);
    final color = hsv.toColor();
    emit(SliderColorLoaded(
      hsv,
      color,
      HSLuvColor.fromColor(color),
      true,
    ));
  }

  void _mapRGB(MoveRGB load, Emitter<SliderColorState> emit) {
    final rgb = Color.fromARGB(255, load.r, load.g, load.b);
    emit(SliderColorLoaded(
      HSVColor.fromColor(rgb),
      rgb,
      HSLuvColor.fromColor(rgb),
      true,
    ));
  }

  void _mapColor(MoveColor load, Emitter<SliderColorState> emit) {
    emit(SliderColorLoaded(
      HSVColor.fromColor(load.color),
      load.color,
      HSLuvColor.fromColor(load.color),
      load.updateTextField,
    ));
  }
}
