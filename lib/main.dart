import 'package:db_practice/counter_cubit.dart';
import 'package:db_practice/map_cubit.dart';
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
      home: MultiBlocProvider(
       providers: [BlocProvider( create: (context) => CounterCubit(),),
       BlocProvider(create: (context) => MapCubit())
      ],
        child: Dashboard(),
      ),
    );
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("#: ${context.watch<CounterCubit>().state}"),
      ),
      body: context.read<MapCubit>().Data.isNotEmpty
          ? ListView.builder(
              itemBuilder: (_, index) {
                return ListTile(
                  leading: Text(context.read<MapCubit>().Data[index]['data']),
                );
              },
              itemCount: context.read<MapCubit>().state.length,
            )
          : Text("No table found"),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          context.read<CounterCubit>().incrementCount();
          context.read<MapCubit>().changeMent();
          //or
          // BlocProvider.of<CounterCubit>(context , listen: false).incrementCount();
        },
        child: Text("ok"),
      ),
    );
  }
}
