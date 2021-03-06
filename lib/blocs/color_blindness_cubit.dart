import 'package:bloc/bloc.dart';

class ColorBlindnessCubit extends Cubit<int> {
  ColorBlindnessCubit() : super(0);

  void increment() {
    int newState = state + 1;
    if (newState > 8) {
      newState = 0;
    }
    emit(newState);
  }

  void decrement() {
    int newState = state - 1;
    if (newState < 0) {
      newState = 8;
    }
    emit(newState);
  }

  void set(int value) {
    emit(value);
  }
}
