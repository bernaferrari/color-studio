import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:colorstudio/example/contrast/inter_color_with_contrast.dart';

import '../blocs.dart';
import 'multiple_contrast_color_event.dart';
import 'multiple_contrast_color_state.dart';

class MultipleContrastColorBloc
    extends Bloc<MultipleContrastColorEvent, MultipleContrastColorState> {
  MultipleContrastColorBloc(this._mdcSelectedBloc) {
    _mdcSubscription = _mdcSelectedBloc.listen((stateValue) async {
      if (stateValue is MDCLoadedState) {
        add(
          MultipleContrastUpdated(
            stateValue.rgbColors.values.toList(),
//            (state as MultipleContrastColorLoaded).selected,
          ),
        );
      }
    });
  }

  final MdcSelectedBloc _mdcSelectedBloc;
  StreamSubscription _mdcSubscription;

  @override
  Future<void> close() {
    _mdcSubscription.cancel();
    return super.close();
  }

  @override
  MultipleContrastColorState get initialState => MultipleContrastColorLoading();

  @override
  Stream<MultipleContrastColorState> mapEventToState(
    MultipleContrastColorEvent event,
  ) async* {
    if (event is MultipleContrastUpdated) {
      yield* _mapInit(event);
    } else if (event is MCMoveColor) {
      yield* _mapColor(event);
    }
  }

  Stream<MultipleContrastColorState> _mapInit(MultipleContrastUpdated load) async* {
    final List<ContrastedColor> loadedColors = <ContrastedColor>[];

    for (int i = 0; i < load.colors.length; i++) {
      final initColor = load.colors[0];
      final currentColor = load.colors[i];

      loadedColors.add(
        ContrastedColor(
          currentColor,
          calculateContrast(initColor, currentColor),
        ),
      );
    }

    yield MultipleContrastColorLoaded(loadedColors, 0);
  }

  Stream<MultipleContrastColorState> _mapColor(MCMoveColor load) async* {
    final loadedState = state as MultipleContrastColorLoaded;

    // this is necessary, else you modify the original list but this change
    // is gone when you call yield, so it appears the list didn't change.
    final newList = List<ContrastedColor>.from(loadedState.colorsList);
    final index = load.index ?? loadedState.selected;

    final initColor = newList[0].rgbColor;

    newList[index] = ContrastedColor(
      load.color,
      calculateContrast(
        load.color,
        initColor,
      ),
    );

    if (index == 0) {
      for (int i = 1; i < newList.length; i++) {
        newList[i] = ContrastedColor(
          newList[i].rgbColor,
          calculateContrast(
            newList[i].rgbColor,
            newList[0].rgbColor,
          ),
        );
      }
    }

    yield MultipleContrastColorLoaded(newList, index);
  }
}
