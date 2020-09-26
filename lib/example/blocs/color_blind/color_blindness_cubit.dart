import 'package:bloc/bloc.dart';

class ColorBlindnessCubit extends Cubit<int> {
  ColorBlindnessCubit() : super(0);

  void increment() {
    int newState = state + 1;
    if (newState < 0) {
      newState = 8;
    }
    emit(state - 1);
  }

  void decrement() {
    int newState = state - 1;
    if (newState < 0) {
      newState = 8;
    }
    emit(state - 1);
  }

  void set(int value) {
    emit(value);
  }
}
