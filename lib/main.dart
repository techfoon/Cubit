import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:db_practice/data/local/db_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyAppDash(),
    );
  }
}

class MyAppDash extends StatefulWidget {
  @override
  State<MyAppDash> createState() => _MyAppDashState();
}

class _MyAppDashState extends State<MyAppDash> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  TextEditingController updateTitleController = TextEditingController();
  TextEditingController updateDescriptionController = TextEditingController();
  List<Map<String, dynamic>> allNotes = [];

  DBHelper? mainDB;

  @override
  void initState() {
    super.initState();
    mainDB = DBHelper.getInstance;
    getInitialNotes();
  }

  getInitialNotes() async {
    allNotes = await mainDB!.getAllNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App#1"),
      ),
      body: allNotes.isNotEmpty
          ? ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (_, index) {
                return ListTile(
                  leading: Text.rich(
                    TextSpan(
                        text:
                            "Sn:${allNotes[index][DBHelper.s_no].toString()}\n",
                        children: [
                          TextSpan(text: "In:${index.toString()}"),
                        ]),
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        mainDB!.deleteNotes(
                            rowIndex: allNotes[index][DBHelper.s_no]);
                        getInitialNotes();
                      },
                      icon: Icon(Icons.delete)),
                  title: Text(allNotes[index][DBHelper.Columntitle]),
                  subtitle: Text(allNotes[index][DBHelper.columndescription]),
                  onLongPress: () {
                    updateTitleController.text =
                        allNotes[index][DBHelper.Columntitle];
                        updateDescriptionController.text =
                        allNotes[index][DBHelper.columndescription];
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
                                      borderRadius: BorderRadius.circular(21),
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
                                      borderRadius: BorderRadius.circular(21),
                                    )),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  OutlinedButton(
                                      onPressed: () {
                                        updateNotesInDB(
                                            updateIndex: allNotes[index]
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
          : Text("no notes found"),
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
                              Navigator.pop(context);
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

    bool check = await mainDB!.addNote(title: formTitle, desc: formDescription);

    String msg;

    getInitialNotes();

    if (!check) {
      msg = "note addtion is failed";
    } else {
      msg = "note added Successfully";
      getInitialNotes();
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  ////updation function

  void updateNotesInDB({required int updateIndex}) async {
    // Fetch the updated values from the controllers
    var updateFormTitle = updateTitleController.text.trim();
    var updateFormDescription = updateDescriptionController.text.trim();

    // Update the note in the database
    int check = await mainDB!.updateNotes(
        rowIndex: updateIndex,
        rowTitle: updateFormTitle,
        rowDescription: updateFormDescription);

    // Prepare a message based on the success/failure of the update
    String msg;
    if (check < 0) {
      msg = "Note update failed";
    } else {
      msg = "Note updated successfully";
      // Reload the notes after a successful update
      getInitialNotes();
    }

    // Show a snackbar with the appropriate message
    if (context.mounted) {
      // Ensure context is still valid
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }
}