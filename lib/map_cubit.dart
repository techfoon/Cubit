import 'package:flutter_bloc/flutter_bloc.dart';

class MapCubit extends Cubit<List<Map<String, dynamic>>> {
  MapCubit() : super([]);

  List<Map<String, dynamic>> Data = [];
  void changeMent() {
    emit(Data = [
      {"data": "data"},
      {"data": "data1"},
      {"data": "data2"}
    ]);
  }
}
