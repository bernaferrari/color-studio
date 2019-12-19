import 'dart:async';

import 'package:bloc/bloc.dart';

class ColorBlindBloc extends Bloc<int, int> {
  @override
  int get initialState => 0;

  @override
  Stream<int> mapEventToState(
    int event,
  ) async* {
    yield event;
  }
}
