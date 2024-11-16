import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:db_practice/cubits/notes_state.dart';
import 'package:db_practice/data/local/db_helper.dart';
import 'package:db_practice/model.dart';

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

  void addmNotes({required NoteModel newNote}) async {
    //action
    emit(NotesLoadingState());

    var check = await mainDB.addNote(newNote:newNote);

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

  void updateNotes(
      {required int rowIndex,
      required String rowTitile,
      required String rowDescription}) async {
    emit(NotesLoadingState());

    var check = await mainDB.updateNotes(
        rowIndex: rowIndex,
        rowTitle: rowTitile,
        rowDescription: rowDescription);

    if (check) {
      log("notes updated");
      var notes = await mainDB.getAllNotes();
      //facting and reInform
      emit(NotesLoadedState(mNotes: notes));
    } else {
      log("updated failed");
      emit(NotesErrorState(errorMsg: "updated failed"));
    }
  }

  void deleteNotes({required int rowIndex}) async{
    emit(NotesLoadingState());
    var check =  await mainDB.deleteNotes(rowIndex: rowIndex);

       if (check) {
      log("notes updated");
      var notes = await mainDB.getAllNotes();
      //facting and reInform
      emit(NotesLoadedState(mNotes: notes));
    } else {
      log("updated failed");
      emit(NotesErrorState(errorMsg: "updated failed"));
    }
  }
}
