import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hsluv/hsluvcolor.dart';
import 'package:rxdart/rxdart.dart';

import '../../example/mdc/util/color_blind_from_index.dart';
import '../../example/util/color_util.dart';
import '../../example/util/constants.dart';
import '../blocs.dart';
import 'mdc_selected.dart';

class MdcSelectedBloc extends Bloc<MdcSelectedEvent, MdcSelectedState> {
  MdcSelectedBloc(ColorBlindnessCubit _colorBlindnessCubit)
      : super(MDCInitialState()) {
    _blindnessSubscription = _colorBlindnessCubit.listen((stateValue) async {
      add(
        MDCBlindnessEvent(
          blindnessSelected: stateValue,
        ),
      );
    });
  }

  StreamSubscription _blindnessSubscription;

  @override
  Stream<Transition<MdcSelectedEvent, MdcSelectedState>> transformEvents(
      Stream<MdcSelectedEvent> events,
      TransitionFunction<MdcSelectedEvent, MdcSelectedState> transitionFn) {
    return events.switchMap(transitionFn);
  }

  @override
  Future<void> close() {
    _blindnessSubscription.cancel();
    return super.close();
  }

  @override
  Stream<MdcSelectedState> mapEventToState(
    MdcSelectedEvent event,
  ) async* {
    if (event is MDCInitEvent) {
      yield* _mapInitToState(event);
    } else if (event is MDCLoadEvent) {
      yield* _mapLoadedToState(event);
    } else if (event is MDCUpdateAllEvent) {
      yield* _mapUpdateAllToState(event);
    } else if (event is MDCBlindnessEvent) {
      yield* _mapBlindnessToState(event);
    } else if (event is MDCUpdateColor) {
      yield* _mapUpdateToState(event);
    } else if (event is MDCUpdateLock) {
      yield* _mapUpdateToLock(event);
    }
  }

  Stream<MdcSelectedState> _mapInitToState(MDCInitEvent load) async* {
    final initial = {
      ColorType.Primary: load.initialColors[ColorType.Primary],
      ColorType.Secondary: load.initialColors[ColorType.Secondary],
      ColorType.Background:
          blendColorWithBackground(load.initialColors[ColorType.Primary]),
      ColorType.Surface: load.initialColors[ColorType.Surface],
    };

    final initialLocked = <ColorType, bool>{};

    yield MDCLoadedState(
      initial,
      convertToHSLuv(initial),
      initial,
      initialLocked,
      ColorType.Primary,
      0,
    );
  }

  Stream<MdcSelectedState> _mapUpdateToLock(MDCUpdateLock load) async* {
    final currentState = state as MDCLoadedState;

    final allRgb = Map<ColorType, Color>.from(currentState.rgbColors);
    final lock = Map<ColorType, bool>.from(currentState.locked);
    lock[load.selected] = load.isLock;

    // Background needs to call [findColor] before Surface does, else
    // Surface will receive the previous Background color.
    [
      ColorType.Background,
      ColorType.Surface,
      ColorType.Secondary,
    ].forEach((key) {
      // if it is null, Dart throws an exception
      if (lock[key] == true) {
        final updatedColor = findColor(allRgb, key);
        allRgb[key] = updatedColor;
      }
    });

    yield MDCLoadedState(
      allRgb,
      convertToHSLuv(allRgb),
      getBlindness(allRgb, currentState.blindnessSelected),
      lock,
      load.selected,
      currentState.blindnessSelected,
    );
  }

  Stream<MdcSelectedState> _mapUpdateToState(MDCUpdateColor load) async* {
    final currentState = state as MDCLoadedState;

    final blindness = currentState.blindnessSelected;
    final allLuv = Map<ColorType, HSLuvColor>.from(currentState.hsluvColors);
    final allRgb = Map<ColorType, Color>.from(currentState.rgbColors);

    if (load.color != null) {
      allLuv[load.selected] = HSLuvColor.fromColor(load.color);
      allRgb[load.selected] = load.color;
    } else {
      allLuv[load.selected] = load.hsLuvColor;
      allRgb[load.selected] = load.hsLuvColor.toColor();
    }

    // update the color of the locked ones.
    currentState.locked.keys.forEach((key) {
      if (currentState.locked[key]) {
        allRgb[key] = findColor(allRgb, key);
      }
    });

    yield MDCLoadedState(
      allRgb,
      allLuv,
      getBlindness(allRgb, blindness),
      currentState.locked,
      load.selected,
      blindness,
    );
  }

