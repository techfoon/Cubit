import 'dart:io';
import 'dart:developer'; // for creating logs
import 'package:db_practice/model.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();

  static DBHelper getInstance = DBHelper._();

  static final String s_no = "s_no";
  static final String Columntitle = "title";
  static final String columndescription = "description";
  static final String notesDataTable = "notesData";

  ///Globle
  Database? myDB;

  Future<Database> getDb() async {
    if (myDB == null) {
      myDB = await openDb();
    } else {
      log("Database is available");
    }

    return myDB!;
  }

  ///Open DB
  Future<Database> openDb() async {
    ///data/data/yourPackageName/databases
    Directory appDirectory = await getApplicationCacheDirectory();
    String rootPath = appDirectory.path;

    /// path data/data/yourPackageName/databases/notes.db
    String dbPath = join(rootPath, "notes.db");
    log("Database Created");
    log("Table is Created");
    return await openDatabase(dbPath, version: 1, onCreate: (db, version) {
      db.rawQuery(
          "create table $notesDataTable($s_no integer primary key autoincrement, $Columntitle text, $columndescription text)");
    });
  }

  //queries


    ///get all data
  Future<List<Map<String, dynamic>>> getAllNotes() async {
    var db = await getDb();
    var allNotes = await db.query(notesDataTable);
    log("Data is Fetching");

    return allNotes;
  }

  
  ///insert
  Future<bool> addNote({required NoteModel newNote}) async {
    var db = await getDb();
    int rowsEffected = await db
        .insert(notesDataTable, {Columntitle: newNote.Model_title, columndescription: newNote.Model_description});

    stdout.write("method is called return: $rowsEffected");
    log("Data is Inserted");

    return rowsEffected > 0;
  }



  ///delete the specific data
  Future<bool> deleteNotes({required int rowIndex}) async {
    var db = await getDb();

    // Use rawDelete for delete operations
    int deletedCount = await db
        .rawDelete("DELETE FROM $notesDataTable WHERE s_no = ?", [rowIndex]);
    log("Data is Deleted");

    return deletedCount > 0; // Returns the number of rows affected
  }

  ///Update the specific data

  Future<bool> updateNotes({
    required int rowIndex,
    required String rowTitle,
    required String rowDescription,
  }) async {
    var db = await getDb();

    // Use rawUpdate for update operations
    int updatedCount = await db.rawUpdate(
        "UPDATE $notesDataTable SET $Columntitle = ?, $columndescription = ? WHERE s_no = ?",
        [rowTitle, rowDescription, rowIndex]);

    return updatedCount > 0; // Returns the number of rows affected
  }
/*
Used rawUpdate instead of rawQuery.
Returned int to indicate the number of rows updated.
Used placeholders (?) to safely pass values and avoid SQL injection risks.
Removed the incorrect from keyword from the UPDATE query.*/
}
