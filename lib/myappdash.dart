import 'dart:developer';
import 'model.dart';

import 'package:db_practice/cubits/crudcubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';

import 'cubits/notes_state.dart';
import 'data/local/db_helper.dart';

class MyAppDash extends StatefulWidget {
  @override
  State<MyAppDash> createState() => _MyAppDashState();
}

class _MyAppDashState extends State<MyAppDash> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  TextEditingController updateTitleController = TextEditingController();
  TextEditingController updateDescriptionController = TextEditingController();
  List<Map<String, dynamic>> AllNotes = [];

  DBHelper? mainDB;

  @override
  void initState() {
    super.initState();
    //mainDB = DBHelper.getInstance;
    context.read<CrudCubit>().fetchInitialNotes();
  }

  /*getInitialNotes() async {

    setState(() {});
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App#1"),
      ),
      body: BlocBuilder<CrudCubit, NotesState>(builder: (context, state) {
        if (state is NotesLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is NotesErrorState) {
          return Center(child: Text('Error : ${state.errorMsg}'));
        } else if (state is NotesLoadedState) {
          return state.mNotes.isNotEmpty
              ? ListView.builder(
                  itemCount: state.mNotes.length,
                  itemBuilder: (_, index) {
                    return ListTile(
                      leading: Text.rich(
                        TextSpan(
                            text:
                                "Sn:${state.mNotes[index][DBHelper.s_no].toString()}\n",
                            children: [
                              TextSpan(text: "In:${index.toString()}"),
                            ]),
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            context.read<CrudCubit>().deleteNotes(
                                rowIndex: state.mNotes[index][DBHelper.s_no]);
                          },
                          icon: Icon(Icons.delete)),
                      title: Text(state.mNotes[index][DBHelper.Columntitle]),
                      subtitle:
                          Text(state.mNotes[index][DBHelper.columndescription]),
                      onLongPress: () {
                        updateTitleController.text =
                            state.mNotes[index][DBHelper.Columntitle];
                        updateDescriptionController.text =
                            state.mNotes[index][DBHelper.columndescription];
                        showModalBottomSheet(
                            context: context,
                            builder: (_) {
                              return Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(20),
                                child: Column(children: [
                                  Text(
                                    "Notes data",
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    controller: updateTitleController,
                                    decoration: InputDecoration(
                                        label: Text("Enter your title"),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(21),
                                        )),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    controller: updateDescriptionController,
                                    decoration: InputDecoration(
                                        label: Text("update your Description"),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(21),
                                        )),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      OutlinedButton(
                                          onPressed: () {
                                            updateNotesInDB(
                                                updateIndex: state.mNotes[index]
                                                    [DBHelper.s_no]);
                                            Navigator.pop(context);
                                          },
                                          child: Text("update")),
                                      OutlinedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("cancel")),
                                    ],
                                  )
                                ]),
                              );
                            });
                      },
                    );
                  })
              : Text("no notes found");
        }

        return Container();
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (_) {
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  child: Column(children: [
                    Text(
                      "New Notes data",
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                          label: Text("Enter your title"),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                          label: Text("Enter your Description"),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                          )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                            onPressed: () {
                              addNotesInDB();
                            },
                            child: Text("add")),
                        OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("cancel")),
                      ],
                    )
                  ]),
                );
              });

          // mainDB!.addNote(title: "kumar", desc: "baman");
          // getInitialNotes();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void addNotesInDB() async {
    var formTitle = titleController.text.toString();
    var formDescription = descriptionController.text.toString();

    context.read<CrudCubit>().addmNotes(
        newNote: NoteModel(
            Model_title: formTitle, Model_description: formDescription));

    //Navigator.pop(context);

    /* bool check = await mainDB!.addNote(title: formTitle, desc: formDescription);
    String msg;

    getInitialNotes();
    if (!check) {
      msg = "note addtion is failed";
    } else {
      msg = "note added Successfully";
      getInitialNotes();
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));*/
  }

  ////updation function

  void updateNotesInDB({required int updateIndex}) async {
    // Fetch the updated values from the controllers
    var updateFormTitle = updateTitleController.text.trim();
    var updateFormDescription = updateDescriptionController.text.trim();

    context.read<CrudCubit>().updateNotes(
        rowIndex: updateIndex,
        newNote: NoteModel(
            Model_title: updateFormTitle,
            Model_description: updateFormDescription));
  }
}
