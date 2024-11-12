abstract class NotesState {}

class NotesInitialState extends NotesState {} // Jab App first time open ho tab

class NotesLoadingState extends NotesState {} // to show loader

class NotesLoadedState extends NotesState {
  List<Map<String, dynamic>> mNotes;

  NotesLoadedState({required this.mNotes});
} // to show data after anyaction

class NotesErrorState extends NotesState {
  String errorMsg;
  NotesErrorState({required this.errorMsg});
} // to shows errors
