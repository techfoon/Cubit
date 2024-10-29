import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0); // initial value is zero

  //event

  void incrementCount() {
    emit(state + 1);
  }

 
}