  Stream<MdcSelectedState> _mapLoadedToState(MDCLoadEvent load) async* {
    final currentState = state as MDCLoadedState;
    final selected = load.selected ?? currentState.selected;

    final Map<ColorType, Color> allRgb = Map.from(currentState.rgbColors);
    allRgb[selected] = load.currentColor;

    final blindness = currentState.blindnessSelected;

    // update the color of the locked ones.
    currentState.locked.keys.forEach((k) {
      if (currentState.locked[k]) {
        allRgb[k] = findColor(allRgb, k);
      }
    });

    yield MDCLoadedState(
      allRgb,
      convertToHSLuv(allRgb),
      getBlindness(allRgb, blindness),
      currentState.locked,
      selected,
      blindness,
    );
  }

  Stream<MdcSelectedState> _mapBlindnessToState(MDCBlindnessEvent load) async* {
    final Map<ColorType, Color> updatableMap =
        (state as MDCLoadedState).rgbColors;

    yield MDCLoadedState(
      updatableMap,
      convertToHSLuv(updatableMap),
      getBlindness(updatableMap, load.blindnessSelected),
      (state as MDCLoadedState).locked,
      (state as MDCLoadedState).selected,
      load.blindnessSelected,
    );
  }

  Stream<MdcSelectedState> _mapUpdateAllToState(MDCUpdateAllEvent load) async* {
    final currentState = state as MDCLoadedState;

    final Map<ColorType, Color> allRgb = Map.from(currentState.rgbColors);

    allRgb.forEach((title, _) {
      if (currentState.locked[title] != true || load.ignoreLock) {
        allRgb[title] = load.colors[title];
      }
    });

    // update the color of the locked ones.
    currentState.locked.keys.forEach((k) {
      if (currentState.locked[k]) {
        allRgb[k] = findColor(allRgb, k);
      }
    });

    final blindness = (state as MDCLoadedState).blindnessSelected;

    yield MDCLoadedState(
      allRgb,
      convertToHSLuv(allRgb),
      getBlindness(allRgb, blindness),
      currentState.locked,
      currentState.selected,
      blindness,
    );
  }

  Color findColor(Map<ColorType, Color> mappedList, ColorType category) {
    if (category == ColorType.Background) {
      return blendColorWithBackground(mappedList[ColorType.Primary]);
    } else if (category == ColorType.Surface) {
      final luv = HSLuvColor.fromColor(mappedList[ColorType.Background]);
      return luv.withLightness(luv.lightness + 5).toColor();
    } else if (category == ColorType.Secondary) {
      final luv = HSLuvColor.fromColor(mappedList[ColorType.Primary]);
      return luv.withHue((luv.lightness + 90) % 360).toColor();
    }

    return const Color(0xffffffff);
  }

  Map<ColorType, HSLuvColor> convertToHSLuv(
      Map<ColorType, Color> updatableMap) {
    final luvMap = <ColorType, HSLuvColor>{};

    for (var key in updatableMap.keys) {
      luvMap[key] = HSLuvColor.fromColor(updatableMap[key]);
    }

    return luvMap;
  }

  Map<ColorType, Color> getBlindness(
      Map<ColorType, Color> updatableMap, int index) {
    if (index == 0) {
      return updatableMap;
    }

    final Map<ColorType, Color> blindMap = Map.from(updatableMap);
    for (var key in blindMap.keys) {
      blindMap[key] = getColorBlindFromIndex(blindMap[key], index).color;
    }

    return blindMap;
  }
}
