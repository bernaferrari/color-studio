import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:colorstudio/example/blocs/slider_color/slider_color_state.dart';
import 'package:colorstudio/example/mdc/util/color_blind_from_index.dart';
import 'package:colorstudio/example/util/color_util.dart';
import 'package:colorstudio/example/util/constants.dart';
import 'package:hsluv/hsluvcolor.dart';
import 'package:rxdart/rxdart.dart';

import './mdc_selected.dart';
import '../blocs.dart';

class MdcSelectedBloc extends Bloc<MdcSelectedEvent, MdcSelectedState> {
  MdcSelectedBloc(this._sliderColorsBloc, this._blindnessBloc) {
    _slidersSubscription = _sliderColorsBloc.listen((stateValue) async {
      if (stateValue is SliderColorLoaded) {
        add(
          MDCLoadEvent(
            currentColor: stateValue.rgbColor,
            selected: (state as MDCLoadedState).selected,
          ),
        );
      }
    });

    _blindnessSubscription = _blindnessBloc.listen((stateValue) async {
      add(
        MDCBlindnessEvent(
          blindnessSelected: stateValue,
        ),
      );
    });
  }

  final ColorBlindBloc _blindnessBloc;
  StreamSubscription _blindnessSubscription;

  final SliderColorBloc _sliderColorsBloc;
  StreamSubscription _slidersSubscription;

  @override
  Stream<MdcSelectedState> transformEvents(events, next) {
    return events.switchMap(next);
  }

  final initial = {
    kPrimary: const Color(0xffFFCC80),
    kBackground: const Color(0xff121212),
    kSurface: const Color(0xff131024),
  };

  final initialLocked = {
    kBackground: true,
  };

  @override
  Future<void> close() {
    _blindnessSubscription.cancel();
    _slidersSubscription.cancel();
    return super.close();
  }

  @override
  MdcSelectedState get initialState => MDCLoadedState(
        initial,
        convertToHSLuv(initial),
        initial,
        initialLocked,
        kPrimary,
        0,
      );

  @override
  Stream<MdcSelectedState> mapEventToState(
    MdcSelectedEvent event,
  ) async* {
    if (event is MDCLoadEvent) {
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

  Stream<MdcSelectedState> _mapUpdateToLock(MDCUpdateLock load) async* {
    final currentState = (state as MDCLoadedState);

    final Map<String, Color> allRgb = Map.from(currentState.rgbColors);

    final Map<String, bool> lock = Map.from(currentState.locked);
    lock[load.selected] = load.isLock;

    // Background needs to call [findColor] before Surface does, else
    // Surface will receive the previous Background color.
    [
      kBackground,
      kSurface,
      /*kSecondary,*/
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
    final currentState = (state as MDCLoadedState);

    final blindness = currentState.blindnessSelected;
    final Map<String, HSLuvColor> allLuv = Map.from(currentState.hsluvColors);
    final Map<String, Color> allRgb = Map.from(currentState.rgbColors);

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
    final currentState = (state as MDCLoadedState);
    final selected = load.selected ?? currentState.selected;

    final Map<String, Color> allRgb = Map.from(currentState.rgbColors);
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
    final Map<String, Color> updatableMap = (state as MDCLoadedState).rgbColors;

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
    final currentState = (state as MDCLoadedState);

    final Map<String, Color> allRgb = Map.from(currentState.rgbColors);

    int i = 0;
    allRgb.forEach((String title, Color b) {
      if (currentState.locked[title] != true || load.ignoreLock) {
        allRgb[title] = load.colors[i];
        i += 1;
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

  Color findColor(Map<String, Color> mappedList, String category) {
    if (category == kBackground) {
      return blendColorWithBackground(mappedList[kPrimary]);
    } else if (category == kSurface) {
      return mappedList[kBackground];
    } else if (category == kSecondary) {
      return mappedList[kPrimary];
    }

    return const Color(0xffffffff);
  }

  Map<String, HSLuvColor> convertToHSLuv(Map<String, Color> updatableMap) {
    final Map<String, HSLuvColor> luvMap = Map<String, HSLuvColor>();

    updatableMap.keys.forEach((key) {
      luvMap[key] = HSLuvColor.fromColor(updatableMap[key]);
    });

    return luvMap;
  }

  Map<String, Color> getBlindness(Map<String, Color> updatableMap, int index) {
    if (index == 0) {
      return updatableMap;
    }

    final Map<String, Color> blindMap = Map.from(updatableMap);
    blindMap.keys.forEach((f) {
      blindMap[f] = getColorBlindFromIndex(blindMap[f], index).color;
    });

    return blindMap;
  }
}
