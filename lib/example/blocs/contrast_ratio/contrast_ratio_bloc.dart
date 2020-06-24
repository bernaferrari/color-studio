import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:colorstudio/example/blocs/blocs.dart';
import 'package:colorstudio/example/contrast/inter_color_with_contrast.dart';
import 'package:colorstudio/example/mdc/util/elevation_overlay.dart';
import 'package:colorstudio/example/util/color_util.dart';
import 'package:colorstudio/example/util/constants.dart';

import './contrast_ratio.dart';

class ContrastRatioBloc extends Bloc<ContrastRatioEvent, ContrastRatioState> {
  ContrastRatioBloc(this._mdcSelectedBloc) {
    _mdcSubscription = _mdcSelectedBloc.listen((stateValue) async {
      if (stateValue is MDCLoadedState) {
        add(
          ContrastRatioUpdated(
            rgbColorsWithBlindness: stateValue.rgbColorsWithBlindness,
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
  ContrastRatioState get initialState => InitialContrastRatioState();

//  @override
//  Stream<ContrastRatioState> transformEvents(events, next) {
//    return events.switchMap(next);
//  }

  @override
  Stream<ContrastRatioState> mapEventToState(
    ContrastRatioEvent event,
  ) async* {
    if (event is ContrastRatioUpdated) {
      yield* _mapLoadedToState(event);
    }
  }

  Stream<ContrastRatioState> _mapLoadedToState(
      ContrastRatioUpdated load) async* {
    final rgb = load.rgbColorsWithBlindness;

    yield ContrastRatioSuccess(contrastValues: [
      calculateContrast(rgb[kPrimary], rgb[kBackground]),
      calculateContrast(rgb[kPrimary], rgb[kSurface]),
      calculateContrast(rgb[kBackground], rgb[kSurface]),
    ], elevationValues: [
      for (int i = 0; i < elevationEntriesList.length; i++)
        ColorContrast(
          compositeColors(
            const Color(0xffffffff),
            rgb[kSurface],
            elevationEntries[i].overlay,
          ),
          rgb[kPrimary],
        ),
    ]);
  }
}
