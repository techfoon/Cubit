import 'package:db_practice/counter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';

void main() {
  runApp(MyMain());
}

class MyMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => CounterCubit(),
        child: Dashboard(),
      ),
    );
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

int count = 0;

class _DashboardState extends State<Dashboard> {
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("#CounterApp"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text("#: ${context.watch<CounterCubit>().state}"),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          context.read<CounterCubit>().incrementCount();
                               //or
          // BlocProvider.of<CounterCubit>(context , listen: false).incrementCount();
        },
        child: Text("ok"),
      ),
    );
  }
}
