import 'package:bloc/bloc.dart';
import 'package:db_practice/cubits/notes_state.dart';
import 'package:db_practice/myappdash.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:db_practice/cubits/crudcubit.dart';
import 'package:flutter/material.dart';
import 'package:db_practice/data/local/db_helper.dart';
import 'package:path/path.dart';

void main() {
  runApp(BlocProvider(
    create: (context) => CrudCubit(mainDB: DBHelper.getInstance),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyAppDash(),
    );
  }
}

//
///
///
///
///
///
///


