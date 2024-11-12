import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:db_practice/cubits/notes_state.dart';
import 'package:db_practice/data/local/db_helper.dart';

class CrudCubit extends Cubit<NotesState> {
  DBHelper mainDB;

  //CrudCubit(super.initialState, {required this.mainDB});
  //OR
  CrudCubit({required this.mainDB}) : super(NotesInitialState());

  void fetchInitialNotes() async {
    emit(NotesLoadingState());
    var notes = await mainDB.getAllNotes();
    emit(NotesLoadedState(mNotes: notes));
  }

  void addmNotes({required String cTitle, required String cDescription}) async {

    //action
    emit(NotesLoadingState());

    var check = await mainDB.addNote(title: cTitle, desc: cDescription);

    if (check) {
      log("notes added");
      var notes = await mainDB.getAllNotes();
      //facting and reInform
      emit(NotesLoadedState(mNotes: notes));
    } else {
      log("addtion failed");
      emit(NotesErrorState(errorMsg: "addion failed"));
    }
  }

  bool updateNotes() {
    return true;
  }

  bool deleteNotes() {
    return true;
  }
}
